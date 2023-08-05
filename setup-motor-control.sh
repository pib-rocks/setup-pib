#! /bin/sh
#
# FROM: https://github.com/mazeninvent/pib-motor_control
#
# CAUTION: this script expects that setup-pib.sh has already succeeded.
#

source_cmd=/home/pib/motor_control_ws/install/setup.bash
run_cmd="ros2 run cerebra motor_control"
if grep -q "^source $source_cmd" ~/.bashrc; then
        echo "$0: This script was already run. If you really need to re-run this script, remove the line '$source_cmd' from your ~/.bashrc"
        echo "To start the motor-control, try: $run_cmd"
	exit 1
fi

mkdir -p ~/motor_control_ws
cd ~/motor_control_ws
git clone https://github.com/mazeninvent/pib-motor_control.git
colcon build --packages-select cerebra
cd ..
echo source $source_cmd >> ~/.bashrc
source $source_cmd

# ros2 run cerebra motor_control

cat <<EOF
Before using this service, edit 
	~/motor_control_ws/src/cerebra/cerebra/motor_control.py
Change UID, UID1, UID2 and UID3 of hat brick and bricklets retrieved from brickviewer (lines 3,4,5,6 in code)
Then recompile with:		
	( cd ~/motor_control_ws; colcon build --packages-select cerebra )

To start this service, open a fresh shell, and do

	$run_cmd

Motor_control via cereba setup can be reached at http://localhost/head"
EOF


