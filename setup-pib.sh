#!/bin/bash
#
# This script installs all necessary software and sets required configurations for running pib
#
# It assumes:
#   - that Ubuntu Desktop 22.04 is installed
#   - the default-user "pib" is executing it
#

# Exported variables for all subshells: Codes for "echo -e" output text formatting
export RED_TEXT_COLOR="\e[31m"
export YELLOW_TEXT_COLOR="\e[33m"
export GREEN_TEXT_COLOR="\e[32m"
export CYAN_TEXT_COLOR="\e[36m"
export RESET_TEXT_COLOR="\e[0m"
export NEW_LINE="\n"

# Exported variables for all subshells: Exit codes for error detection
export INPUT_OUTPUT_ERROR_STATUS=5
export FAILED_SUBSCRIPT_STATUS=254
export FAILED_CHECK_STATUS=255

# Exported variables for all subshells: Boolean constants for checks
export TRUE="true"
export FALSE="false"

# Default ubuntu paths
export DEFAULT_USER="pib"
export USER_HOME="/home/$DEFAULT_USER"
export ROS_WORKING_DIR="$USER_HOME/ros_working_dir"
mkdir "$ROS_WORKING_DIR"

# We want the user pib to setup things without password (sudo without password)
# Yes, we are aware of the security-issues..
echo "Hello pib! We start the setup by allowing you permanently to run commands with admin-privileges."
if [[ "$(id)" == *"(sudo)"* ]]; then
	echo "For this change please enter your password..."
	sudo bash -c "echo '$DEFAULT_USER ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/$DEFAULT_USER"
else
	echo "For this change please enter the root-password. It is most likely just your normal one..."
	su root bash -c "usermod -aG sudo $DEFAULT_USER ; echo '$DEFAULT_USER ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/$DEFAULT_USER"
fi

# Redirect console output to a log file
LOG_FILE="$USER_HOME/setup-pib.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# Variables for user input options and arguments
export is_dev_mode="$FALSE"
export user_default_branch=""
export user_feature_branch=""

# Variables for github branch checking:
# Github repo origin URLs
readonly SETUP_PIB_ORIGIN="https://github.com/pib-rocks/setup-pib.git"
readonly PIB_API_ORIGIN="https://github.com/pib-rocks/pib-api.git"
readonly ROS_PACKAGES_ORIGIN="https://github.com/pib-rocks/ros-packages.git"
readonly DATATYPES_ORIGIN="https://github.com/pib-rocks/datatypes.git"
readonly MOTORS_ORIGIN="https://github.com/pib-rocks/motors.git"
readonly OAK_D_LITE_ORIGIN="https://github.com/pib-rocks/ros2_oak_d_lite.git"
readonly VOICE_ASSISTANT_ORIGIN="https://github.com/pib-rocks/voice-assistant.git"
readonly PROGRAMS_ORIGIN="https://github.com/pib-rocks/programs.git"

# The help function shows infos about the command-line parameter options, then exits the script
show_help() 
{
	echo -e "setup-pib.sh input help:"
	echo -e "This script has two execution modes (normal mode and development mode).""$NEW_LINE"
	echo -e "$YELLOW_TEXT_COLOR""To start the script in normal mode, don't add any arguments or options.""$RESET_TEXT_COLOR"
	echo -e "Example: ./setup-pib""$NEW_LINE"
	echo -e "$YELLOW_TEXT_COLOR""Starting the script in development mode:""$RESET_TEXT_COLOR"
	echo -e "- Default branch parameter -"
	echo -e "-d=YourBranchName or --defaultBranch=YourBranchName"
	echo -e "$CYAN_TEXT_COLOR""(This branch will be pulled if no feature branch was found or specified)""$RESET_TEXT_COLOR"
	echo -e "$NEW_LINE""- Feature branch parameter -"
	echo -e "-f=YourBranchName or --featureBranch=YourBranchName"
	echo -e "$CYAN_TEXT_COLOR""(If a branch with this name can be found in a repo, it will be pulled instead of the default branch)""$RESET_TEXT_COLOR"
	echo -e "$NEW_LINE""Dev-mode examples:"
	echo -e "    ./setup-pib -d=main -f=PR-368"
    echo -e "    ./setup-pib --defaultBranch=main --featureBranch=PR-368"
    exit "$INPUT_OUTPUT_ERROR_STATUS"
}

echo -e "$YELLOW_TEXT_COLOR""-- Checking possible user input options and arguments --""$RESET_TEXT_COLOR""$NEW_LINE"

# Iterate through all user input parameters
while [ $# -gt 0 ]; do
	case "$1" in
		# Assign default and feature branches for dev-mode
		-d=* | --defaultBranch=*)
			is_dev_mode="$TRUE"
			user_default_branch="${1#*=}"
			;;
    	-f=* | --featureBranch=*)
			is_dev_mode="$TRUE"
			user_feature_branch="${1#*=}"
			;;
		-h | --help)
			show_help
			;;
		*)
			echo -e "$RED_TEXT_COLOR""Invalid option inputs. Here is some info about the possible user inputs:""$RESET_TEXT_COLOR""$NEW_LINE"
			show_help
	esac
	shift
done

echo -e "$GREEN_TEXT_COLOR""-- User input option and argument syntax valid --""$RESET_TEXT_COLOR""$NEW_LINE"

# Refresh the linux packages list (sometimes necessary for packages that are required in the installion scripts)
sudo apt update

# These packages are installed seperately, since the installation scripts are dependent on them
sudo apt-get install -y git curl

# Installation folder will be created inside the temporary directory.
# The folder name is dependend on the corresponding branch, so it's defined after the branch check.
export installation_files_dir=""

