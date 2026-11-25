# horus_generator_pattern

The shipped **`Generator`** plugins, all configured entirely in YAML:

| Plugin | Does |
|---|---|
| `horus_generator_pattern/Pattern` | periodic waveforms per joint, finite or cycling |
| `horus_generator_pattern/Waypoints` | joint waypoints from YAML or CSV (see below) |
| `horus_generator_pattern/Manual` | MANUAL mode: follows the operator's joint sliders (see below) |

`Pattern` covers the two most common needs, *"settle to a pose"* and *"play a periodic
gait"*, without anyone writing code, and it is the reference example for authoring your own generator.

## How it works

Every signal shares one **cycle** of length `cycle_time`, divided by `speed_factor`. Each tick the
plugin advances a phase through that cycle, then samples each signal's waveform at that phase, shifted
by the signal's own `phase_offset`. That offset is what produces a gait: hip, knee and ankle play the
same cycle a little behind one another.

```mermaid
flowchart LR
  p["phase advances<br/>period / cycle_time"] --> w
  subgraph w["one sample per signal"]
    h["hipR: sine, offset 0.00"]
    k["kneeR: sine, offset 0.15"]
    a["ankleR: sine, offset 0.30"]
  end
  w --> out["reference vector<br/>ordered like signals"]
```

The output is ordered exactly like the `signals` list, and that order **must match the target
controller's joint order**, the reference is a plain number vector with no names in it. Values are
written directly in the controller's units, there is no unit conversion in the plugin.

`speed_factor` is a **multiplier**, not an absolute speed: `2.0` plays the same cycle twice as fast.
This follows MARCH, whose gait phases scale a base step size the same way, and it keeps the cadence
meaningful for any pattern, not just ones that correspond to walking a distance.

### How a behavior ends

`cycling` decides it. A **non-cycling** pattern plays its cycle once, then `finished()` reports true so
a behavior tree's `ExecuteBehavior` completes and moves on. A **cycling** pattern repeats forever and
ends only when the tree cancels it.

Completion is therefore intrinsic to the motion rather than a timer, the same way MARCH ends a phase
when its plan is exhausted. That is what lets one plugin serve both roles: `home` is a non-cycling
zero-amplitude pattern (settle, then finish), while a real gait is normally left cycling so the tree,
not a stopwatch, decides when walking stops.

## Parameters

Read under the behavior's instance name (`<name>.*`), as declared in `generator_server`'s
`generator_plugins`.

| Parameter | Description |
|---|---|
| `signals` | The per-joint signal names. The output vector is ordered like this list and must match the controller's joints. Omit it for a single-joint pattern, whose parameters are then read at the top level. |
| `<signal>.type` | Waveform: `sine`, `square`, `triangle` or `custom`. Defaults to `sine`. |
| `<signal>.min` / `.max` | Bounds of the waveform. Setting both to the same value holds a constant, which is how a "settle to a pose" behavior is written. |
| `<signal>.middle` | The mean line the waveform oscillates about. Defaults to the midpoint of `min` and `max`. |
| `<signal>.custom` | One full cycle as an arbitrary-length table, used when `type: custom`. Values must be floats in YAML (`0.0`, not `0`). |
| `<signal>.phase_offset` | How far ahead in the cycle this signal leads, as a fraction `[0,1)`. This is what staggers joints into a gait. |
| `cycle_time` | Seconds for one full cycle at `speed_factor` 1.0. |
| `speed_factor` | Cadence multiplier. `2.0` plays the cycle twice as fast; the effective cycle is `cycle_time / speed_factor`. |
| `cycling` | `true` repeats until canceled; `false` plays one cycle and then reports finished. |

## Usage

See `config/example.yaml` for a complete block, and
`horus_bringup/config/mock_generators.yaml` for the two behaviors used by the mock trial:

```yaml
walk:
  plugin: horus_generator_pattern/Pattern
  cycle_time: 2.0                    # seconds per gait cycle
  speed_factor: 1.0                  # multiplier; 2.0 = twice as fast
  cycling: true                      # false = one cycle then finished()
  signals: [hipR, kneeR, ankleR]     # output order must match the controller's joints
  hipR:   {type: sine, min: -0.3, max: 0.3, phase_offset: 0.0}
  kneeR:  {type: sine, min:  0.0, max: 0.5, phase_offset: 0.15}
  ankleR: {type: sine, min: -0.2, max: 0.2, phase_offset: 0.3}
```

## Waypoints plugin

`horus_generator_pattern/Waypoints` follows joint waypoints: home, sit, stand, recorded gaits.

```yaml
home:
  plugin: horus_generator_pattern/Waypoints
  joints: [hipR, kneeR, ankleR]
  times: [0.0, 2.0]                       # s from the start
  positions: [0.0, 0.0, 0.0,              # one row of joints per time
              0.0, 0.0, 0.0]
  interpolation: smooth                   # smooth (zero velocity at each waypoint) | linear
  start_from_current: true                # first row = the measured pose (/joint_states): home from anywhere
  cycling: false                          # true = loop (make the first and last rows equal)
  # file: /path/sit_to_stand.csv          # instead of times/positions: "time,hipR,kneeR,ankleR" rows
```

Speed is the server's live `speed_scale`; one-run changes go in the ExecuteBehavior goal `parameters`.

## Manual plugin

`horus_generator_pattern/Manual` is the behavior of MANUAL mode: the device follows targets sent by
the operator (the UI joint sliders).

```yaml
manual:
  plugin: horus_generator_pattern/Manual
  joints: [hipR, kneeR, ankleR]
  quantity: position          # position | effort
  max_rate: 0.5               # rad/s (position) or N m/s (effort)
  min: [-0.5, 0.0, -0.3]      # optional clamp per joint (default: none)
  max: [ 0.8, 1.2,  0.3]
  timeout: 1.0                # s without a target -> hold
  topic: ~/manual_target
```

| Parameter | Default | Description |
|---|---|---|
| `joints` | — | output order |
| `quantity` | `position` | `position` or `effort`: which field of the target `JointState` is read |
| `max_rate` | `0.5` | the output moves toward the target at most this much per second, so a slider jump is a ramp, never a step |
| `min` / `max` | none | optional clamp per joint; both lists must have one value per joint |
| `timeout` | `1.0` | s without a target before the target freezes at the current output (hold) |
| `topic` | `~/manual_target` | `sensor_msgs/JointState` targets (names + `position`, or + `effort`); joints not named keep their target |
| `joint_states_topic` | `/joint_states` | measured pose |

Position output starts at the measured pose, effort output at zero. Continuous: `finished()` stays
false and the behavior runs until canceled (the supervisor leaving MANUAL).

```bash
ros2 topic pub -r 10 /horus/generator_server/manual_target sensor_msgs/msg/JointState "{name: [hipR], position: [0.3]}"
```

## Tests

gtest: `test/test_pattern.cpp` covers waveform values, the non-cycling end condition, the
`speed_factor` scaling, the custom cycle and multi-signal output width; `test/test_waypoints.cpp`
interpolation, CSV input, cycling and the velocity / effort quantities; `test/test_manual.cpp` holding
without input, the rate limit and clamp, and holding after the timeout:

```bash
colcon test --packages-select horus_generator_pattern
```
