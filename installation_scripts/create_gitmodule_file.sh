#!/bin/bash
#
# This script creates a .gitmodules file based on user input
# To properly run this script relies on being sourced by the "setup-pib.sh"-script

echo -e "$YELLOW_TEXT_COLOR""-- Creating .gitmodule file --""$RESET_TEXT_COLOR""$NEW_LINE"

# Path-Variable
readonly GIT_PROJECT_DIR="$ROS_WORKING_DIR""/src/"

# Setup ros-workspace
sudo chmod -R 700 "$ROS_WORKING_DIR"
sudo chmod -R 700 "$GIT_PROJECT_DIR"

# Initialize a git repo
echo 'check if git init is done'
cd "$GIT_PROJECT_DIR"
if [ ! -f .git ]; then
	git init
fi

# Git pull ros-packages repo
git pull "$ROS_PACKAGES_ORIGIN"

# Folder names (=package names) for submodules
readonly VOICE_ASSISTANT_PACKAGE_NAME="voice-assistant"
readonly PROGRAMS_PACKAGE_NAME="programs"
readonly MOTORS_PACKAGE_NAME="motors"
readonly DATATYPES_PACKAGE_NAME="datatypes"
readonly OAK_D_LITE_PACKAGE_NAME="ros2_oak_d_lite"

# Assemble submodule information in variables (\n = new line \t = tab)
readonly VOICE_ASSISTANT_GITMODULE="[submodule \"$VOICE_ASSISTANT_PACKAGE_NAME\"]\n\t path = $VOICE_ASSISTANT_PACKAGE_NAME\n\t url = $VOICE_ASSISTANT_ORIGIN\n\t branch = ${repo_map[$VOICE_ASSISTANT_ORIGIN]}\n"
readonly PROGRAMS_GITMODULE="[submodule \"$PROGRAMS_PACKAGE_NAME\"]\n\t path = $PROGRAMS_PACKAGE_NAME\n\t url = $PROGRAMS_ORIGIN\n\t branch = ${repo_map[$PROGRAMS_ORIGIN]}\n"
readonly MOTORS_GITMODULE="[submodule \"$MOTORS_PACKAGE_NAME\"]\n\t path = $MOTORS_PACKAGE_NAME\n\t url = $MOTORS_ORIGIN\n\t branch = ${repo_map[$MOTORS_ORIGIN]}\n"
readonly DATATYPES_GITMODULE="[submodule \"$DATATYPES_PACKAGE_NAME\"]\n\t path = $DATATYPES_PACKAGE_NAME\n\t url = $DATATYPES_ORIGIN\n\t branch = ${repo_map[$DATATYPES_ORIGIN]}\n"
readonly OAK_D_LITE_GITMODULE="[submodule \"$OAK_D_LITE_PACKAGE_NAME\"]\n\t path = $OAK_D_LITE_PACKAGE_NAME\n\t url = $OAK_D_LITE_ORIGIN\n\t branch = ${repo_map[$OAK_D_LITE_ORIGIN]}\n"

# Overwrite the .gitmodules file
chmod 700 "$GIT_PROJECT_DIR"".gitmodules"
readonly GITMODULE_FILE_CONTENT="$VOICE_ASSISTANT_GITMODULE""$PROGRAMS_GITMODULE""$MOTORS_GITMODULE""$DATATYPES_GITMODULE""$OAK_D_LITE_GITMODULE"
echo -e $GITMODULE_FILE_CONTENT > "$GIT_PROJECT_DIR"".gitmodules"

echo -e "$NEW_LINE""$GREEN_TEXT_COLOR""-- .gitmodules file creation completed --""$RESET_TEXT_COLOR""$NEW_LINE"