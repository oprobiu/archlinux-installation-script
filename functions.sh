#!/bin/bash
# FUNCTIONS file for the ArchLinux installation.
#############
# to chOose yes or no
#
function YesOrNo(){
  # variable $1 will get y or n
	local error_flag=true
      while [ "$error_flag" = true ]; do
          read -p" [Y/n]:  " answerLocal
          if [ "$answerLocal" = "y" ] || [ -z "$answerLocal" ] || [ "$answerLocal" = "Y" ] || [ "$answerLocal" = "Yes" ] || [ "$answerLocal" = "YES" ]; then
              # echo "You entered 'y'"
              eval "$1='y'"
              # answerLocal="y"
              error_flag=false
          elif [ "$answerLocal" = "n" ] || [ "$answerLocal" = "N" ] || [ "$answerLocal" = "No" ] || [ "$answerLocal" = "no" ] || [ "$answerLocal" = "NO" ]; then
              # echo "You entered 'n'"
              eval "$1='n'"
              # answerLocal="n"
              error_flag=false
          else
              echo "Invalid input. Please enter [Y/n].  "
          fi
      done
}

function NoOrYes(){
    # variable $1 will get y or n
    # default no
  	local error_flag=true
        while [ "$error_flag" = true ]; do
            read -p" [N/y]:  " answerLocal
            if [ "$answerLocal" = "y" ] || [ "$answerLocal" = "Y" ] || [ "$answerLocal" = "Yes" ] || [ "$answerLocal" = "YES" ]; then
                # echo "You entered 'y'"
                eval "$1='y'"
                # answerLocal="y"
                error_flag=false
            elif [ "$answerLocal" = "n" ] || [ -z "$answerLocal" ]  || [ "$answerLocal" = "N" ] || [ "$answerLocal" = "No" ] || [ "$answerLocal" = "no" ] || [ "$answerLocal" = "NO" ]; then
                # echo "You entered 'n'"
                eval "$1='n'"
                # answerLocal="n"
                error_flag=false
            else
                echo "Invalid input. Please enter [Y/n].  "
            fi
        done
}
# Continue prompt
function Continue(){
  echo -e "${NORMAL_BOLD} Continue..?${RESET_COLOR}
    Default option ${WARNING_COLOR}[Y]${RESET_COLOR}
  If you want to ${WARNING_COLOR}[skip]${RESET_COLOR}, or ${WARNING_COLOR}[s]${RESET_COLOR}
  If not, ${WARNING_COLOR}[exit]${RESET_COLOR}/${WARNING_COLOR}[n]${RESET_COLOR} or press ctrl+c: "
  ContinueAction=""
  local answerLocal
  while true
  do
    read -r answerLocal
    if [ "$answerLocal" = "y" ] || [ -z "$answerLocal" ] || [ "$answerLocal" = "Y" ] || [ "$answerLocal" = "Yes" ] || [ "$answerLocal" = "YES" ]; then
      export ContinueAction="y"
      break;
    elif [ "$answerLocal" = "exit" ] || [ "$answerLocal" = "no" ] || [ "$answerLocal" = "n" ] || [ "$answerLocal" = "N" ]; then
      ContinueAction="e"
      exit
    elif [ "$answerLocal" = "skip" ] || [ "$answerLocal" = "SKIP" ] || [ "$answerLocal" = "s" ] || [ "$answerLocal" = "S" ]; then
      export ContinueAction="s"
      breakf
    fi
  done
}

# Function that combines Continue with and Separate, and asks if the users want's to continue to the next section or not?
function ContinueSeparate(){
  Separate
#  echo -e "
#    Next: $1
#  "
  Continue
  clear
  Separate
}

# Separate messages with two lines
function Separate(){
  cat << EOF

<+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+><+>
<*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*><*>

EOF
}

# Boot up verification for the script
function BootingUp(){
  echo -e "${ERROR_COLOR}Booting up...${RESET_COLOR}"
  sleep 0.3
  echo -e "${WARNING_COLOR}Booting up...${RESET_COLOR}"
  sleep 0.3
  echo -e "${NORMAL_BOLD}Booting up...${RESET_COLOR}"
  sleep 0.3
  clear
}

# Function for message type/Color, that takes the input message and give it a color and prefix message, such as WARNING or ERROR
function MessageType(){
	# NORMAL (white), WARNING (yellow + WARNING message) or ERROR (red + ERROR message)
	# Initialize the colors for messages
	export NORMAL_BOLD="\033[97;1m"
	export WARNING_COLOR="\033[33;107m"
	export ERROR_COLOR="\033[31;107m"
	export RESET_COLOR="\033[0m"
}

# Function to check if file exists or not

# Call for Intro function, that describes the archlinux installation code, whether manual or automatic
function Introduction(){
  Separate
echo -e "
    This is an ${NORMAL_BOLD} Arch Linux installation ${RESET_COLOR}.
    There are three options to choose from.
"
  # Choose the installation type
	InstallationTypeMenu

	sleep 1
}

