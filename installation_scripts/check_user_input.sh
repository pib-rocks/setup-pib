#!/bin/bash
#
# This script validates the user input arguments when calling the setup script
# To properly run, this script relies on being sourced by the "setup-pib.sh"-script

# The help function shows infos about the command-line parameter options, then exits the script
help_function() 
{
	echo -e "Information about this script:"
	echo -e "This script has two execution modes (normal mode and development mode).""$NEW_LINE"
	echo -e "$YELLOW_TEXT_COLOR""To start the script in normal mode, don't add any arguments or options.""$RESET_TEXT_COLOR"
	echo -e "Example: ./setup-pib""$NEW_LINE""$NEW_LINE"
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
			help_function
			;;
		*)
			echo -e "$RED_TEXT_COLOR""Invalid option inputs. Here is some info about the possible user inputs:""$RESET_TEXT_COLOR""$NEW_LINE"
			help_function
	esac
	shift
done

echo -e "$GREEN_TEXT_COLOR""-- User input option and argument syntax valid --""$RESET_TEXT_COLOR""$NEW_LINE"