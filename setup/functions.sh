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
