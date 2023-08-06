#!/bin/bash
sudo service nginx restart
source /opt/ros/humble/setup.bash
ros2 run cerebra motor_control