# Call for manual/automatic installation of the archlinux
function InstallationTypeMenu(){

echo -e "
    This is an ${NORMAL_BOLD} Arch Linux installation ${RESET_COLOR}.
    There are three options to choose from.
"

  # Main menu for installing Arch Linux
  PS3="
  Please select a number!  "
  while true; do
    select choice in "Interactive-Manual Installation" "Interactive-Automatic Installation" "Non-interactive-Automatic Installation" "Exit"; do
      case $choice in
        "Interactive-Manual Installation")
          INSTALL_TYPE="1"
          echo -e "You chose the ${NORMAL_BOLD}Interactive-Manual Installation${RESET_COLOR}!"
          echo -e "
          This option ${NORMAL_BOLD}requires that you input certain values and choose whether to install or skip certain parts of the installation${RESET_COLOR}.
          "
          break;;
        "Interactive-Automatic Installation")
          INSTALL_TYPE="2"
          echo -e "You chose the ${NORMAL_BOLD}Interactive-Automatic Installation${RESET_COLOR}"
          echo -e "
          This option ${NORMAL_BOLD}requires that you input certain values but you WON'T be able to choose whether to install or skip certain parts of the installation${RESET_COLOR}.
          "
          break;;
        "Non-interactive-Automatic Installation")
          INSTALL_TYPE="3"
          echo -e "You chose the ${NORMAL_BOLD}Non-interactive-Automatic Installation${RESET_COLOR}"
          echo -e "
          This option will install Arch Linux with the ${NORMAL_BOLD}default options.
          "
          break;;
        "Exit")
          echo -e "Exiting... Goodbye!"
          exit;;
        *)
          echo -e "Invalid Option. Try again."
          continue;;
      esac
    done
    # Confirm action
    echo -e "
      Are you sure you want this type of installation?
    "
    confirmAction=""
    NoOrYes confirmAction
    if [[ "$confirmAction" == "y" ]]; then
      break;
    fi
  done
	# export option
	export INSTALL_TYPE
  #
}

# Call for manual/automatic installation of the archlinux
function FdiskMenu(){
  # starting variables
  DefaultOptions
  # local variables
  local VariableList=( "LINUX_PARTITION" "LINUX_PARTITION_M" "EFI_M" "SWAP_M" "ROOT_M" "NUM_PART" )
  local VariableArray
  local fdiskMenuFlag=true
  IFSFdiskMenu=$'\n' read -rd '' -a VariableArray <<<"${VariableList[@]}" # internal field separator to newline
  # Main menu for Fdisk options
  PS3="
  Please select a number!  "
  while [[ "$fdiskMenuFlag" == true ]]; do
    clear
    echo -e "These are you settings:
        - Where will the installation take place = ${LINUX_PARTITION}
        - EFI Memory = ${EFI_M}
        - SWAP Memory = ${SWAP_M}
        - Linux Root Memory = ${ROOT_M}
            ${WARNING_COLOR} Make sure the sum of these partitions <= ${LINUX_PARTITION_M} ${RESET_COLOR}
        - The total amount of Memory in you partition ${LINUX_PARTITION} = ${LINUX_PARTITION_M}
        - No. of partitions = ${NUM_PART}

        ${WARNING_COLOR} Make sure none of these fields are empty ${RESET_COLOR}
    "
    select choice in "Current Installation Partition" "EFI Memory" "SWAP Space" "Linux Root Space" "No. of partitions" "Exit Menu"; do
      case $choice in
        "Current Installation Partition")
          AnalyseDisk
          break;;
        "EFI Memory")
          if [[ "$EFI" == "0" ]]; then
            echo -e "${NORMAL_BOLD}Choose the value for the EFI Memory ${RESET_COLOR}!"
            ReadValue EFI_M
          elif [[ "$EFI" == "1" ]]; then
            echo -e "${NORMAL_BOLD} Since you have DOS/MBR, there will be no EFI Memory${RESET_COLOR}!"
            EFI_M="0MiB"
          fi
          break;;
        "SWAP Space")
          echo -e "${NORMAL_BOLD}Choose the value for the SWAP Space ${RESET_COLOR}!
                If you don't want to have a swap partition, type ${NORMAL_BOLD}0${RESET_COLOR} or ${NORMAL_BOLD}off${RESET_COLOR} "

          ReadValue SWAP_M
          if [[ "${SWAP_M}" == "0" ]] || [[ "${SWAP_M}" == "off" ]]; then
            SWAP_M="0"
          fi

          break;;
        "Linux Root Space")
          echo -e "${NORMAL_BOLD}Choose the value for the Linux Root Space ${RESET_COLOR}!"
          ReadValue ROOT_M
          break;;
        "No. of partitions")
          echo -e "${NORMAL_BOLD}Choose the value for the No. of partitions ${RESET_COLOR}!"
          ReadValue NUM_PART
          break;;
        "Exit Menu")
          # Confirm action
          echo -e "
            Are you sure you want to continue with these settings?
            - Current installation partition = ${LINUX_PARTITION}
                   with an available memory of ${LINUX_PARTITION_M}
            - EFI Memory = ${EFI_M}
            - SWAP Memory = ${SWAP_M}
            - Linux Root Memory = ${ROOT_M}
            - No. of partitions = ${NUM_PART}
          "
          exitMenu=""
          NoOrYes exitMenu
          break;;
        *)
          echo -e "Invalid Option. Try again."
          continue;;
      esac
    done
    # check for empty fields
    if [[ "$exitMenu" == "y" ]]; then
      for i in "${VariableArray[@]}"
      do
        echo "i = $i"
        if [[ -z "${!i}" ]]; then
          echo -e "${ERROR_COLOR} $i is empty ${RESET_COLOR}
          You must assign a value to this variable!"
          exitMenu="n"
        fi
      done
      if [[ "$exitMenu" == "y" ]]; then
  #     if [[ "$exitMenu" == "n" ]]; then
        echo -e "Exiting Menu...!"
        fdiskMenuFlag=false
      fi
#      sleep 0.1
    fi

  done
  # exporting options
  ExportOptions
  # come back to main menu?
  if [[ "$comeBackToAutoMenu" == true ]] || [[ $INSTALL_TYPE == 2 ]];
  then
     AutoMenu
  fi


}

