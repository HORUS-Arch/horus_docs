# horus_human_core

The framework behind HORUS's human-processing nodes. It holds everything a stage-1 (conditioning)
node shares, so a concrete node only declares its outputs:

- **`CalibrationPlugin<MsgT>`**: the pluginlib base every calibration algorithm implements
  (`begin` / `add` / `finish` / `load` / `apply`). The algorithm is chosen in YAML
  (`calibration.plugin`), so swapping it never touches node code.
- **`CalibrationStore`**: the on-disk calibration files,
  `<data_root>/subjects/<subject>/calibration/<node>/<unit>_<YYYYmmdd_HHMMSS_mmm>.yaml`. Every save
  is a new file; the newest file of a unit is its latest.
- **`ChannelNode<MsgT>`**: a lifecycle node with N named channels of one message type. It owns the
  subscriptions, the Calibrate action, save/load, auto-loading the subject's latest files on
  configure, and diagnostics.

## Dependencies

`rclcpp`, `rclcpp_lifecycle`, `rclcpp_action`, `pluginlib`, `diagnostic_updater`, `horus_msgs`, `yaml-cpp`.

## ROS2 API (every ChannelNode)

### Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `channels` | string[] | — | unit names (segments, sides, muscles); required |
| `<channel>.topic` | string | — | input topic of the channel; required |
| `calibration.plugin` | string | `""` | calibration plugin class; `""` = none |
| `calibration.*` | — | — | the plugin's own parameters |
| `subject_id` | string | `""` | set before configure and the subject's latest files load automatically |
| `data_root` | string | `~/horus_data` | root of the data folder |
| `mode` | string | `calibrated` | output mode, settable at runtime: `calibrated` (conditioning + calibration), `conditioned` (conditioning only), `bypass` (raw input republished untouched); calibration windows always collect conditioned data |

### Action servers

| Name | Type | Description |
|---|---|---|
| `~/calibrate` | `horus_msgs/action/Calibrate` | collect `duration` s for one unit or all; only while active; result stays pending until saved, and is already applied |

### Services

| Name | Type | Description |
|---|---|---|
| `~/save_calibration` | `horus_msgs/srv/SaveCalibration` | write the pending result(s) for a subject |
| `~/load_calibration` | `horus_msgs/srv/LoadCalibration` | apply one file, or (empty path) the subject's latest of every unit |

### Published topics

| Topic | Type | Description |
|---|---|---|
| `/diagnostics` | `diagnostic_msgs/DiagnosticArray` | per channel: calibrated, and from which file |

## Writing a new node

Derive from `ChannelNode<MsgT>`. Implement `configureOutputs`, `activateOutputs`, `cleanupOutputs`
and `publish`, and optionally `validateChannel` and `condition` (filtering applied before
calibration). See `horus_human` for three examples.

## Tests

`test/test_calibration_store.cpp` (gtest): layout and content, latest-of-exact-unit, foreign-file rejection.
