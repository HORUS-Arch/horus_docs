# horus_estimator_core

The interface of HORUS **stage-2 state estimation**: the `Estimator` plugin base
(`include/horus_estimator_core/estimator.hpp`).

## Where it sits

The `estimation/` domain is **sensing and state estimation**:

- **Sensing** turns raw driver data into clean, calibrated, body-referenced data: sensor drivers in
  their own repositories publish standard messages on `/sensors/<name>`; the stage-1 nodes of
  `horus_human` (`horus_imu`, `horus_insole`, `horus_emg`) condition and calibrate them onto
  `/human/<name>`. Calibration is HORUS's (see `horus_human_core`).
- **State estimation** fuses those streams into the state the brain and the generators use:
  - *human state*: joint kinematics, gait events and phases;
  - *robot state*: joint positions and efforts (stock ros2_control broadcasters), the interaction
    wrench, the base (pelvis) orientation that gravity compensation needs;
  - *interaction*: estimates that need both, such as human joint torque from the interaction force.

"Perception" is kept for the **environment** (terrain, stairs, obstacles), as in Autoware and MoveIt.

## The Estimator interface

Lifecycle-shaped like `Generator`: `configure(node, name)`, `activate()`, `deactivate()`, `reset()`,
`update(time, period)`. There is no fixed input structure: an estimator subscribes to what it needs and
publishes standard or `human_msgs` outputs. **Interface only**: concrete estimators and their host are
planned.

## Dependencies

`rclcpp`, `rclcpp_lifecycle`.
