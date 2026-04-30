#!/usr/bin/env python3
"""
Forwards SLAM Toolbox pose (map->base_link TF) to MAVROS vision_pose plugin.
MAVROS handles ENU->NED conversion internally before sending to PX4.

Publish to: /mavros/vision_pose/pose  (geometry_msgs/PoseStamped, ENU frame)
PX4 receives: VISION_POSITION_ESTIMATE MAVLink message
"""

import rclpy
from rclpy.node import Node
from geometry_msgs.msg import PoseStamped
import tf2_ros


class SlamToMavros(Node):
    def __init__(self):
        super().__init__('slam_to_mavros')

        self._pub = self.create_publisher(
            PoseStamped, '/mavros/vision_pose/pose', 10)

        self._tf_buffer = tf2_ros.Buffer()
        self._tf_listener = tf2_ros.TransformListener(self._tf_buffer, self)

        self.create_timer(0.02, self._publish)  # 50 Hz

    def _publish(self):
        try:
            tf = self._tf_buffer.lookup_transform(
                'map', 'base_link', rclpy.time.Time())
        except Exception:
            return

        x = tf.transform.translation.x
        y = tf.transform.translation.y
        z = tf.transform.translation.z

        # Reject ECEF-scale garbage (SLAM not yet initialized with a local map)
        if (x * x + y * y) > 1e6:
            self.get_logger().warn(
                f'TF position ({x:.1f}, {y:.1f}) looks like ECEF — SLAM not ready, skipping',
                throttle_duration_sec=5.0)
            return

        msg = PoseStamped()
        msg.header.stamp = tf.header.stamp  # sim time from SLAM, not wall clock
        msg.header.frame_id = 'map'
        msg.pose.position.x = x
        msg.pose.position.y = y
        msg.pose.position.z = z
        msg.pose.orientation = tf.transform.rotation

        self._pub.publish(msg)


def main():
    rclpy.init()
    rclpy.spin(SlamToMavros())
    rclpy.shutdown()


if __name__ == '__main__':
    main()
