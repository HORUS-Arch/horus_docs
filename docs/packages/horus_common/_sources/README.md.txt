# horus_common

Shared **build configuration** for the HORUS packages, plus a few small cross-package helpers. It exports one CMake macro so every core package configures the build identically in one line.

## `horus_package()`

Exported via `CONFIG_EXTRAS` (`cmake/horus_package.cmake`). Call it right after `project()`:

```cmake
find_package(horus_common REQUIRED)
horus_package()
```
