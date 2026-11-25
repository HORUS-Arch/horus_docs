# horus_bt

The HORUS **executive**, level 2 of the hierarchy, as a **library** (no node, no action): the HORUS
[BehaviorTree.CPP](https://www.behaviortree.dev) v4 leaves and `horus_bt::TreeRunner`, which
`horus_supervisor` uses to run the tree of each mode in-process (nav2's `nav2_behavior_tree` role;
the supervisor is the `bt_navigator`). Trees are **XML data**, not code: they sequence generator
behaviors and calibrations, act on the session, and do bounded local recovery. Controllers are never
switched from a tree; one controller runs the whole session.

## Dependencies

`rclcpp`, `rclcpp_action`, `behaviortree_cpp`, `ament_index_cpp`, `sensor_msgs`, `std_msgs`,
`diagnostic_msgs`, `horus_msgs`.

## TreeRunner

`horus_bt/tree_runner.hpp`. Registers the HORUS leaves, loads every `*.xml` of the given folders and
ticks one tree at a time on its own thread.

| Method | Description |
|---|---|
| `TreeRunner(node, tick_hz)` | register the leaves on `node` (which must declare `generator_action`) and start the tick thread |
| `load(dirs)` | register every `*.xml` of the folders (`""` = this package's `behavior_trees/`); returns the file count, throws on a bad file |
| `trees()` | ids of the registered trees |
| `start(tree, id, done)` | run `tree`, replacing any running tree; `done(id, ok, message)` is called once from the tick thread |
| `stop()` | halt the running tree; no result is reported |

`start()` and `stop()` never block: the tick thread picks the request up within microseconds, halts
the running tree and builds the next one, so a mode change never waits for a tick. A tree that is
replaced or stopped reports nothing. One `ExecuteBehavior` action client is created once and shared
by every tree, so a new tree never waits for ROS discovery.

## BT leaf nodes (registered for use in the XML)

The node every leaf receives is the one that runs the trees (the supervisor). Each leaf owns a
private callback-group executor, drained on every tick, so it works standalone or composed.

| Node | Kind | Ports | Effect |
|---|---|---|---|
| `ExecuteBehavior` | action | `behavior` | run a `generator_server` behavior (`generator_action`) to completion; halting it cancels the goal |
| `Calibrate` | action | `node`, `unit`, `duration`, `subject_id`, `save` | run `<node>/calibrate` on a HORUS processing node; with `save` (default true) save the result with `<node>/save_calibration` for `subject_id`, or the session's selected subject when empty |
| `IsAtPose` | condition | `joints`, `positions` (comma lists), `tolerance`, `topic` | SUCCESS when every joint is within tolerance of its target (`/joint_states`) |
| `IsHealthy` | condition | `source`, `level` | SUCCESS while no `/diagnostics` status containing `source` is at `level` (`warn` or `error`, default `error`) or worse; STALE counts as worse |
| `WaitForMessage` | action | `topic`, `type`, `timeout` | RUNNING until any message arrives on the topic (any type, e.g. a gait event); FAILURE after the timeout |
| `EmergencyStop` | action | `reason` | publish `reason` on `/horus/supervisor/estop_request`; always SUCCESS (the mode change halts the tree) |
| `StartRecording` | action | `timeout` | `SessionControl` START on `/horus/session/session_control` |
| `StopRecording` | action | `timeout` | `SessionControl` STOP |
| `AddTrialNote` | action | `text`, `timeout` | add a note to the open trial (`/horus/session/add_trial_note`) |
| `SetSpeedScale` | action | `value`, `generator` | set `speed_scale` on the generator server (`generator`, or the node part of `generator_action`) |

Service leaves fail after `timeout` s (default 2) without a reply, or when the reply is not a success.

## Default trees

`behavior_trees/trial.xml` (installed to `share/horus_bt/behavior_trees/`, the default `tree_dirs`):

| Tree | Mode | Does |
|---|---|---|
| `Trial` | RUN | `ReactiveSequence` guarded by `IsHealthy`; home (retried once), `IsAtPose`, walk, home |
| `RecordOnly` | RUN | moves nothing, runs until STOP (data acquisition without motion) |
| `Calibration` | RUN | scripted calibrations, saved for the session's subject |
| `Manual` | MANUAL | runs the `manual` behavior until the operator leaves |
| `Recovery` | RECOVERY | home, retried once; failure goes to EMERGENCY_STOP |

Copy and edit them per study (the joint names are the mock's).

## Usage

```bash
ros2 launch horus_bringup trial.launch.py       # mock + generator_server + supervisor (runs the trees)
ros2 service call /supervisor/command horus_msgs/srv/SupervisorCommand "{command: 0, tree: Trial}"
```

Write a new leaf: add its header to `include/horus_bt/` and register it in the `TreeRunner`
constructor (`src/tree_runner.cpp`).

## Tests

None in this package; the leaves and the runner are exercised end to end by `horus_bringup`'s
launch test (`test/test_trial.launch.py`: START the mock `Trial`, expect STANDBY with the tree
completed).
