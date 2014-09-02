mpduser="mpduser"

function pac_man {
	# Install all given packages via pacman
	pacman -Sy --noconfirm --quiet $@
}

## Dialog Functions ##
function message_box {
	dialog --title "$1" --msgbox "$2" 0 0
}

function ask_box {
    declare -n result=$3
	dialog --title "$1" --yesno "$2" 0 0
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
	result=$(dialog --stdout --title "$1" --radiolist "$2" 0 0 0 $3)
	result_code=$?
}
