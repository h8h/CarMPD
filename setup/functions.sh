declare -r MPD_USER="mpduser"
declare -r WORKING_DIR=`pwd`
declare -r CAR_MPD="CarMPD"
declare -r CONFIG_FOLDER="/home/$MPD_USER/.config/CarMPD"
declare -r INSTALLATION_LOG_FILE="/home/$MPD_USER/CarMPD_install.log"

function as_user {
    su -c "$@" $MPD_USER
}

function pac_man {
    # Install all given packages via pacman
    pacman -S --needed --noconfirm --quiet $@
}

function message_box {
    ## Dialog Functions ##
    dialog --backtitle "$CAR_MPD" --title "$1" --msgbox "$2" 0 0
}

function ask_box {
    declare -n result=$3
    dialog --backtitle "$CAR_MPD" --title "$1" --yesno "$2" 0 0
    result=$?
}

function input_box {
    # input_box "title" "prompt" "defaultvalue" VARIABLE
    # The user's input will be stored in the variable VARIABLE.
    # The exit code from dialog will be stored in VARIABLE_EXITCODE.
    declare -n result=$4
    declare -n result_code=$4_EXITCODE
    result=$(dialog --stdout --title "$1" --inputbox "$2" 0 0 "$3")
    result_code=$?
}

function input_radio {
    # input_menu "title" "prompt" "tag item tag item" VARIABLE
    # The user's input will be stored in the variable VARIABLE.
    # The exit code from dialog will be stored in VARIABLE_EXITCODE.
    declare -n result=$4
    declare -n result_code=$4_EXITCODE
    result=$(dialog --backtitle "$CAR_MPD" --title "$1" --stdout --radiolist "$2" 0 0 0 $3)
    result_code=$?
}

function get_supported_devices {
    # get_supported_devs VARIABLE
    # The AP-supported wireless network devices will be stored in the variable VARIABLE
    declare -n SUPPORTED_DEVS=$1

    # Get all wireless network devices
    NET_DEVS=`iw dev | sed -n "s/^\t*Interface[[:space:]]\(w.*\)/\1/p"`
    
    for DEV in `echo $NET_DEVS`; do

        # Get the wireless phy id
        WIPHY=`iw $DEV info | sed -n "s/^\t*wiphy[[:space:]]\([0-9]*\)$/\1/p"`

        # Use this wireless phy id to ask kindly for the AP Support
        HAS_AP_SUPPORT=`iw phy\#$WIPHY info | grep "\* AP$"`

        # Generates the radio list
        # key description flag
        # Device - off\
        # Device2 - off\ ...
        # TODO: replace description (-) with the device vendor name
        if [ -n "$HAS_AP_SUPPORT" ]; then
            SUPPORTED_DEVS="$SUPPORTED_DEVS$DEV - off\\ "
        fi

    done
}

function get_systemd_status {
    # get_systemd_status VARIABLE
    # Checks the VARIABLE systemd status and informs the user whether the process is running
    IS_RUNNING=`systemctl status $1 | grep "active (running)"`

    if [ -z "$IS_RUNNING" ]; then
        message_box "$1 - Failed" \
    "\nSomething went wrong :("
        systemctl status $1
        exit
    else
        message_box "$1 - Success" \
        "$1 is running, now we can go on"
    fi
}

function log_exec {
    "$@" > >(tee -a $INSTALLATION_LOG_FILE.info) 2> >(tee -a $INSTALLATION_LOG_FILE.err >&2)
}

function begin_section {
    OUT="--------- BEGIN $1 installation process ---------"
    echo $OUT >> $INSTALLATION_LOG_FILE.info
    echo $OUT >> $INSTALLATION_LOG_FILE.err
}

function end_section {
    OUT="--------- END   $1 installation process ---------"
    echo $OUT >> $INSTALLATION_LOG_FILE.info
    echo $OUT >> $INSTALLATION_LOG_FILE.err
}
