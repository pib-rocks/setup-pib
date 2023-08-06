# Software setup

### CAUTION: Keep in sync with https://pib.rocks/build/how-to-install-a-digital-twin-of-pib/

One click install: 

	wget http://bit.ly/pibSetup | bash

The setup-pib.sh script assumes (e.g. as a VM in virtualbox): 
- That Ubuntu Desktop 22.04.2 LTS is installed
  E.g. from https://www.releases.ubuntu.com/22.04/ubuntu-22.04.2-desktop-amd64.iso	(4.6 GB)
  A "Minimal installation" is suficient (web browser and basic utilities)
- 30GB free disk space
- 6 GB RAM  (gazebo needs memory)
- Username is **pib** (see below)

If you have not set up the user **pib** at installation, you can do so via the settings-dialog of Ubuntu and then log in as **pib**.

## Running the script


Fixme: 
- Simplify the start of this README. Move user details into setup-pib.sh
- define the three user scenarios that this script must pass:
  1) Virtualbox with (*) skip automated install (user pib has no implicit sudo power)
  2) Virtualbox without ( ) skip automated install (user is pib already has implicit sudo power)
  3) Docker (user is root, pib must be created)

To run the script do the next steps:

1. Open a terminal as root user (from a normal user account, become root e.g. via `sudo bash`)
```
`adduser pib`
  -> e.g. password pib, everything else nothing
`su - pib`
`mkdir github; cd github`
`git clone https://github.com/pib-rocks/setup-pib`


`echo 'pib ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/pib"`

`cd setup-pib`
`bash setup-pib.sh`
 -> Password: (will ask once, so that it can sudo )

```

The setup then adds Cerebra and it's dependencies, including ROS2, Tinkerforge,...
Once the installation is complete, please restart the system to apply all the changes.

## Checking if the software started successfully

To check if ROS2, nginx and the camera node have successfully started:

	`sudo bash ./pib_up_services.sh`
	
	The camera service okay expected to fail, when no camera is connected.

With the following command, you can check the running ros2 nodes:

        `ros2 node list`

	The output is expected to include

	/rosapi
	/rosapi_params
	/rosbridge_websocket

## setup gazebo and motor-control

`bash setup-digital-twin.sh`
`bash setup-motor-control.sh`

Each of these script print instructions how to run them.

## Run gazebo and/or motor-control

* gazebo
  Open a new terminal window and run this command: `ros2 launch pib_sim pib.launch.py`
  Gazebo will open it's GUI.

* motor-control
  Open a new terminal window and run this command: `ros2 run cerebra motor_control`
  Cerebra will be available at http://localhost/head
  (To configure motor wiring, see https://github.com/mazeninvent/pib-motor_control/tree/main#readme )

# Build and publish a docker image

`docker build . --tag=pibrocks/setup-pib:latest`
`docker login -u pibrocks`
 Password: ******
`docker push pibrocks/setup-pib:latest`

# Run the docker image (with full hardware access on your raspi)

`docker run --rm -ti --privileged pibrocks/setup-pib bash`

And follow the instructions...