# Verify the boot mode
function VerifyBoot(){
	echo "Verifying boot mode..."
	sleep 1
	if [ -d "/sys/firmware/efi/efivars" ]; then
		echo -e "${NORMAL_BOLD}The /sys/firmware/efi/efivars directory exits, therefore your boot is EFI and you will have to create a EFI partition ${RESET_COLOR}"
	  export EFI="0"
	else
		echo -e "${WARNING_COLOR}the /sys/firmware/efi/efivars doesn't exist, therefore you'll be using MBR and you won't need to create a supplementary partition for the Boot ${RESET_COLOR}"
		#
#		echo -e "${WARNING_COLOR}however, this script does not support non-EFI installations, therefore the program will close. Bye!${RESET_COLOR}"
    export EFI="1"
		# exit until you make a case for non-EFI
#		exit
	fi
	# default options export
	DefaultOptions
}

# function to check if the value introduced is good or not
function ReadValue(){
  # $1 is the variable name that will get the value from reading the input. DO NOT USE QUOTES
  # the user will be prompted to check if his choice is the one they wanted
  local varvalue
  local varname="$1"
  local areYouSure=""
  areYouSure="n"
  while [ "$areYouSure" == "n" ];
  do
      read -p "Input:  " varvalue
      if [[ -z "$varvalue" ]] || [[ -z "$varname" ]]; then
        echo -e "${ERROR_COLOR}Either the variable name is an empty string << ${varname} >>,
        or the value of that variable << ${varvalue} >>${RESET_COLOR}.
        Try again!"
      else
        echo -e "${NORMAL_BOLD}Are you certain you want to assign ${varvalue} to ${varname}?${RESET_COLOR}"
        YesOrNo areYouSure
        if [[ "$areYouSure" == "y" ]]; then
          eval "export $1='${varvalue}' "
          echo "$areYouSure"
        fi
      fi

  done

}

# Analyse the disks with fdisk -l and then make the user select on which disk should the Arch Linux be installed.
function AnalyseDisk(){
	echo -e "
	Analysing disks with fdisk -l
	You have to choose which partition you want to use for the Arch Linux Installation.
  "
	fdisk -l
	echo -e "\n${NORMAL_BOLD} Choose the partition you want to install Arch Linux on ${RESET_COLOR}\n(e.g. /dev/sda)"
	ReadValue LINUX_PARTITION

  # Find the available memory on LINUX_PARTITION
  Separate
  LINUX_PARTITION_M=$(AvailableMemory "${LINUX_PARTITION}") > /dev/null
  export LINUX_PARTITION_M
  echo -e "The partition you chose, ${NORMAL_BOLD}${LINUX_PARTITION}${RESET_COLOR}, has a maximum memory of ${WARNING_COLOR}${LINUX_PARTITION_M}${RESET_COLOR} available as storage."
  sleep 1
}

# Function that checks the available memory for a partition
function AvailableMemory(){
  # $1 is the partition name that will be checked with lsblk
  # will print the memory of that partition
  local parititon="$1"
  local memory=""

  memory=$(lsblk "$parititon" | awk 'NR==2 {print $4}')
  # exporting the memory
  echo "$memory"
}

# Open fdisk on he selected partition and format it, according to some inputs or standard features
function FdiskFormat(){
  if [[ "$INSTALL_TYPE" == 1 ]]; then
      FdiskMenu
#    fi
  fi
  # do fdisk for partition
  echo -e "
    Running Fdisk...
  "
  # fdisk will make 3 partitions, EFI, SWAP and Linux, in this exact order.
  sudo fdisk "${LINUX_PARTITION}" << EOF
  g
  # EFI partition
  n


  +${EFI_M}
  t
  1
  # swap partition
  n


  +${SWAP_M}
  t
  2
  19
  # LINUX partition with the rest of the memory. ROOT_M will replace enter and would have to be calculated in the future.
  n



  t

  23

  w
EOF
#
  echo -e "${NORMAL_BOLD}   Done!The disk has been formatted!${RESET_COLOR}"
}

