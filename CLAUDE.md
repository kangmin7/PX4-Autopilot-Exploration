# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build System

PX4 uses CMake via a top-level `Makefile` wrapper. Build targets follow the pattern `<vendor>_<board>_<config>`.

```bash
# Default SITL build (Gazebo with x500 quadrotor)
make px4_sitl_default

# Build for a specific hardware target
make px4_fmu-v5_default

# Build and run SITL with Gazebo (ROS2 / gz-sim / Gazebo Harmonic)
make px4_sitl gz_x500

# Build and run SITL with Gazebo Classic (ROS1)
make px4_sitl gazebo-classic

# Clean build artifacts
make clean
make distclean   # also removes cmake cache

# Format check / fix (uses astyle)
make check_format
make format
```

Build output goes to `build/<target>/`. Ninja is used automatically if available.

## Running Tests

```bash
# Run all unit/integration tests (builds px4_sitl_test target)
make tests

# Quick CI check: single SITL build + tests + format
make quick_check
```

Individual gtests are compiled into `build/px4_sitl_test/` and can be run directly:
```bash
./build/px4_sitl_test/unit_test_runner --gtest_filter=<TestName>
```

## SITL Simulation Workflow

### ROS2 + Gazebo (gz-sim / Harmonic)
```bash
# Terminal 1: Start MicroXRCE-DDS Agent (bridges PX4 uXRCE topics to ROS2)
MicroXRCEAgent udp4 -p 8888

# Terminal 2: Launch PX4 SITL with Gazebo
make px4_sitl gz_x500

# Optional: set home position before launch
export PX4_HOME_LAT=47.397742
export PX4_HOME_LON=8.545593
export PX4_HOME_ALT=488.0
```

**Custom world:** The world `.sdf` must contain `<world name='<world_name>'>` matching the argument. Example:
```bash
make px4_sitl gz_x500 PX4_GZ_WORLD=husarion_office_empty
```

### ROS1 + Gazebo Classic
```bash
# Build only (no launch)
DONT_RUN=1 make px4_sitl_default gazebo-classic

# Set up environment, then launch via ROS
source ~/catkin_ws/devel/setup.bash
source Tools/simulation/gazebo-classic/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd):$(pwd)/Tools/simulation/gazebo-classic/sitl_gazebo-classic
roslaunch px4 posix_sitl.launch

# MAVROS connection
roslaunch mavros px4.launch fcu_url:="udp://:14540@127.0.0.1:14557"
```

### PX4 Commander quick-commands (in PX4 shell)
```
commander takeoff
commander mode offboard
commander land
commander set_ekf_origin 47.397742 8.545593 488.0
```

## Architecture Overview

### uORB Pub/Sub Middleware
uORB is the inter-process/inter-thread message bus. Message definitions live in `msg/*.msg`. Generated C++ headers are created at build time under `build/<target>/uORB/topics/`.

- **Subscribe:** `uORB::Subscription<topic_s> _sub{ORB_ID(topic)};`
- **Publish:** `uORB::Publication<topic_s> _pub{ORB_ID(topic)};`
- **SubscriptionCallbackWorkItem:** triggers `Run()` when new data arrives (used in most control modules)

### Module Pattern
Every flight stack module inherits from `ModuleBase<T>` (defined in `platforms/common/include/px4_platform_common/module.h`) and typically also from `ModuleParams` and one of:
- `px4::ScheduledWorkItem` — for periodic execution (attitude/position controllers)
- `px4::WorkItem` — for callback-driven execution

The module entry point is its `task_spawn` / `custom_command` / `print_usage` static methods, enabling `<module_name> start/stop/status` from the PX4 shell.

New modules should follow `src/templates/template_module/` as a starting point.

### Key Source Directories
| Path | Contents |
|------|----------|
| `src/modules/` | Flight stack applications (commander, ekf2, navigator, mc_pos_control, etc.) |
| `src/drivers/` | Hardware drivers (IMU, GPS, actuators, etc.) |
| `src/lib/` | Shared libraries (matrix math, geo, controllib, collision prevention, etc.) |
| `src/systemcmds/` | Shell utilities (param, mixer, dmesg, etc.) |
| `msg/` | uORB message definitions |
| `boards/` | Per-board Kconfig and cmake overrides |
| `platforms/` | OS/platform abstraction (nuttx, posix, ros2) |
| `ROMFS/` | Init scripts and airframe configs loaded at boot |
| `Tools/` | Scripts for simulation, code style, metadata generation |

### Board Configuration
Board configs are `.px4board` Kconfig files in `boards/<vendor>/<board>/`. The SITL config is `boards/px4/sitl/default.px4board`. Modules are enabled/disabled with `CONFIG_MODULES_<NAME>=y`.

### ROS2 Integration
PX4 connects to ROS2 via the `uxrce_dds_client` module (uXRCE-DDS) — no MAVROS needed. Topics appear under `/fmu/in/` (ROS2→PX4) and `/fmu/out/` (PX4→ROS2). Use `px4_msgs` package for message types.

**QoS for PX4 topics:**
```python
from rclpy.qos import QoSProfile, HistoryPolicy, ReliabilityPolicy, DurabilityPolicy
px4_qos = QoSProfile(
    history=HistoryPolicy.KEEP_LAST, depth=1,
    reliability=ReliabilityPolicy.BEST_EFFORT,
    durability=DurabilityPolicy.VOLATILE
)
```

### Parameters
Parameters are declared with `DEFINE_PARAMETERS` macro in module headers and accessed via `_param_name.get()`. They are stored in the `dataman` module and configurable from QGroundControl or the PX4 shell (`param set <NAME> <VALUE>`).

## Development Setup

If encountering build errors after a fresh clone:
```bash
bash ./Tools/setup/ubuntu.sh
```

To update submodules:
```bash
make submodulesupdate
```
