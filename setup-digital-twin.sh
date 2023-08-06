# CAUTION: keep in sync with https://pib.rocks/build/how-to-install-a-digital-twin-of-pib/
# CAUTION: This script must only be run after setup-pib.sh succeeded.

source_cmd=/home/pib/ros2_ws/install/setup.bash
run_cmd="ros2 launch pib_sim pib.launch.py"
if [ ! -f ~/env ]; then echo "Please run first: bash ./setup-pib.sh"; exit 0; fi
if grep -q "^source $source_cmd" ~/env; then
        echo "$0: This script was already run. If you really need to re-run this script, remove the line '$source_cmd' from your ~/env"
        echo "To start the digital-twin, try: $run_cmd"
	exit 1
fi

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
echo "source $source_cmd >> ~/.bashrc
source $source_cmd

cat <<EOF
To start this service, open a fresh shell, and do

	$run_cmd

EOF
