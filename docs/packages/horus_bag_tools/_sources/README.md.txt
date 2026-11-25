# horus_bag_tools

Offline analysis helpers for recorded trials. Turns a rosbag2 recording (from `horus_session`'s
recorder) into analysis-friendly CSVs.

## Dependencies

`rosbag2_py`, `rclpy`.

## Nodes / CLI

- `decode`, read a bag directory and write **one CSV per topic** (each message flattened to dotted
  keys + `stamp_ns`; reads mcap or sqlite).

## Usage

```bash
ros2 run horus_bag_tools decode <bag_dir> --out <csv_dir>
```

## Notes

The sqlite bag is already a database but stores serialized blobs, so decode-to-CSV is the analysis
path. A columnar/DB export (parquet, pandas) is a future add if analysis needs it.
