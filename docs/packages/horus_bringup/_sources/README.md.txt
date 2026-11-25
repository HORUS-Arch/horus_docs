# horus_bringup

Composition + launch files that wire the core packages together on the mock device, the
"launch-per-config" entry point (no runtime catalog; a launch *is* the config).

## Dependencies

The mock stack (`horus_mock_device`, an external repo, see `horus.repos`) + the core nodes it launches (`horus_supervisor`,
which runs the trees with the `horus_bt` leaves, `horus_session`, `horus_generator_server`,
`horus_lifecycle_manager`, `horus_health_monitor`) + `rclcpp_components`, stock controllers.

## Launch files

| Launch | Brings up |
|---|---|
| **`rig.launch.py rig:=<rig.yaml>`** | **a whole rig from one file**: robot launch + generators, sensors (`/sensors/<name>`), HORUS human nodes (`/human/<name>`), supervisor (modes + trees), session (subjects + trials), lifecycle manager, health, UI |
| `ui.launch.py` | the UI side with stock tools: `rosbridge_websocket` (:9090, allow-listed to the HORUS namespaces) + Python's web server (:8080) for `web_root` (default: the minimal page in `web/`) |
| `managed.launch.py` | mock device + the session node + health monitor, record trials without the supervisor |
| `trial.launch.py` | mock device + `generator_server` (home, walk, manual) + the supervisor, START a protocol tree end to end |
| `horus_system.launch.py` | the C++ system nodes with nav2-style **`use_composition`** selection (separate processes, or all collapsed into one `component_container_isolated`) |

### Rigs, config, trees

- `rigs/mock/rig.yaml`, a runnable rig on the mock exo (no sensors), with UI.
- `rigs/example/rig.yaml`, a template of a real rig (robot, sensors, human nodes, UI).
- `web/index.html`, the minimal operator page (roslib): mode + EMERGENCY STOP, subject, devices (connect, calibrate), protocol Start / Stop / Manual / Reset, speed, notes, joint sliders in MANUAL, joints.

- `config/mock_generators.yaml`, behaviors home, walk (finite) and manual (sliders) feeding the mock's position controller.
- `behavior_trees/trial_mock.xml`, the mock protocols (Trial, RecordOnly, NotedTrial, Manual, Recovery, Stop, Fails).

## Usage

```bash
ros2 launch horus_bringup rig.launch.py rig:=$(ros2 pkg prefix horus_bringup)/share/horus_bringup/rigs/mock/rig.yaml
# then open http://<this-pc>:8080 (needs: sudo apt install ros-jazzy-rosbridge-suite)

ros2 launch horus_bringup trial.launch.py
ros2 service call /supervisor/command horus_msgs/srv/SupervisorCommand "{command: 0, tree: Trial}"   # START

ros2 launch horus_bringup horus_system.launch.py use_composition:=true             # one container
```

## Tests

`test/test_trial.launch.py` (launch_testing): brings up `trial.launch.py`, STARTs the mock `Trial`
and expects the supervisor back in STANDBY with the tree completed. Run with
`colcon test --packages-select horus_bringup`.

## Notes

The RT `ros2_control_node` always stays its own isolated process (never composed). A real device replaces
the mock stack via its own `<device>_ros2` launch; the orchestration here is device-agnostic.