# Sfdisk Open fdisk on he selected partition and format it, according to some inputs or standard features
function SfdiskFormat(){
  if [[ "$INSTALL_TYPE" == 1 ]]; then
      FdiskMenu
#    fi
  fi
  # do fdisk for partition
  echo -e "
    Running Fdisk...
  "
  # sfdisk will make 3 partitions, EFI, SWAP and Linux, in this exact order.
  if [[ "${SWAP_M}" != "0" ]]; then
    if [[ "${EFI}" == "0" ]]; then
#
sudo sfdisk ${LINUX_PARTITION} << EOF
label: gpt
device: ${LINUX_PARTITION}
size=${EFI_M}, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B,
size=${SWAP_M}, type=0657FD6D-A4AB-43C4-84E5-0933C84B4F4F,
type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709,
EOF
#
    elif [[ "${EFI}" == "1" ]]; then
sudo sfdisk ${LINUX_PARTITION} << EOF
label: dos
device: ${LINUX_PARTITION}
size=${SWAP_M}, type=82,
type=83,
EOF
    fi
#
  elif [[ "${SWAP_M}" == "0" ]]; then
    if [[ "${EFI}" == "0" ]]; then
#
sudo sfdisk ${LINUX_PARTITION} << EOF
label: gpt
device: ${LINUX_PARTITION}
size=${EFI_M}, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B,
type=4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709,
EOF
    elif [[ "${EFI}" == "1" ]]; then
#
sudo sfdisk ${LINUX_PARTITION} << EOF
label: dos
device: ${LINUX_PARTITION}
type=82,
EOF
    fi
fi
  echo -e "${NORMAL_BOLD}   Done!The disk has been formatted!${RESET_COLOR}"
###
  # Choosing filesystem
echo -e "
  ${NORMAL_BOLD}The partition(s) just created will get their corresponding file systems${RESET_COLOR}
  "
  if [[ "$EFI" == "0" ]];
  then
    export EFI_PART_NUM="1"
    export EFI_PART="${LINUX_PARTITION}${EFI_PART_NUM}"
    # format EFI partition
    mkfs.fat -F 32 "$EFI_PART"
    echo "EFI partition done!"
    # format SWAP partition
    if [[ "${SWAP_M}" != "0" ]]; then
      export SWAP_PART_NUM="2"
      export ROOT_PART_NUM="3"
      #
      export SWAP_PART="${LINUX_PARTITION}${SWAP_PART_NUM}"
      export ROOT_PART="${LINUX_PARTITION}${ROOT_PART_NUM}"
      mkswap "${SWAP_PART}"
      echo "SWAP partition done!"
    else
      #
      export ROOT_PART_NUM="2"
      #
      export ROOT_PART="${LINUX_PARTITION}${ROOT_PART_NUM}"
    fi
  elif [[ "$EFI" == "1" ]]; then
    if [[ "${SWAP_M}" != "0" ]]; then
      export SWAP_PART_NUM="1"
      export ROOT_PART_NUM="2"
      #
      export SWAP_PART="${LINUX_PARTITION}${SWAP_PART_NUM}"
      export ROOT_PART="${LINUX_PARTITION}${ROOT_PART_NUM}"
      #
      mkswap "${SWAP_PART}"
      echo "SWAP partition done!"
    else
      #
      export ROOT_PART_NUM="1"
      #
      export ROOT_PART="${LINUX_PARTITION}${ROOT_PART_NUM}"
    fi
  fi
    # format LINUX partition
    mkfs.ext4 "${ROOT_PART}"
    echo "ROOT partition done!"
    #
    mkdir /mnt/boot
    echo -e "
        ${NORMAL_BOLD}Done!File systems created!${RESET_COLOR}
    "
    ######
  echo -e "
    ${NORMAL_BOLD}Mounting partitions...${RESET_COLOR}"
  sleep 0.2
  # mount Linux
  echo -e "
  ${NORMAL_BOLD}Mounting the root ${ROOT_PART} ${RESET_COLOR}"
  sleep 0.2
  mount "$ROOT_PART" /mnt
  #mount efi
  if [[ "$EFI" == "0" ]]; then
    # mount EFI
    echo -e "
    ${NORMAL_BOLD}Mounting the EFI ${EFI_PART}${RESET_COLOR}"
    sleep 0.2
    mount --mkdir "$EFI_PART" /mnt/boot
  fi
  # start swap
  if [[ "${SWAP_M}" != "0" ]]; then
      echo -e "
      ${NORMAL_BOLD}Mounting the SWAP ${SWAP_PART}${RESET_COLOR}"
      sleep 0.2
      swapon "$SWAP_PART"
      #
  fi
    echo -e "
    ${NORMAL_BOLD}Partitions mounted.${RESET_COLOR}"

}

# Create the FileSystems for the partitions made with FdiskFormat
function FileSystem(){
  echo -e "
  ${NORMAL_BOLD}The 3 partitions just created will get their corresponding file systems${RESET_COLOR}
  "
  # format EFI partition
  mkfs.fat -F 32 /dev/sda1
  #
  export EFI_PART_NUM="1"
  export EFI_PART="${LINUX_PARTITION}${EFI_PART_NUM}"
  # format SWAP partition
  if [[ "${SWAP_M}" != "0" ]]; then
    export SWAP_PART_NUM="2"
    export ROOT_PART_NUM="3"
    #
    export SWAP_PART="${LINUX_PARTITION}${SWAP_PART_NUM}"
    export ROOT_PART="${LINUX_PARTITION}${ROOT_PART_NUM}"
    mkswap "${SWAP_PART}"
  else
    #
    export ROOT_PART_NUM="2"
    #
    export ROOT_PART="${LINUX_PARTITION}${ROOT_PART_NUM}"
  fi

  # format LINUX partition
  mkfs.ext4 "${ROOT_PART}"
  #
  mkdir /mnt/boot
  echo -e "
      ${NORMAL_BOLD}Done!File systems created!${RESET_COLOR}
  "
}

# Mount the partitions
function MountPartitions(){
  echo -e "
  ${NORMAL_BOLD}Mounting partitions...${RESET_COLOR}"
  sleep 0.2
  # mount Linux
  echo -e "
  ${NORMAL_BOLD}Mounting the root /dev/sda3${RESET_COLOR}"
  sleep 0.2
  mount "$ROOT_PART" /mnt
  # mount EFI
  echo -e "
  ${NORMAL_BOLD}Mounting the EFI /dev/sda1${RESET_COLOR}"
  sleep 0.2
  mount --mkdir "$EFI_PART" /mnt/boot
  # start swap
  if [[ "${SWAP_M}" != "0" ]]; then
    echo -e "
    ${NORMAL_BOLD}Mounting the SWAP /dev/sda2${RESET_COLOR}"
    sleep 0.2
    swapon "$SWAP_PART"
    #
  fi
  echo -e "
  ${NORMAL_BOLD}Partitions mounted.${RESET_COLOR}"
  #
}

