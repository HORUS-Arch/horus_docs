# horus_session

The **session + data** layer: one node, `session` (`/horus/session`), that owns the subjects, their
calibration index and the recorded trials, exposed as services so a web UI (which can't touch the
local filesystem) can drive it. A trial is recording or it is not; there is no phase machine. It never
runs a tree: sequencing is the supervisor's job. It follows the supervisor's state to open and close
trials (`record: per_run`) and to log events into them.

On-disk layout under `data_root` (default `~/horus_data`, a visible persistent folder):
`subjects/<id>/{profile.yaml, calibration/<node>/<unit>_<time>.yaml, trials/<tid>/{bag/, trial.yaml}}`,
plus `trash/` for deleted subjects (delete moves, never erases).

## Dependencies

`rclpy`, `horus_msgs`, `human_msgs`, `rcl_interfaces`, `rosbag2` (`ros2 bag` CLI), `pyyaml`.

## Nodes

- `session`, the node. Plain helpers it owns: `SubjectStore` (`subjects.py`: profiles, calibration
  index, trash) and `TrialRecorder` (`recorder.py`: runs `ros2 bag record` as a subprocess into
  `trials/<tid>/bag/` and keeps `trial.yaml`).
- `session_client`, a CLI to START, hold, STOP a trial (smoke test without the UI or the supervisor).

## Behaviour

- **SELECT** (`SessionControl` command 2) selects the subject for the whole system: it sets the
  parameter `subject_id` on every `<human_namespace>/<name>` node that serves `load_calibration`, and
  calls `load_calibration` on it so its newest calibration files apply. `SessionState.subject_id` is
  the selected subject, also when no trial is open. The subject cannot change while a trial records.
- **Recording** follows `record`:

  | `record` | Opens a trial | Closes it |
  |---|---|---|
  | `per_run` (default) | the supervisor enters RUN | the supervisor is back in STANDBY |
  | `manual` | `SessionControl` START (UI, `StartRecording` leaf) | `SessionControl` STOP (UI, `StopRecording` leaf) |

- **An emergency stop never stops a recording.** It is logged; the trial closes on RESET or
  `post_stop_record` s later, whichever comes first, with outcome `emergency_stop`.
- **`trial.yaml`**: `trial_id`, `subject_id`, `devices`, `start_time`, `stop_time`, `outcome`
  (`completed` | `stopped` | `emergency_stop` | `interrupted`), `topics`, `calibrations` (paths of the
  subject's newest calibration files at start), `events` (mode changes, device problems and
  recoveries from `SupervisorState.faults` / `warnings`, the auto-close), `notes`.
- Deleting the subject that is recording is refused.

## ROS2 API

### Services

| Name | Type | Description |
|---|---|---|
| `~/create_subject` | `horus_msgs/CreateSubject` | write a profile (explicit id must be unique; empty id auto-generates) |
| `~/get_subject` | `horus_msgs/GetSubject` | read one profile |
| `~/list_subjects` | `horus_msgs/ListSubjects` | every profile (the UI's picker) |
| `~/update_subject` | `horus_msgs/UpdateSubject` | replace a profile (keeps `created_at`) |
| `~/delete_subject` | `horus_msgs/DeleteSubject` | move a subject to `trash/`; refused if it has trials unless `force`, and while it is recording |
| `~/list_calibrations` | `horus_msgs/ListCalibrations` | a subject's calibration files, newest first, `latest` per node + unit |
| `~/session_control` | `horus_msgs/SessionControl` | SELECT a subject; START a trial (optional `subject_id` selects it first, optional `topics`); STOP it |
| `~/add_trial_note` | `horus_msgs/AddTrialNote` | append a timestamped note to the open trial |

### Published topics

| Topic | Type | Description |
|---|---|---|
| `~/state` | `horus_msgs/SessionState` (latched) | `active`, selected `subject_id`, `trial_id`, `started_at`, `record_mode`, `message` |

### Subscribed topics

| Topic | Type | Description |
|---|---|---|
| `supervisor_state_topic` | `horus_msgs/SupervisorState` (latched) | opens / closes `per_run` trials, logs mode changes and device problems into the open trial |

### Service clients

| Name | Type | Description |
|---|---|---|
| `<human_namespace>/<name>/set_parameters` | `rcl_interfaces/SetParameters` | SELECT: set `subject_id` |
| `<human_namespace>/<name>/load_calibration` | `horus_msgs/LoadCalibration` | SELECT: load the subject's newest calibrations |

### Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `data_root` | string | `~/horus_data` | root of the on-disk store |
| `devices` | string[] | `[""]` | devices on this rig, written into `trial.yaml` |
| `record` | string | `per_run` | `per_run` or `manual`, see above |
| `post_stop_record` | double | `30.0` | s a trial keeps recording after an emergency stop |
| `record_all` | bool | `true` | `ros2 bag record -a` minus `exclude`; else the `topics` subset |
| `exclude` | string[] | `/parameter_events`, `/rosout`, `/rosout_agg` | regexes dropped when `record_all` |
| `topics` | string[] | `[""]` | explicit subset when `record_all` is false |
| `human_namespace` | string | `/human` | where SELECT looks for sensing nodes |
| `supervisor_state_topic` | string | `/horus/supervisor/state` | supervisor state input |

Topic selection, highest first: START's `topics` > `record_all` (minus `exclude`) > `topics`.
Example config: `config/recording.yaml` (the rig's `system.recording`).

## Usage

```bash
ros2 launch horus_bringup managed.launch.py            # mock + this node (record: manual)
ros2 run horus_session session_client --subject s1 --hold 5
ros2 service call /horus/session/session_control horus_msgs/srv/SessionControl "{command: 2, subject_id: s1}"   # SELECT
```

## Tests

`test/test_session.py`, `test/test_recorder.py` (pytest): subject create / duplicate / list / update /
delete, the calibration index, SELECT of an unknown subject, `per_run` trials with an emergency stop,
completed runs and `manual` mode, the `ros2 bag record` command builder, and trial notes. Run with
`colcon test --packages-select horus_session`.
