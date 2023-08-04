# Software setup

This script assumes (e.g. as a VM in virtualbox): 
- that Ubuntu Desktop 22.04.2 LTS is installed
- more than 20GB free disk space
- at least 12 GB RAM  (gazebo needs memory)
- the user running it is **pib**

If you have not set up the user **pib** at installation, you can do so via the settings-dialog of Ubuntu and then log in as **pib**.

## Running the script

To run the script do the next steps:

1. Open a terminal as root user, from a normal user account, become root e.g. via `sudo bash`
```
adduser pib
  -> e.g. password pib, everything else nothing
su - pib
mkdir github; cd github
git clone https://github.com/pib-rocks/setup-pib


echo 'pib ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/pib"

cd setup-pib
bash setup-pib.sh
 -> Password: (will ask once, so that it can sudo )

```

The setup then adds Cerebra and it's dependencies, including ROS2, Tinkerforge,...
Once the installation is complete, please restart the system to apply all the changes.

## Checking if the software started successfully

To check if ROS2 successfully started:

        systemctl status ros_cerebra_boot.service

To check if Cerebra successfully started:

        sudo systemctl status nginx

To check if the camera node successfully started:

        systemctl status ros_camera_boot.service

With the following command, you can check the running ros2 nodes:

        ros2 node list

