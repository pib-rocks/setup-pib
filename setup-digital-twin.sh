# CAUTION: keep in sync with https://pib.rocks/build/how-to-install-a-digital-twin-of-pib/
# CAUTION: This script must only be run after setup-pib.sh succeeded.

sudo apt install -y ros-humble-ros-ign			# 300 MB for gazebo
sudo apt install -y ros-humble-ros2-control 		# 16 MB
sudo apt install -y ros-humble-ros2-controllers		# 37 MB
sudo apt install -y ros-humble-ign-ros2-control		# 200 kB


Einrichten ROS Workspace
mkdir -p ~/ros2_ws/src

cd ~/ros2_ws/src
# TODO: move this to github (Yannick?)
# we need to release multiple zip files in future:
#  - pib_sim_stable2023.zip pib_sim_stable2024.zip ...
#  - pib_sim_dev20230805.zip ...
####
sudo wget https://pib.rocks/wp-content/uploads/pib_data/pib_sim.zip
unzip pib_sim.zip && rm -f pib_sim.zip
cd ..
colcon build --symlink-install
echo source /opt/ros/humble/setup.bash >> ~/.bashrc
echo source ~/ros2_ws/install/setup.bash >> ~/.bashrc
source /opt/ros/humble/setup.bash
source ~/ros2_ws/install/setup.bash

cat <<EOF
To start this service, open a fresh shell, and do

	ros2 launch pib_sim pib.launch.py 

EOF
