# PX4-Autopilot for m-explore-ros2

Custom [PX4-Autopilot](https://github.com/PX4/PX4-Autopilot) for integration with [m-explore-ros2](https://github.com/robo-friends/m-explore-ros2), targeting ROS 2 Humble

---

## Changes

### `Husarion Office Worlds`

[Husarion office world](https://github.com/husarion/husarion_gz_worlds) added to PX4 Gazebo worlds.

---

## Running in simulation (PX4 + Gazebo)

```bash
cd ~/PX4-Autopilot
make px4_sitl gz_x500_lidar_2d PX4_GZ_WORLD=husarion_office_empty
```
