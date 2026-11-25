# horus_human

HORUS's **stage-1 human processing**: one node per signal type. Each one takes raw sensor data from
`/sensors/...`, applies its calibration, and publishes corrected data in body terms under
`/human/<instance>/...`. Stage-2 estimators (kinematics, gait) will consume these outputs later.

Every node is a `horus_human_core::ChannelNode`:
- it is configured entirely from YAML;
- its calibration algorithm is a plugin;
- it can run as any number of instances (two IMU systems = two instances, each with its own name,
  topics and calibration files).

## Dependencies

`horus_human_core`, `human_msgs`, `sensor_msgs`, `tf2`, `rclcpp_components`.

## Nodes

| Node | Channels | Input | Outputs (`~/` = `/human/<instance>/`) |
|---|---|---|---|
| `horus_imu` | human_msgs segment names (`right_upper_leg`, `pelvis`, ...) | `sensor_msgs/Imu` | `~/<segment>/imu` (segment frame), `~/segments` (`SegmentState`) |
| `horus_insole` | `right`, `left` | `human_msgs/Insole` | `~/<side>/insole`, `~/insoles` (`Insoles`) |
| `horus_emg` | muscle names (`rectus_femoris_r`, ...) | `human_msgs/Emg` | `~/<muscle>/emg` (envelope, normalised), `~/emgs` (`Emgs`) |

Each node is both a component (`horus_human::ImuNode`, `InsoleNode`, `EmgNode`) and an executable,
so the stage-1 and stage-2 nodes of a rig can share one process.

## Calibration plugins

| Plugin | For | Procedure |
|---|---|---|
| `horus_human/ImuStaticPose` | `horus_imu` | the subject holds the reference pose; computes sensor-to-segment rotation and gyro bias; rejects the window if gyro RMS > `max_motion` |
| `horus_human/InsoleZeroOffset` | `horus_insole` | foot unloaded; stores per-cell pressure and force offsets; rejects if force > `max_force` |
| `horus_human/EmgMvc` | `horus_emg` | maximum voluntary contraction; stores the envelope peak and normalises by it |

To add your own, derive from `horus_human::ImuCalibration` (or `InsoleCalibration` /
`EmgCalibration`), export it with pluginlib for `horus_human`, and set `calibration.plugin`.

## Node-specific parameters

| Node | Name | Default | Description |
|---|---|---|---|
| `horus_imu` | `segments_rate` | `100.0` | Hz, aggregate `~/segments` |
| `horus_imu` | `world_frame` | `world` | frame of `~/segments` |
| `horus_insole` | `insoles_rate` | `100.0` | Hz, aggregate `~/insoles` |
| `horus_emg` | `dc_time_constant` | `1.0` | s, DC removal |
| `horus_emg` | `envelope_window` | `0.1` | s, moving-RMS envelope |
| `horus_emg` | `emgs_rate` | `50.0` | Hz, aggregate `~/emgs` |

The common parameters, the Calibrate action and the save/load services are in the
`horus_human_core` README.

## Usage

```bash
ros2 run horus_human horus_imu --ros-args -r __ns:=/human -r __node:=imus_a \
  --params-file $(ros2 pkg prefix horus_human)/share/horus_human/config/imu.example.yaml
ros2 lifecycle set /human/imus_a configure && ros2 lifecycle set /human/imus_a activate
ros2 action send_goal /human/imus_a/calibrate horus_msgs/action/Calibrate "{unit: '', duration: 3.0}"
ros2 service call /human/imus_a/save_calibration horus_msgs/srv/SaveCalibration "{subject_id: s01}"
```

Example configs: `config/imu.example.yaml`, `insole.example.yaml`, `emg.example.yaml`.

## Tests

`test/test_default_calibrations.cpp` (gtest):
- IMU alignment and bias removal (through a YAML round trip), and motion rejection;
- insole offsets with clamping, and loaded-foot rejection;
- EMG MVC normalisation, and flat-signal rejection.