# Select mirror for programs to download
function MirrorList(){
  #
  if [[ "$comeBackToAutoMenu" == true && "$INSTALL_TYPE" == 2  ]] || [[ "$INSTALL_TYPE" == 1 ]]
  then
    #
    mirrorListFlag=true
    country_list=$(reflector --list-countries)
    #
    #
    echo -e "The script will update the list of urls in ${NORMAL_BOLD}/etc/pacman.d/mirrorlist${RESET_COLOR} from which it wil download and install the essential packages for you Arch Linux installation.
  Therefore, you should specify which countries you would like to download those packages from.
      - E.g. if you want to download from ${NORMAL_BOLD}France only${RESET_COLOR}, type << ${NORMAL_BOLD}France${RESET_COLOR} >> below (without the << >>);
      - E.g. if you want to download from ${NORMAL_BOLD}France, Germany and Spain${RESET_COLOR}, then type << ${NORMAL_BOLD}France,Germany,Spain${RESET_COLOR} >> below (without the << >>);
      - If you need the full ${NORMAL_BOLD}list of countries available${RESET_COLOR}, then type << ${NORMAL_BOLD}L${RESET_COLOR} >> below (without the << >>).
      - If you want to with the default options, press ${NORMAL_BOLD}enter${RESET_COLOR} or type ${NORMAL_BOLD}default${RESET_COLOR}!
    "
    #
    while [[ "$mirrorListFlag" == true ]];
    do
      read -r -p "Enter you desired option:  " MirrorArray
      if [ "$MirrorArray" = "L" ] || [ "$MirrorArray" = "l" ]; then
        reflector --list-countries | less
  #      MirrorList
      elif [ -z "$MirrorArray"  ] || [ "$MirrorArray" = "default" ] || [ "$MirrorArray" = "Default" ] || [ "$MirrorArray" = "DEFAULT" ]; then
        # default options
        MirrorArray="default"
        echo -e "${NORMAL_BOLD}   Default Option!${RESET_COLOR}"
        sleep 1
        #
        mirrorListFlag=false
        export MirrorArray
      elif Check_List "$MirrorArray" "$country_list" "country"; then
        echo -e "${NORMAL_BOLD}   Input is Valid! Continue...${RESET_COLOR}"
  #      UpdateMirrorList "$MirrorArray"
        mirrorListFlag=false
        export MirrorArray
        sleep 1

      else
        echo -e "${WARNING_COLOR}Invalid input! Try again.${RESET_COLOR}";
        sleep 1
      fi
    done
  fi
#  # come back to main menu?
#  if [[ "$comeBackToAutoMenu" == true ]] && [[ $INSTALL_TYPE == 2 ]]
#  then
#    AutoMenu
#    break
#  fi
  if [[ "$comeBackToAutoMenu" == false && "$INSTALL_TYPE" == 2  ]] || [[ "$INSTALL_TYPE" == 1 ]]
  then
    echo -e "${NORMAL_BOLD} Updating Mirror List with '${MirrorArray}' ${RESET_COLOR}"
    UpdateMirrorList "$MirrorArray"
  fi
}

# update the mirrror list
function UpdateMirrorList(){
  # functioon to update the mirror list for pacman
  # $1 is the country array chosen by the user
  local countryArray="$1"
  if [[ "$countryArray" != "default"  ]]; then
    echo -e "${NORMAL_BOLD}   Updating the list in /etc/pacman.d/mirrorlist ...${RESET_COLOR}"
    # update with reflector
    reflector --verbose --latest 10 --country "${countryArray}" --age 12 --sort rate --save "/etc/pacman.d/mirrorlist"
    echo -e "${NORMAL_BOLD}   Done! List updated${RESET_COLOR}"
  else
    echo -e "${NORMAL_BOLD}   For the default option, NO changes were made to the mirror list ${RESET_COLOR}"
  fi

}

# Function that checks if the countries introduced for Mirror List by the user are actually found in the reflector list
#function Check_Countries (){
#  #
#  local input=$1
#  local country_list=$2
#  # IFS = internal field separator
#  # put into an array the countries from input
#  IFS=',' read -ra input_countries <<< "$input"
#  # check the array to see if the input countries are in the list
#  for country in "${input_countries[@]}"; do
#    if ! grep -qw "$country" <<< "$country_list"; then
#      # wrong country
#      return 1
#    elif [[ -z "$country" ]]; then
#      # empty
#      return 1
#    fi
#  done
#  # correct countries
#  return 0
#}

# Function to check if somethings are in a list
function Check_List(){
  # $1 is the string inputed by the user, separated by a comma to be checked against the list in $2
  # $3 checks whether it's the special case check countries that you want
  local input=$1
  local ambiguous_list=$2
  local checkCountriesFlag=$3
  # to lower case
  input=$(echo "$input" | awk '{print tolower($0)}')
  ambiguous_list=$(echo "$ambiguous_list" | awk '{print tolower($0)}')
  #
  # IFS = internal field separator
  # put into an array the contents from input $1
  IFS=',' read -ra input_array <<< "$input"
  # check the array to see if the input $1 is in the list
  if [[ "$checkCountriesFlag" != "country" ]]; then
    for i in "${input_array[@]}"; do
      if ! grep -qx "${i}[[:space:]]*" <<< "{$ambiguous_list}"; then
        # wrong i
        return 1
      elif [[ -z "$i" ]]; then
        # empty
        return 1
      fi
    done
  elif [[ "$checkCountriesFlag" == "country" ]]; then
    for i in "${input_array[@]}"; do
      if ! grep -qw "$i" <<< "{$ambiguous_list}"; then
        # wrong country
        return 1
      elif [[ -z "$i" ]]; then
        # empty
        return 1
      fi
    done
  fi
  # correct countries
  return 0


}

# Install essential packages for arch
function EssentialPackages(){

  BasePackagesList=("base" "linux" "linux-firmware" "vim" "nano" "e2fsprogs" "mdadm" "man-db" "man-pages" "texinfo" "openssh" )
  echo -e "
  ${NORMAL_BOLD}Downloading essential packages set by default into the installation destination${RESET_COLOR}
  "
  pacman -Sy --needed archlinux-keyring


if [[ "$INSTALL_TYPE" == 1 ]]; then
  for i in "${BasePackagesList[@]}"
  do
    echo -e "
            ${NORMAL_BOLD}Download: $i?${RESET_COLOR}
       "
    ContinueSeparate
    if [ "$ContinueAction" = "y" ]; then
      while true
      do
        pacstrap -K /mnt --noconfirm "$i"
        echo -e "${NORMAL_BOLD}If some operation was not successful, you can retry to reinstall these packages${RESET_COLOR}"
        RETRY=""
        NoOrYes RETRY
        if [ "$RETRY" = "n" ]; then
          break;
        fi
      done
    elif [ "$ContinueAction" = "s" ]; then
      echo "${WARNING_COLOR}$i was skipped...${RESET_COLOR}"
    fi
  done
elif [[ "$INSTALL_TYPE" == 2 ]]; then
  pacstrap -K /mnt --noconfirm "${BasePackagesList[@]}"
elif [[ "$INSTALL_TYPE" == 3 ]]; then
  pacstrap -K /mnt --noconfirm "${BasePackagesList[@]}"
fi


  echo -e "
    ${NORMAL_BOLD}Done! The Essential Packages have been installed!${RESET_COLOR}
    "
}

