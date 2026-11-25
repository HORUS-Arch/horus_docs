# horus_control

The HORUS **control layer**: the real-time joint loop. It takes the reference produced by the generation
layer and turns it into commands the hardware executes, running at roughly 0.5–1 kHz in its own process.

HORUS does not implement this loop itself. It uses **`ros2_control`**, the standard ROS 2 control
framework, and this package is where HORUS's own controller plugins live.

## `ros2_control` in one paragraph

A `controller_manager` runs the loop; hardware is loaded as a plugin and exposes named **state** and
**command interfaces**; controllers are plugins that declare which interfaces they need. Controllers and
hardware never reference each other, they meet through those interface names, which is what lets one
controller binary serve many devices.

```mermaid
flowchart LR
  subgraph cm["controller_manager, one cycle @ ~1 kHz"]
    r["read()<br/>hardware → state interfaces"] --> u["update()<br/>every active controller"]
    u --> w["write()<br/>command interfaces → hardware"]
  end
  w -.->|next cycle| r
```

Everything in that box is real-time, and deliberately dumb: it tracks, it does not decide.

> See the [ros2_control documentation](https://control.ros.org/rolling/doc/getting_started/getting_started.html)
> for the framework itself, and [ros2_control_demos](https://github.com/ros-controls/ros2_control_demos)
> for runnable examples.

## Why HORUS uses it

A device is described once, in its URDF, and every controller works against that description, so adding
a device changes no controller. Controllers are selected by YAML, so the same setup runs on fake
hardware, in simulation and on real hardware with only the hardware plugin changing. And the loop gets a
real-time process of its own, isolated from everything allowed to be slow.

## How it fits with generation

Motion is split in two by rate and responsibility. **Generation** decides what the joints should do and
runs in an ordinary node at around 100 Hz. **Control** tracks that decision at real-time.

The reference topic between them is the seam: above it, nodes that may take their time; below it, a loop
that must never miss a deadline. Because the two meet only through a topic, a new motion algorithm never
touches real-time code, and a real-time change never touches the algorithms.

## Controllers

Most of a device's control stack is stock: forwarding a reference to firmware, closing a loop in
software, following a trajectory, admittance, and the broadcasters that publish joint states, wrenches
and IMU data.

> See [ros2_controllers](https://control.ros.org/rolling/doc/ros2_controllers/doc/controllers_index.html)
> for the available controllers and their parameters, and
> [writing a new controller](https://control.ros.org/rolling/doc/ros2_controllers/doc/writing_new_controller.html)
> to add one.

**This package holds HORUS's own controller plugins.** A controller earns a place here when it is generic across devices. Controllers that encode a specific hardware's command conventions cannot be PR'd to HORUS, they belong in that device's package.

## Default controllers (`config/`)

HORUS uses the stock ros2_controllers and never switches controllers during a session. Pick one,
copy its file into your robot's controllers YAML, set your joint names, and point
`generator_server` at it:

| File | Controller | `generator_server` | Use when |
|---|---|---|---|
| `forward_position.yaml` | `forward_command_controller` (position) | `output_type: float64_array`, `output_topic: /position_controller/commands` | the device closes its own position loop |
| `forward_velocity.yaml` | `forward_command_controller` (velocity) | `output_type: float64_array`, `output_topic: /velocity_controller/commands` | the generator outputs velocities |
| `joint_trajectory.yaml` | `joint_trajectory_controller` | `output_type: joint_trajectory`, `output_topic: /joint_trajectory_controller/joint_trajectory`, `joint_names: [...]` | **following waypoints** (it interpolates at the controller rate) |
| `gravity_compensation.yaml` | `horus_control/GravityCompensation` | optional effort reference on `/gravity_compensation/effort_reference` | gravity compensation from the URDF, plus an optional torque reference |
| `safety.yaml` | `horus_control/SafetyController` | `output_type: float64_array`, `output_topic: /safety_controller/commands` (direct), or chained under another controller | **always, on a real device**: the last controller before the hardware |

**Speed** is changed live on the generator side for every behavior and controller:
`ros2 param set /horus/generator_server speed_scale 1.5` (0 = hold, up to `max_speed_scale`).
**Waypoints** are a behavior: `plugin: horus_generator_pattern/Waypoints` with `joints`, `times`,
`positions` (or a CSV `file`), see the generator README.

## SafetyController

`horus_control/SafetyController` (chainable) is the **last controller before the hardware**, the role
of nav2's `collision_monitor`. Every command to the device passes through it, so it acts within one
control cycle and does not depend on the supervisor, the trees or the generators.

It **stops, latched**, when:
- a message arrives on `estop_topic` (`std_msgs/Empty`, the same topic as the UI / hardware button);
- the supervisor reports EMERGENCY_STOP on `supervisor_state_topic`;
- wired directly (not chained), no command arrived for `command_timeout` s while commands were flowing.

While stopped, a `position` interface holds the pose measured at the stop; `velocity` and `effort`
interfaces command 0. It **releases** only when the supervisor reports a mode entered after the stop
(RESET), or, after a command timeout, when commands flow again. Always: commands are clamped to
`min` / `max` per joint (position), `max_effort` (effort) or `max_velocity` (velocity), and a NaN
command is replaced by the stop value.

Two ways to wire it (`config/safety.yaml`):
- **direct** (recommended): `generator_server` `output_topic: /safety_controller/commands`; the
  command timeout is active.
- **chained** under another controller: e.g. a forward or trajectory controller whose joints are
  `safety_controller/<joint>` (it writes into the safety controller's reference interfaces); the
  emergency stop, the supervisor and the limits are active, the upstream controller's own timeout
  applies.

### Interfaces

| Kind | Names |
|---|---|
| command interfaces (claimed) | `<joint>/<interface>` for every joint |
| state interfaces | `<joint>/position` (the pose to hold) |
| reference interfaces (exported, chained mode) | `<controller name>/<joint>/<interface>` |

### Topics

| Topic | Type | Description |
|---|---|---|
| `~/commands` (subscribed) | `std_msgs/Float64MultiArray` | the reference in joint order (direct wiring) |
| `estop_topic` (subscribed) | `std_msgs/Empty` | emergency stop |
| `supervisor_state_topic` (subscribed) | `horus_msgs/SupervisorState` (latched) | EMERGENCY_STOP stops; a mode entered after the stop releases |
| `~/stopped` (published) | `std_msgs/Bool` (latched) | whether the controller is holding a stop |

### Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `joints` | string[] | `[]` | URDF joint names, in the generator's output order |
| `interface` | string | `position` | `position` (hold the pose on stop), `velocity` or `effort` (0 on stop) |
| `min` / `max` | double[] | `[]` | position clamp per joint; `[]` = none (both lists must have one value per joint) |
| `max_effort` | double | `0.0` | N m clamp for `interface: effort`; `0` = none |
| `max_velocity` | double | `0.0` | rad/s clamp for `interface: velocity`; `0` = none |
| `command_timeout` | double | `0.5` | s without a command, while commands were flowing, before it stops (direct wiring) |
| `estop_topic` | string | `/horus/supervisor/estop` | emergency stop topic, read directly |
| `supervisor_state_topic` | string | `/horus/supervisor/state` | supervisor state |
