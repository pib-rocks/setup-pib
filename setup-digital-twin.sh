# CAUTION: keep in sync with https://pib.rocks/build/how-to-install-a-digital-twin-of-pib/
# CAUTION: This script must only be run after setup-pib.sh succeeded.

sudo apt install ros-humble-ros-ign
sudo apt install ros-humble-ros2-control 
sudo apt install ros-humble-ros2-controllers
sudo apt install ros-humble-ign-ros2-control


Einrichten ROS Workspace
mkdir -p ros2_ws/src

cd ~/ros2_ws/src
# TODO: move this to github (Yannick?)
# we need to release multiple zip files in future:
#  - pib_sim_stable2023.zip pib_sim_stable2024.zip ...
#  - pib_sim_dev20230805.zip ...
####
sudo wget https://pib.rocks/wp-content/uploads/pib_data/pib_sim.zip
unzip pib_sim.zip && rm pib_sim.zip
cd ..
colcon build --symlink-install
echo source /opt/ros/humble/setup.bash >> ~/.bashrc
echo source ~/ros2_ws/install/setup.bash >> ~/.bashrc
	
	
	ros2 launch pib_sim pib.launch.py 
