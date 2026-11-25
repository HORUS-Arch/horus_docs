# horus_health_monitor

System health rollup, **config only, no custom code**. It runs the stock
`diagnostic_aggregator` over everything nodes already publish on `/diagnostics` and produces a grouped
health tree on `/diagnostics_agg` that the UI reads. Lifecycle state is separate and complementary;
this is the "is everything OK" layer.

## Dependencies

`diagnostic_aggregator`.

## Contents

- `config/analyzers.yaml`, analyzer groups (Devices / Controllers / Sensors) mapping `/diagnostics`
  entries into the tree.
- `launch/health_monitor.launch.py`, the aggregator node with that config.

## ROS2 API

| Topic | Type | Description |
|---|---|---|
| `/diagnostics` (in) | `diagnostic_msgs/DiagnosticArray` | what every node publishes |
| `/diagnostics_agg` (out) | `diagnostic_msgs/DiagnosticArray` | the grouped health tree |

## Usage

```bash
ros2 launch horus_health_monitor health_monitor.launch.py
```

(Included by `horus_bringup/managed.launch.py`.)