# WIP function that fetches a list from the url, trims it down.
function Fetch_List_Url(){
  local url=$1
  # fetch and trim
  list_arch_essentials="$(curl -s "$url" | cut -d ' ' -f 1)"
  # export it
  export list_arch_essentials

}

# function for generating fstab.
function Fstab(){
  local fstabFlag=true
  while [[ "$fstabFlag" == true ]]; do
    # Generate an fstab file
    genfstab -U /mnt >> /mnt/etc/fstab
    # check if generated
    if [ -f /mnt/etc/fstab ]; then
      echo -e "${NORMAL_BOLD}fstab file generated @ /mnt/etc/fstab${RESET_COLOR}."
      break;
    else
      echo -e "
      ${ERROR_COLOR}fstab file was NOT generated @ /mnt/etc/fstab${RESET_COLOR}.
   
      ${WARNING_COLOR} Do you want to try and generate the fstab file again?${RESET_COLOR} "
      answer=""
      YesOrNo answer
      if [ "$answer" = "y" ]
      then
        echo "" >> /dev/null
      else
        exit
      fi
    fi

  done
}

# function to set the timezone
function TimeZoneMenu(){
  #
  local listOfTimezones
  listOfTimezones=$(timedatectl list-timezones)
  local TimeZoneMenuFlag=true
  echo -e "
    ${NORMAL_BOLD}You can choose the timezone${RESET_COLOR}
  - E.g if you want the ${NORMAL_BOLD} Canada timezone ${RESET_COLOR}, type << ${NORMAL_BOLD}Canada/Eastern${RESET_COLOR} >> below (without the << >>).
  - If you need the full ${NORMAL_BOLD}list of Timezones available${RESET_COLOR}, type << ${NORMAL_BOLD}L${RESET_COLOR} >> below (without the << >>).
  - If you want to use the default options, press ${NORMAL_BOLD}enter${RESET_COLOR} or type ${NORMAL_BOLD}default${RESET_COLOR}
  "

  while [[ "$TimeZoneMenuFlag" == true ]];
  do
    read -r -p "Enter you desired option:  " INPUT
    #
    if [ "$INPUT" = "L" ] || [ "$INPUT" = "l" ]; then
        timedatectl list-timezones| less
        clear
    elif [ -z "$INPUT"  ] || [ "$INPUT" = "default" ]; then
      # default options
      echo -e "${NORMAL_BOLD}   Default Option!${RESET_COLOR}"
      echo -e "Timezone UTC!"
      #
      Region="Etc"
      City="UTC"
      #
      TimeZoneMenuFlag=false
#      break;
      #
      sleep 1
    elif Check_List "$INPUT" "$listOfTimezones" "non"; then
      echo -e "${NORMAL_BOLD}   Input is Valid!${RESET_COLOR}"
      #
      Region=$(cut -d '/' -f 1 <<< ${INPUT})
      City=$(cut -d '/' -f 2 <<< ${INPUT})
      echo -e "Timezone selected! ${Region} ${City}"
#      break;
      TimeZoneMenuFlag=false
      #
      sleep 1
    else
      echo -e "${WARNING_COLOR}Invalid input. Try again.${RESET_COLOR}";
    fi
  done
#  if [[ "$INSTALL_TYPE" == "1" ]]; then
#    TimeZoneChroot
#  fi
  # export options
  ExportOptions
}

#
function TimeZoneChroot(){
  # arch chroot for time zone settings

echo -e "Configuring with arch-chroot..."
#arch-chroot /mnt << CHROOT
  #
echo -e "       ${NORMAL_BOLD} You're inside the new root ${RESET_COLOR}"
echo -e "       ${NORMAL_BOLD} Setting the timezone ${Region}/${City}${RESET_COLOR}..."
ln -sf /usr/share/zoneinfo/${Region}/${City} /etc/localtime

# generate /ect/adjtime
echo -e "       ${NORMAL_BOLD} Generate /ect/adjtime and localization${RESET_COLOR}..."
hwclock --systohc
  #
#CHROOT
echo -e "${NORMAL_BOLD} You're outside the new root ${RESET_COLOR}"

}

# function to set up locales
function LocalesFunction(){
  #
  local LocalesMenuFlag=true
  local listOfLocales
  LocalesOption=""
  #
  sudo locale-gen >> /dev/null
  listOfLocales=$(cat /etc/locale.gen)
  echo -e "
    ${NORMAL_BOLD}You can choose the locales${RESET_COLOR}
  - E.g if you want the ${NORMAL_BOLD}en_US.UTF-8 UTF-8${RESET_COLOR} locale, type << ${NORMAL_BOLD}en_US.UTF-8 UTF-8${RESET_COLOR} >> below (without the << >>).
  - If you need the full ${NORMAL_BOLD}list of locales available ${RESET_COLOR}, type << ${NORMAL_BOLD}L${RESET_COLOR} >> below (without the << >>).
  - If you want to use the default options, press ${NORMAL_BOLD}enter${RESET_COLOR} or type ${NORMAL_BOLD}default${RESET_COLOR}
  "
  while [[ "$LocalesMenuFlag" == true ]];
  do
    read -r -p "Enter you desired option:  " LocalesOption
    #
    if [ "$LocalesOption" = "L" ] || [ "$LocalesOption" = "l" ];
    then
      echo "$listOfLocales" | less

    elif [ -z "$LocalesOption"  ] || [ "$LocalesOption" = "default" ];
    then
      # default options
      echo -e "${NORMAL_BOLD}   Default Option!${RESET_COLOR}"
      echo -e "Locale en_US.UTF-8 UTF-8!"
      #
      langVar="en_US.UTF-8"
      #
      LocalesMenuFlag=false
      #
      sleep 1
    elif Check_List "#${LocalesOption}" "$listOfLocales";
    then
      echo -e "${NORMAL_BOLD}   Input is Valid!${RESET_COLOR}"
      #
      langVar=$(cut -d ' ' -f 1 <<< ${LocalesOption})
      echo -e "Locale selected! ${langVar}"
      LocalesMenuFlag=false
      #
      sleep 1
    else
      echo -e "${WARNING_COLOR}Invalid input. Try again.${RESET_COLOR}";
    fi
  done
  #
#  if [[ "$INSTALL_TYPE" == "1" ]]; then
#    LocalesChroot
#  fi
  #
  export langVar
}

