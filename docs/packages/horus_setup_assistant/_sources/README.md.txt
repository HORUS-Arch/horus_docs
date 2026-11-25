# horus_setup_assistant

Scaffolds a **new device repo** (`<device>_ros2`) from a template, the MoveIt-Setup-Assistant analog. It
generates the thin, HORUS-ready skeleton (description xacro from the actuator_core macros, config-driven
controller YAML, ros2_control interface config, `package.xml` with core deps, README) so making an device
"HORUS-ready" is a generate step, not hand-copying.

## Dependencies

`rclpy` (CLI only).

## CLI

- `generate`, emit an `<device>_ros2` skeleton.

## Usage

```bash
ros2 run horus_setup_assistant generate --name mydevice --joints hipR,kneeR,ankleR --out ~/dev
```

## Notes

CLI/template first; a GUI panel in the UI repo is a later add. The generated device repo depends on
`horus` core and lives outside it (the split model), and is brought up by its own launch
(launch-per-config, no runtime catalog).
