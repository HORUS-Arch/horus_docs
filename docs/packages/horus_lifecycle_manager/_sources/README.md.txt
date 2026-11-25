# horus_lifecycle_manager

Brings a set of managed (lifecycle) nodes up and down in order and watches them, nav2's
`lifecycle_manager`, minus the bond. **The `node_names` list order IS the dependency order**: the
manager configures + activates down the list on startup and reverses it on shutdown. Liveliness is
tracked without any obligation on the managed nodes (external sensors can't bond): it polls
`~/get_state` and subscribes each node's `~/transition_event`, and publishes a standard
`diagnostic_msgs` status. Composable component.

## Dependencies

`rclcpp`, `rclcpp_components`, `lifecycle_msgs`, `diagnostic_msgs`, `std_msgs`, `horus_msgs`.

## Nodes

- `horus_lifecycle_manager`, the coordinator. Composable (`horus_lifecycle_manager::LifecycleManager`)
  or standalone. Run one instance per subsystem if you like.

## ROS2 API

### Published topics

| Topic | Type | Description |
|---|---|---|
| `~/status` | `diagnostic_msgs/DiagnosticArray` | per-node lifecycle state (OK=active) |
| `~/is_active` | `std_msgs/Bool` (latched) | whether the managed set is up |

### Services

| Name | Type | Description |
|---|---|---|
| `~/manage_nodes` | `horus_msgs/ManageLifecycleNodes` | STARTUP / SHUTDOWN / PAUSE / RESUME / RESET; set `node_name` to act on a single node |

### Parameters

| Name | Type | Default | Description |
|---|---|---|---|
| `node_names` | string[] | `[]` | managed nodes, **in bringup order** |
| `autostart` | bool | `true` | STARTUP the set shortly after launch |

## Usage

```bash
ros2 run horus_lifecycle_manager lifecycle_manager --ros-args \
  -p autostart:=true -p node_names:="[generator_server]"
```

Or via a params file, see `config/lifecycle_manager.yaml`.

## Notes

- The blocking `change_state` calls run on a dedicated callback-group executor, so bringup works even
  under a single-threaded (composed) executor.
- The controller_manager is **not** managed here: its controllers are started by the robot's own
  launch and run for the whole session (no tree switches controllers).
- The supervisor and the session node are not lifecycle nodes and are not in `node_names`; `rig.launch.py`
  lists sensors, then `/human` nodes, then the generator server.