# This variable is specifically for downloading the installation scripts from the setup repo
# These files are left out of the dynamic branch selection, since they are a prerequisite for the check itself
export SETUP_PIB_BRANCH="main"
if [ "$is_dev_mode" = "$TRUE" ]; then

	# Check if either the setup-pib branch for the feature or default branches exist
	if git ls-remote --exit-code --heads "$SETUP_PIB_ORIGIN" "$user_feature_branch" >/dev/null 2>&1; then
		SETUP_PIB_BRANCH="$user_feature_branch"
	elif git ls-remote --exit-code --heads "$SETUP_PIB_ORIGIN" "$user_default_branch" >/dev/null 2>&1; then
		SETUP_PIB_BRANCH="$user_default_branch"
	else
		echo -e "$RED_TEXT_COLOR""Neither $user_feature_branch nor $user_default_branch exists in the setup-pib repository.""$RESET_TEXT_COLOR""$NEW_LINE"
		show_help
	fi
fi

# Create temporary directory for installation files
export TEMPORARY_SETUP_DIR="$(mktemp --directory /var/tmp/pib-temp.XXX)"

# Get setup files needed for the pib software installation
readonly GET_SETUP_FILES_SCRIPT_NAME="get_setup_files.sh"
readonly GET_SETUP_FILES_SCRIPT="$TEMPORARY_SETUP_DIR""/$GET_SETUP_FILES_SCRIPT_NAME"
curl "https://raw.githubusercontent.com/pib-rocks/setup-pib/""$SETUP_PIB_BRANCH""/installation_scripts/""$GET_SETUP_FILES_SCRIPT_NAME" --location --output "$GET_SETUP_FILES_SCRIPT" 
chmod 755 "$GET_SETUP_FILES_SCRIPT"
source "$GET_SETUP_FILES_SCRIPT"

# Create an associative array (=map). This will be filled with repo-origin branch-name pairs in the check_github_branches.sh script
declare -A repo_map

# The following scripts are sourced into the same shell as this script,
# allowing them to acces all variables and context
# Check system variables
source "$installation_files_dir""/check_system_variables.sh"
# Check which github branches are available based on user input
source "$installation_files_dir""/check_github_branches.sh"
# Install system packages
source "$installation_files_dir""/install_system_packages.sh"
# Install python packages
source "$installation_files_dir""/install_python_packages.sh"
# Install tinkerforge
source "$installation_files_dir""/install_tinkerforge.sh"
# Install Cerebra
source "$installation_files_dir""/install_cerebra.sh"
# Install pib ros-packages
source "$installation_files_dir""/setup_packages.sh"
# Adjust system settings
source "$installation_files_dir""/set_system_settings.sh"

# Github direct download URLs, from the selected branch
readonly ROS_UPDATE_URL="https://raw.githubusercontent.com/pib-rocks/setup-pib/""${repo_map[$SETUP_PIB_ORIGIN]}""/update-pib.sh"
readonly ROS_CONFIG_URL="https://raw.githubusercontent.com/pib-rocks/setup-pib/""${repo_map[$SETUP_PIB_ORIGIN]}""/setup_files/ros_config.sh"
readonly ROS_CEREBRA_BOOT_URL="https://raw.githubusercontent.com/pib-rocks/setup-pib/""${repo_map[$SETUP_PIB_ORIGIN]}""/setup_files/ros_cerebra_boot.sh"
readonly ROS_CEREBRA_BOOT_SERVICE_URL="https://raw.githubusercontent.com/pib-rocks/setup-pib/""${repo_map[$SETUP_PIB_ORIGIN]}""/setup_files/ros_cerebra_boot.service"

# install update-pip
UPDATE_SCRIPT_PATH="$USER_HOME""/update-pib.sh"

if [ -f "$UPDATE_SCRIPT_PATH" ]; then
  sudo rm "$UPDATE_SCRIPT_PATH"
fi

curl "$ROS_UPDATE_URL" --location --output "$UPDATE_SCRIPT_PATH"
sudo chmod 777 "$UPDATE_SCRIPT_PATH"
echo "if [ -f $UPDATE_SCRIPT_PATH ]; then
        alias update-pib='/home/pib/update-pib.sh'
      fi
" >> $USER_HOME/.bashrc

# Download ros_config
curl "$ROS_CONFIG_URL" --location --output "$ROS_WORKING_DIR/ros_config.sh"  

# Setup system to start Cerebra and ROS2 at boot time
# Create boot script for ros_bridge_server
curl "$ROS_CEREBRA_BOOT_URL" --location --output  "$ROS_WORKING_DIR/ros_cerebra_boot.sh" 
sudo chmod 755 $ROS_WORKING_DIR/ros_cerebra_boot.sh

# Create service which starts ros and cerebra by system boot
curl "$ROS_CEREBRA_BOOT_SERVICE_URL" --location --output "$ROS_WORKING_DIR/ros_cerebra_boot.service" 
sudo chmod 755 $ROS_WORKING_DIR/ros_cerebra_boot.service
sudo mv $ROS_WORKING_DIR/ros_cerebra_boot.service /etc/systemd/system

# Enable new services
sudo systemctl daemon-reload
sudo systemctl enable ros_cerebra_boot.service
# Enable and start ssh server
sudo systemctl enable ssh --now

# Download animated pib eyes
curl --location --output ~/Desktop/pib-eyes-animated.gif "https://raw.githubusercontent.com/pib-rocks/setup-pib/""${repo_map[$SETUP_PIB_ORIGIN]}""/setup_files/pib-eyes-animated.gif"

# Move log file to temporary setup folder
mv "$LOG_FILE" "$TEMPORARY_SETUP_DIR"

echo -e "$NEW_LINE""Congratulations! The setup completed succesfully!"
echo -e "$NEW_LINE""Please restart the system to apply changes..."