# function for Arch-Chroot
function ArchChrooting(){
  # enter arch chroot and call for the other functions
  cp ./functions.sh /mnt/root
  arch-chroot /mnt /bin/bash -- << EOFCHROOT
source \$HOME/functions.sh
    # user setup
StandardUserSetup
    # timezone chroot
TimeZoneChroot
    # locales
LocalesChroot
    # network management
NetMan
    # Grub config
GRUBFunction
    # install GUI
InstallGUI
    # exit
EOFCHROOT
}

function LocalesChroot(){
  echo -e "Configuring with arch-chroot..."
#arch-chroot /mnt << CHROOT
# generate localization
locale-gen
# editing /etc/locale.gen
sed -i 's/#${LocalesOption}[[:space:]]*/${LocalesOption}/g' /etc/locale.gen
#
echo "LANG=${langVar}" > /etc/locale.conf
#
#CHROOT
}

# Function for Network Management
function NetMan(){
  echo -e "
    ${NORMAL_BOLD}Configuring the Network... ${RESET_COLOR}
    "
  # Network Configuration
  # Create /etc/hostname file
  echo -e "Configuring with arch-chroot..."

# schimba yes | pacman in pacman no confirm
#arch-chroot /mnt << CHROOT
  pacman --noconfirm -S networkmanager
  echo "myhostname" > /etc/hostname
  echo -e "127.0.0.1	localhost\n::1		localhost \n127.0.1.1	myhostname"
  systemctl enable NetworkManager.service
#CHROOT
  echo -e "
    ${NORMAL_BOLD}Network configured successfully! ${RESET_COLOR}
    "
}
# Function to install GRUB
function GRUBFunction(){
  echo -e "
    ${NORMAL_BOLD}GRUB installation & configuration... ${RESET_COLOR}

    "
  #
  pacman --noconfirm -Sy grub
  if [[ "$EFI" == "0" ]]; then
    pacman --noconfirm -Sy efibootmgr
    mount --mkdir /dev/sda1 /boot/efi
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
  elif [[ "$EFI" == "1" ]]; then
    grub-install --target=i386-pc "$LINUX_PARTITION"
  fi
    #
  grub-mkconfig -o /boot/grub/grub.cfg
#
  echo -e "
    ${NORMAL_BOLD}GRUB configured successfully! ${RESET_COLOR}
    "
}

# function for password setup
function PasswordSetup(){
  # create user1 and set up the password
  echo -e "
      ${NORMAL_BOLD}Adding a new superuser! ${RESET_COLOR}
      Choose a username:  "
  ReadValue UserName
  export UserName
  #
  echo -e "
      ${NORMAL_BOLD} ${RESET_COLOR}
      Choose a password:  "
  stty -echo
  #
  local areYouSure=n
  local checker=""
  while [ "$areYouSure" == "n" ];
  do
    checker=""
    read -p "Input:  " PasswordUserName
    if [[ -z "$PasswordUserName" ]]; then
      echo -e "${ERROR_COLOR} Invalid choice of password. ${RESET_COLOR}.
        Try again!"
    else
      echo -e "${NORMAL_BOLD} Re-type your password ${RESET_COLOR}"
      read -p "Input:  " checker
      if [[ "$PasswordUserName" == "$checker" ]]; then
        echo -e "${NORMAL_BOLD}
        Password assigned successfully! ${RESET_COLOR}"
        areYouSure="y"
      else
        echo -e "${NORMAL_BOLD}
        Incorrect password! ${RESET_COLOR}"
      fi
    fi
  done
  export PasswordUserName
 stty echo
  #
}

# Function to have a standard set up for users and root
function StandardUserSetup(){
  #
  # installing sudo
  pacman --noconfirm -Sy sudo
#
  useradd -m "$UserName"
#
passwd "$UserName" << PASS
${PasswordUserName}
${PasswordUserName}
PASS
  # deallocate password
  unset PasswordUserName
  PasswordUserName=""
  # add user1 to wheel and other groups
  usermod -aG wheel,audio,video,storage "$UserName"
  # allow the wheel group to function
  sed -i 's/^# %wheel ALL=(ALL:ALL) ALL$/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers
  # end
#CHROOT
}

# Function to install a GUI (GNOME)
function InstallGUI(){
  #
if [[ "$INSTALL_TYPE" == "1" ]];
then
  INSTALL_GUI="y"
fi
if [[ "$INSTALL_GUI" == "y" ]]; then
  echo -e "
      ${NORMAL_BOLD}Setting up the GNOME as a Graphical User Interface ${RESET_COLOR}
            "

#arch-chroot /mnt << CHROOT
pacman -Sy gnome <<INSTALLER




INSTALLER
pacman -Sy  gnome-extra<<INSTALLER



INSTALLER

pacman -Sy xorg <<INSTALLER


INSTALLER
#
systemctl enable gdm.service
#CHROOT
echo -e  "${NORMAL_BOLD} Graphical User Interface Installed!${RESET_COLOR}"
fi

}

