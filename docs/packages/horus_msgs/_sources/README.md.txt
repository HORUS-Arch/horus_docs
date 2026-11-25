# horus_msgs

The HORUS interfaces: the single message / service / action package the framework binds to. Every node
and tool depends on it. It depends on `human_msgs` (for `Anthropometrics`); the reverse never happens.

Deliberately minimal, a type is added only when a real producer and a real consumer both need it.
Device-specific parameter/mode services are defined with each driver, not here.

More messages were necessary for many modules to communicate, but they were generic like `sensor_msgs`
and `geometry_msgs`, though related to the human and assistive device state, so a specific package was
created outside of HORUS called `human_msgs`.

## Messages

| Message | Description |
|---|---|
| `SubjectProfile` | Who the subject is: identity, demographics, and their body measurements as an embedded `human_msgs/Anthropometrics`. |
| `TrialInfo` | Metadata for one recorded trial, written next to the bag: the devices used, start and stop times, and the notes taken during the run. |
| `TrialNote` | A single timestamped note written live while a trial is running. |
| `SupervisorState` | The supervisor's global mode (latched): INIT, STANDBY, RUN, MANUAL, RECOVERY, EMERGENCY_STOP, plus previous mode, reason, running tree, since, faults (critical sources in ERROR / STALE), warnings, operator connection and the registered protocols. |
| `SessionState` | The latched session banner: selected subject, whether a trial is recording, trial id, start time, record mode (`per_run` / `manual`) and a short detail. |
| `BehaviorState` | The generator_server's current behavior (latched): name, plugin, active, finished. Read by the UI and by behavior-tree conditions. |
| `CalibrationFile` | One saved calibration file: node, unit, plugin, path, date, and whether it is the latest. |
| `Candidate` | One parameter set proposed by an optimizer; cost samples refer back to it by id. |
| `CostSample` | One cost evaluation of a candidate, typically per gait cycle. |

## Services

| Service | Description |
|---|---|
| `CreateSubject` / `GetSubject` / `ListSubjects` / `UpdateSubject` / `DeleteSubject` | Subject records on disk. The session owns the files, so a client (including a web UI that cannot touch the filesystem) never writes them directly. Delete moves the folder to `trash/` and refuses a subject with trials unless `force` is set. |
| `SupervisorCommand` | Operator request to the supervisor: START (a protocol), STOP, MANUAL, RESET, EMERGENCY_STOP; rejected if not allowed in the current mode. |
| `SessionControl` | SELECT a subject (its calibrations load on every sensing node), START or STOP a trial (recording). START may override the recorded topics. |
| `SaveCalibration` / `LoadCalibration` | Save a node's pending calibration for a subject, or apply a saved file (empty path = latest for the subject). |
| `ListCalibrations` | A subject's saved calibration files, newest first (served by the session). |
| `AddTrialNote` | Add a timestamped note to the running trial. |
| `ManageLifecycleNodes` | Drive managed nodes through their state machine (`STARTUP`, `SHUTDOWN`, `PAUSE`, `RESUME`, `RESET`, `CONFIGURE`, `CLEANUP`), either the whole ordered set or one named node. |

## Actions

| Action | Description |
|---|---|
| `ExecuteBehavior` | Run one named generator behavior to completion, with optional typed parameter overrides. Finite behaviors end on their own; continuous ones run until canceled. |
| `Calibrate` | Collect data for a unit (segment, muscle, side) or all, compute the calibration with the node's plugin, keep it pending until saved. Progress as feedback. |
| `Optimize` | Human-in-the-loop optimization of a behavior's parameters: candidates in, cost per cycle back, best candidate as the result. Reserved for the optimization layer. |

All actions follow this convention: **no success flag**. The outcome rides the action's built-in goal status (succeeded / aborted / canceled), and the result carries an `error_code` plus a message explaining *why*, so clients can branch on a code rather than parse text.
