# horus_supervisor

Level 1 of the HORUS hierarchy: the **global-mode supervisor**. A mode answers one question: who may
move the device right now? Exactly one mode is active at a time, and safety events always win. The
supervisor also **runs the tree of each mode in-process** (the role of nav2's `bt_navigator`), with the
leaves and the `TreeRunner` of `horus_bt`. It only coordinates: hard safety (limits, watchdogs, the
device's safe behaviour) stays in the controllers (`horus_control/SafetyController`) and the hardware.

| Mode | Who commands the device | Tree |
|---|---|---|
| INIT (0) | nobody (starting, no operator yet) | none |
| STANDBY (1) | nobody; setup, calibration and recording happen here | none |
| RUN (2) | the protocol tree | START's `tree`, else `trees.run` |
| MANUAL (3) | the operator (UI joint sliders) | `trees.manual` |
| RECOVERY (4) | the recovery tree, after a protocol failure | `trees.recovery` |
| EMERGENCY_STOP (5) | nobody; latched | none: entering it halts the running tree |

```mermaid
stateDiagram-v2
  [*] --> INIT
  INIT --> STANDBY: READY / STOP
  STANDBY --> RUN: START
  STANDBY --> MANUAL: MANUAL
  RUN --> STANDBY: STOP / tree succeeded
  MANUAL --> STANDBY: STOP / tree ended
  RUN --> RECOVERY: tree failed
  RECOVERY --> STANDBY: tree succeeded
  RECOVERY --> EMERGENCY_STOP: tree failed
  EMERGENCY_STOP --> STANDBY: RESET (no active fault)
```

READY is raised by the supervisor once the trees are loaded and the operator is connected (or the
heartbeat is disabled). From every mode, ESTOP and FAULT go to EMERGENCY_STOP; OPERATOR_LOST does so
from RUN, MANUAL and RECOVERY. Events are handled as they arrive, highest class first: safety (ESTOP,
FAULT, OPERATOR_LOST) > escalation (TREE_FAILED) > operator (READY, START, STOP, MANUAL, RESET) >
progress (TREE_SUCCEEDED). A request that isn't allowed in the current mode is rejected, and the mode
doesn't change.

The transition logic is `ModeMachine`, plain C++ with no ROS, unit-tested on its own.

## Device contract

The supervisor reads `/diagnostics` and classifies every source against `critical_sources`:

| Level | Reaction |
|---|---|
| OK | nothing |
| WARN | warning (in `warnings`, UI banner, event in `trial.yaml`) |
| ERROR / STALE from a critical source | FAULT: EMERGENCY_STOP; RESET refused until it clears (in `faults`) |
| ERROR / STALE from a non-critical source | warning; the run continues |
| silent for `stale_timeout` | counts as ERROR only while the device moves (RUN, MANUAL, RECOVERY); when idle it is a warning, so a device disconnected on purpose does not block RESET |

## Dependencies

`rclcpp`, `rclcpp_components`, `horus_bt`, `diagnostic_msgs`, `std_msgs`, `horus_msgs`.

## ROS2 API

### Services

| Name | Type | Description |
|---|---|---|
| `~/command` | `horus_msgs/SupervisorCommand` | START (0, optional `tree` = protocol), STOP (1), MANUAL (2), RESET (3), EMERGENCY_STOP (4). START and MANUAL are refused while the operator is not connected, when the tree is unknown, or (START, `require_subject`) when no subject is selected |

### Subscribed topics

| Topic | Type | Description |
|---|---|---|
| `~/estop` | `std_msgs/Empty` | emergency stop (hardware button bridge, UI) |
| `~/estop_request` | `std_msgs/String` | emergency stop with a reason (the `EmergencyStop` leaf) |
| `~/heartbeat` | `std_msgs/Empty` | operator liveness (the UI publishes it every 0.5 s through rosbridge) |
| `/diagnostics` | `diagnostic_msgs/DiagnosticArray` | device contract, see above |
| `/horus/session/state` | `horus_msgs/SessionState` (latched) | the selected subject, for `require_subject` |

### Published topics

| Topic | Type | Description |
|---|---|---|
| `~/state` | `horus_msgs/SupervisorState` (latched) | mode, previous mode, reason, running tree, since, faults, warnings, operator connected, protocols (registered tree ids) |

### Action clients (from the tree leaves)

| Name | Type | Description |
|---|---|---|
| `generator_action` | `horus_msgs/ExecuteBehavior` | the `ExecuteBehavior` leaf |
| `<node>/calibrate` | `horus_msgs/Calibrate` | the `Calibrate` leaf |

### Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `trees.run` | string | `""` | default protocol for START |
| `trees.manual` | string | `""` | tree of MANUAL; `""` refuses MANUAL |
| `trees.recovery` | string | `""` | tree of RECOVERY; `""` goes straight to EMERGENCY_STOP |
| `tree_dirs` | string[] | `[""]` | folders of BT XML; `""` = `horus_bt`'s `behavior_trees/` (an empty YAML list `[]` has no type, so write `[""]`) |
| `tick_hz` | double | `20.0` | tree tick rate |
| `generator_action` | string | `/horus/generator_server/execute_behavior` | read by `ExecuteBehavior` and `SetSpeedScale` |
| `critical_sources` | string[] | `[""]` | diagnostic names (substrings) whose ERROR / STALE is a fault; `[""]` = every source |
| `stale_timeout` | double | `0.0` | s without a status before a source is stale; `0` = off |
| `heartbeat_timeout` | double | `0.0` | s without heartbeat while moving means EMERGENCY_STOP; `0` = off |
| `require_subject` | bool | `false` | START needs a subject selected in the session |
| `session_state_topic` | string | `/horus/session/state` | session state input |
| `diagnostics_topic` | string | `/diagnostics` | device health input |
| `rate` | double | `10.0` | Hz, heartbeat and staleness check |

## Usage

```bash
ros2 service call /horus/supervisor/command horus_msgs/srv/SupervisorCommand "{command: 0, tree: Trial}"   # START
ros2 service call /horus/supervisor/command horus_msgs/srv/SupervisorCommand "{command: 1}"                # STOP
ros2 topic pub --once /horus/supervisor/estop std_msgs/msg/Empty
ros2 service call /horus/supervisor/command horus_msgs/srv/SupervisorCommand "{command: 3}"                # RESET
```

Example config: `config/supervisor.example.yaml`.

## Tests

`test/test_mode_machine.cpp` (gtest):
- the normal session path;
- manual control;
- escalation from run to recovery to emergency stop;
- safety wins from every mode;
- a lost operator stops only while the device moves;
- arbitration (disallowed requests are rejected);
- a fault must clear before RESET;
- priority classes.
