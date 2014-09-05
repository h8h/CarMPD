declare -r MPD_USER="mpduser"
declare -r WORKING_DIR=`pwd`
declare -r CAR_MPD="CarMPD"
declare -r CONFIG_FOLDER="/home/$MPD_USER/.config/CarMPD"
declare -r INSTALLATION_LOG_FILE="/home/$MPD_USER/CarMPD_install.log"


function pac_man {
    # Install all given packages via pacman
    pacman -S --needed --noconfirm --quiet $@
}

function message_box {
    # message_box "title" "prompt"
    dialog --backtitle "$CAR_MPD" --title "$1" --msgbox "$2" 0 0
}

function ask_box {
    # as_box "title" "prompt" VARIABLE
    # The user's decision will be stored in variable VARIABLE.
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
    result=$(dialog --backtitle "$CAR_MPD" --stdout --title "$1" --inputbox "$2" 0 0 "$3")
    result_code=$?
}

function input_radio {
    # input_radio "title" "prompt" "key description flag\ key description flag" VARIABLE
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

function as_user {
    # as_user "process"
    # The given process will be executed with the default mpd user permissions
    su -c "$@" $MPD_USER
}

function check_status {
    # check_status "service name"
    # Checks the systemd status of the given service and informs the user whether the process is running
    IS_RUNNING=`systemctl status $1 | grep "active (running)"`

    if [ -z "$IS_RUNNING" ]; then
        message_box "$1 - Failed" \
    "\nSomething went wrong :(\n
Take a look at the log files $INSTALLATION_LOG_FILE.info or $INSTALLATION_LOG_FILE.err"
        exit
    else
        message_box "$1 - Success" \
        "$1 is running, now we can go on"
    fi
}

function log_exec {
    # log_exec "process"
    # Executes the process and writes its output to 
    # the stdout log file with appendix .info and to the stderr log file with appendix .err
    "$@" > >(tee -a $INSTALLATION_LOG_FILE.info) 2> >(tee -a $INSTALLATION_LOG_FILE.err >&2)
}

function begin_section {
    # begin_section "section name"
    # Starts a new section in the log files
    OUT="--------- BEGIN $1 installation process ---------"
    echo $OUT >> $INSTALLATION_LOG_FILE.info
    echo $OUT >> $INSTALLATION_LOG_FILE.err
}

function end_section {
    # end_section "section name" 
    # Closes a section named in the log files
    OUT="--------- END   $1 installation process ---------"
    echo $OUT >> $INSTALLATION_LOG_FILE.info
    echo $OUT >> $INSTALLATION_LOG_FILE.err
}
