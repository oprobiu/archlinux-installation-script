#!/bin/bash
set -m
# Main file for the Arch Linux installation.
# Calls for functions in the ArchLinuxFunctions.sh
# sourcing
  source $1
  source ./functions.sh
# General Functions
  ## Initialize colors for messages
	export NORMAL_BOLD="\033[97;1m"
	export WARNING_COLOR="\033[33;107m"
	export ERROR_COLOR="\033[31;107m"
	export RESET_COLOR="\033[0m"
  ## Booting up message to check colors
  echo -e "${ERROR_COLOR}Booting up...${RESET_COLOR}"
  sleep 0.3
  echo -e "${WARNING_COLOR}Booting up...${RESET_COLOR}"
  sleep 0.3
  echo -e "${NORMAL_BOLD}Booting up...${RESET_COLOR}"
  sleep 0.3
  clear
  ## introduction of the script
  InstallationTypeMenu
  ##
  VerifyBoot
################################################################################
# Function listing
## The list of functions that will be run under a Int-Man situation
if [[ "$INSTALL_TYPE" == "1" ]]; then
  FunctionList="
  SfdiskFormat
  MirrorList
  EssentialPackages
  Fstab
  TimeZoneMenu
  LocalesFunction
  PasswordSetup
  ArchChrooting
  Reboot
  "
  #
elif [[ "$INSTALL_TYPE" == "2" ]]; then
  FunctionList="
  AutoMenu
  SfdiskFormat
  MirrorList
  EssentialPackages
  Fstab
  ArchChrooting
  Reboot
  "
elif [[ "$INSTALL_TYPE" == "3" ]]; then
  FunctionList="
  DefaultOptions
  AnalyseDisk
  PasswordSetup
  SfdiskFormat
  Germnay | MirrorList
  EssentialPackages
  Fstab
  ArchChrooting
  Reboot
  "
fi
################################################################################
# RUNNING FUNCTIONS
  IFS=$'\n' read -rd '' -a FunctionArray <<<"$FunctionList" # internal field separator to newline
  for i in "${FunctionArray[@]}"
  do
    echo -e "
    Up next:  ${NORMAL_BOLD}${i}${RESET_COLOR}!
    "
    if [[ "$INSTALL_TYPE" == "1" ]]; then
      ContinueSeparate
      if [ "$ContinueAction" = "y" ]; then
        eval "$i"
      elif [ "$ContinueAction" = "s" ]; then
        echo "${WARNING_COLOR}$i was skipped${RESET_COLOR}"
      elif [ "$ContinueAction" = "e" ]; then
        exit
      fi
    else
      eval "$i"
    fi

  done
    Separate
    echo -e "
        ${NORMAL_BOLD} THE END OF THE SCRIPT!${RESET_COLOR}
        "
    Separate
###########################################################################