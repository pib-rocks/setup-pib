#! /bin/sh
#
# FROM: https://github.com/mazeninvent/pib-motor_control
#
# CAUTION: this script expects that setup-pib.sh has already succeeded.
#
mkdir ~/motor_control_ws
cd motor_control_ws
git clone https://github.com/mazeninvent/pib-motor_control.git
colcon build --packages-select cerebra
cd ..
echo source ~/motor_control_ws/install/setup.bash >> ~/.bashrc
source ~/motor_control_ws/install/setup.bash

# ros2 run cerebra motor_control

cat <<EOF
To start this service, open a fresh shell, and do

	ros2 run cerebra motor_control

Motor_control via cereba setup can be reached via http://localhost/head"
Before using this service, edit 
	~/motor_control_ws/src/cerebra/cerebra/motor_control.py
Change UID, UID1, UID2 and UID3 of hat brick and bricklets retrieved from brickviewer (lines 3,4,5,6 in code)

(Restart of the service may be needed after editing. See $0 )
EOF