function Reboot(){
  # reboot the system
  echo -e "Rebooting..."
  sleep 1
  reboot
}
# Function for automatic non-interactive path for installing arch linux
function AutoMenu(){
  # The menu for the auto option, with interactive variables
  export comeBackToAutoMenu=true;
  local autoMenuFlag=true
  local exitMenu=""
  #
  PS3="
  Please select a number!  "
  while [[ "$autoMenuFlag" == true ]]
  do
    clear
    echo -e "This is the Main Menu for the Interactive-Automatic Installation

        ${WARNING_COLOR} Make sure you go through all of these options ${RESET_COLOR}

    "
    select choice in "Format Disks Menu" "MirrorList" "Essential Packages" "Configuration" "GUI" "Start the Installation";
    do
      case $choice in
        "Format Disks Menu")
          FdiskMenu
          break;;
        "MirrorList")
#          echo -e "${NORMAL_BOLD}${RESET_COLOR}!"
          MirrorList
          break;;
        "Essential Packages")
          echo -e "${NORMAL_BOLD}WIP${RESET_COLOR}!"
          break;;
        "Configuration")
          echo -e "${NORMAL_BOLD}WIP${RESET_COLOR}!"
          ConfigMenu
          break;;
        "GUI")
          echo -e "${NORMAL_BOLD}Do you want to Install a GUI (GNOME)? ${RESET_COLOR}!
          Current options: $INSTALL_GUI"
          YesOrNo INSTALL_GUI
          export INSTALL_GUI
          break;;

        "Start the Installation")
          # Confirm action
          echo -e "
            Are you sure you want to continue with these settings?
            ${WARNING_COLOR}You won't be able to come back to change things${RESET_COLOR}
          "
          NoOrYes exitMenu
          break;;
        *)
          echo -e "Invalid Option. Try again."
          continue;;
      esac
    done
    # exit
    if [[ "$exitMenu" == "y" ]]; then
      echo -e "Exiting AutoMenu...!"
      export comeBackToAutoMenu=false;
      autoMenuFlag=false
    fi

  done


}

# Function for automatic non-interactive path for installing arch linux
function ConfigMenu(){
  # The menu for the auto option, with interactive variables
#  export comeBackToConfigMenu=true;
  local ConfigMenuFlag=true
  local exitMenu=""
  #
  PS3="
  Please select a number!  "
  while [[ "$ConfigMenuFlag" == true ]]
  do
    clear
    echo -e "This is the Menu for the Configuration Options

        ${WARNING_COLOR} Make sure you go through all of these options ${RESET_COLOR}

    "
    select choice in "Super User Setup" "Timezones" "Locales" "Network Management" "Exit Menu";
    do
      case $choice in
        "Timezones")
          TimeZoneMenu
          break;;
        "Super User Setup")
          PasswordSetup
          break;;
        "Locales")
#          echo -e "${NORMAL_BOLD}${RESET_COLOR}!"
          LocalesFunction
          break;;
        "Network Management")
          echo -e "${NORMAL_BOLD}WIP${RESET_COLOR}!"

          break;;
        "GRUB")
          echo -e "${NORMAL_BOLD}WIP${RESET_COLOR}!"

          break;;
        "Users Setup")
          echo -e "${NORMAL_BOLD}WIP${RESET_COLOR}!"

          break;;
        "")
          echo -e "${NORMAL_BOLD}WIP${RESET_COLOR}!"

          break;;
        "Exit Menu")
          # Confirm action
          echo -e "
            Are you sure you want to continue with these settings?
          "
          NoOrYes exitMenu
          break;;
        *)
          echo -e "Invalid Option. Try again."
          continue;;
      esac
    done
    # exit
    if [[ "$exitMenu" == "y" ]]; then
      echo -e "Exiting AutoMenu...!"
#      export comeBackToConfigMenu=false;
      ConfigMenuFlag=false
    fi

  done


}

# Function to set default options
function DefaultOptions(){
  #
  if [[ "$EFI" == "0" ]]; then
    export EFI_M="512MiB"
    export EFI_PART_NUM="1"
    export EFI_PART="${LINUX_PARTITION}${EFI_PART_NUM}"
    export SWAP_PART_NUM="2"
    export ROOT_PART_NUM="3"
  elif [[ "$EFI" == "1" ]]; then
    EFI_M="0MiB"
    export SWAP_PART_NUM="1"
    export ROOT_PART_NUM="2"
  fi
  export SWAP_M="1GiB"
  export ROOT_M="-"
  export SWAP_PART="${LINUX_PARTITION}${SWAP_PART_NUM}"
  export ROOT_PART="${LINUX_PARTITION}${ROOT_PART_NUM}"
  export NUM_PART="1"
  export comeBackToAutoMenu=false
  export MirrorArray="default"
  export Region="Etc"
  export City="UTC"
  export langVar="en_US.UTF-8"
  export INSTALL_GUI="n"
}

# export options and variables
function ExportOptions(){
    export EFI_M
    export SWAP_M
    export ROOT_M
    export EFI_PART_NUM
    export SWAP_PART_NUM
    export ROOT_PART_NUM
    export EFI_PART
    export SWAP_PART
    export ROOT_PART
    export NUM_PART
    export Region
    export City
    export MirrorArray
}
# display variables for running the program
function DisplayVariables(){
  # displays the various variables/options that will be used to complete the installation of arch linux
  echo -e " Your Options are:
  Installation type = ${INSTALL_TYPE}
  Installation block = ${LINUX_PARTITION}
  Available Memory = ${LINUX_PARTITION_M}
  EFI Memory= ${EFI_M}
  SWAP Memory= ${SWAP_M}

...
  "
}