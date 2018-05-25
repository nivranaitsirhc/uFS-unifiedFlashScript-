#!/sbin/sh
#
#	uniFlashScript
#
#	CodRLabworks
#	CodRCA : Christian Arvin
#
#
ver="9eac0e5"
# scenario this script (installer.sh) is called by update-binary
#
# EXPORTED VARIABLES from update-binary
# export COREDIR     /tmp/core
# export BINARIES    /tmp/core/bin
# export LIBS        /tmp/core/library
# export INSTALLER   /tmp/core/installer.sh
# export ZIP		 This zip file full path directory
# export OUTFD
#

# HEADER DEFAULT MESSAGE
TMH1="TEST"
TMH2="############################"
TMH3="      uniFlashScript        "
TMH4="############################"
TMH5="TEST"

# FUNCTIONS
# ___________________________________________________________________________________________________________ <- 110 char
#

ui_print(){
	echo -n -e "ui_print $1\n" >> /proc/self/fd/$OUTFD
	echo -n -e "ui_print\n"    >> /proc/self/fd/$OUTFD
	cold_log "$1"
}

cold_log() {
	TMP_LOG="${TMP_LOG}"$'\n'"COLD LOG $1"
	printf "$1\n"
}

alLog(){
	cold_log "$1"
}

cold_log=cold_log

# placeholder functions
install_init(){ $cold_log "I: place holder, install.sh was not loaded!"; return 0;}

install_main(){ $cold_log "I: place holder, install.sh was not loaded!"; return 0;}

install_post(){ $cold_log "I: place holder, install.sh was not loaded!"; return 0;}

abort () { ui_print "$1";exit 1; }

# PRE-INIT (P.I)
# ___________________________________________________________________________________________________________ <- 110 char
#

$cold_log "I: unified Flash Script - ver: $ver"

# PRINT ESSENTIAL DEF
$cold_log "I: listing update-binary variables
COREDIR   -> $COREDIR
BINARIES  -> $BINARIES
LIBS      -> $LIBS
INSTALLER -> $INSTALLER
ZIP       -> $ZIP
OUTFD     -> $OUTFD"

# CHECK FOR PROPER update_binary DEF.
ERR=0
[ ! -e "$COREDIR" ] && {
	ui_print "W: COREDIR is not properly defined"
	ERR=$((++ERR))
}

[ ! -e "$LIBS" ] && {
	ui_print "W: LIBS is not properly defined"
	ERR=$((++ERR))
}

[ ! -e "$ZIP" ] && {
	ui_print "W: ZIP is not properly defined"
	ERR=$((++ERR))
}

[ "$ERR" -gt "0" ] && {
	ui_print "E: update_binary did not properly define variables"
	exit $ERR
}

##### PRE-INIT load aslib script and other configs
# ------------------------------------------------------------------- <- 70 char
$cold_log "I: LOADING aslib"
ASLIB=$LIBS/aslib
[ -e "$ASLIB" ] && {
	(eval . $ASLIB) && . $ASLIB || { ui_print "E: ERROR $E_ANL: aslib is not loadable!"; abort $E_ANL; }
} || {
	ui_print "E: ERROR LOADING ASLIB"
	exit 1
}

# LOAD CONFIG/ERR_CODE
ER_CODE=$COREDIR/config/er_code
[ -e $ER_CODE ] && {
	$cold_log "I: LOADING $COREDIR/config/er_code"
	(eval . $ER_CODE) && eval . $ER_CODE || $cold_log "W: INTEGRITY ERROR: FAILED TO LOAD er_code"
} || {
	ui_print "INTEGRITY ERROR: FAILED TO LOAD er_code"
	exit 255
}

# LOAD CONFIG/UFSCONFIG
$cold_log "I: LOADING $COREDIR/config/ufsconfig"
UFSCONFIG=$COREDIR/config/ufsconfig
[ -e $UFSCONFIG ] & {
	(eval . $UFSCONFIG) && . $UFSCONFIG || $cold_log "W: INTEGRITY ERROR: FAILED TO LOAD ufsconfig"
} || {
	ui_print "INTEGRITY ERROR: MISSING ufsconfig"
	exit 254
}

# LOAD USER CONFIG
# unzip install
( unzip -o "$ZIP" "install/*" -d "$COREDIR" ) || $cold_log "E: FAILED TO UNZIP install"

# LOAD USER CONFIG
$cold_log "I: LOADING user config"
USERCONFIG=$COREDIR/install/config 
[ -e $USERCONFIG ] && {
	(eval . $USERCONFIG) && . $USERCONFIG || $cold_log "W: FAILED TO LOAD user config"
} || {
	$cold_log "W: user config does not exist!"
}

# LOAD USER INSTALL
$cold_log "I: LOADING user install.sh"
USER_INSTALLSH=$COREDIR/install/install.sh
[ -e $USER_INSTALLSH ] && {
	(eval . $USER_INSTALLSH) && . $USER_INSTALLSH || $cold_log "W: FAILED TO LOAD user install.sh"
} || {
	$cold_log "W: user install.sh does not exist!"
}

# SETUP ASLIB
alLSet type 	$aslib_log_type        # FLASH TYPE
alLSet level	$aslib_log_level       # SET LEVEL 3
alLSet enable	$aslib_log_enabled     # ENABLE LOGGING
alLInit                                # INIT ASLIB LOGGING

# DEF_CHECK
loc_of_config=$UFSCONFIG
loc_of_aslib=$ASLIB
def_config_check || ui_print "W: Misconfigs Detetected! check logs"


# TURN-OVER TO USER INSTALLER.SH IF PRESENT IN INSTALL FOLDER
USER_INSTALLERSH=$COREDIR/install/installer.sh
[ -e $USER_INSTALLERSH ] && {
	$BINARIES/ash  $USER_INSTALLERSH "$@" && \
	exit "$?"
}


# INSTALL.SH
#############################
# LOAD INSTALL_INIT			#
#############################
alLog "I: RUNNING install_init"
install_init || alLog "E: install_init exited with error $?"

# print header message
# ----------------------------------------------- <- 50 char
#
is_enabled print_header_enabled && {
	print_header;
} || alLog "I: print_header disabled"


# MOUNT USER SELECTED MOUNTPOINTS
[ -n "$mountpoints" ] && {
	ui_print " - Mounting $mountpoints"
	
	for MOUNT in $mountpoints; do
		remount_mountpoint /$MOUNT rw
	done
} || alLog "I: No defined mountpoints in user config"

##### PRE-INIT ASLIB VERSION
# ------------------------------------------------------------------- <- 70 char

# ASLIB VERSION CHECK
[ "$aslib_version" -lt "$aslib_req" ] && {
	ui_print "E: ASLIB version mismatch"
	ui_print "I: Loaded   :$aslib_version"
	ui_print "I: Required :$aslib_req"
	abort $E_AVM
}

##### PRE-INIT SDK & DEVICE CHECK
# ------------------------------------------------------------------- <- 70 char

# SDK & DEVICE CHECK
cur_device=$(get_prop ro.product.device);				# GET DEVICE ID
cur_android_version=$(get_prop ro.build.version.sdk);	# GET DEVICE SDK

# DEVICE MATCHING DEVICE
[[ ! -z "$req_device" && "$cur_device" != "$req_device" ]] && {
	ui_print "W: Not a $req_device device device."
	exit 1
}

# DEVICE MATCHING SDK
[ "$req_force" -gt "0" ] && {
	[ -z "$cur_android_version" ] && {
		ui_print "E: Unable to determine SDK"
		abort $E_UAS
	}
	case $req_force in
		1) 	# ENFORCING
			if [ "$cur_android_version" != "$req_android_sdk" ];then
				ui_print "W: Android SDK Mismatch"
				ui_print "I: Current  : $cur_android_version"
				ui_print "I: Required : $req_android_sdk"
				abort $E_SDM
			fi
		;;
		2)	# LESS THAN EQUAL
			if [ "$cur_android_version" -gt "$req_android_sdk" ];then
				ui_print "W: Android SDK Mismatch"
				ui_print "I: Current   : $cur_android_version"
				ui_print "I: Required <= $req_android_sdk"
				abort $E_SDM
			fi
		;;
		3) # GREATER THAN EQUAL
			if [ "$cur_android_version" -lt "$req_android_sdk" ];then
				ui_print "W: Android SDK Mismatch"
				ui_print "I: Current   : $cur_android_version"
				ui_print "I: Required >= $req_android_sdk"
				abort $E_SDM
			fi
		;;
		*) alLog "W: Unknown req_force value $req_force"
		;;
	esac
}

# INIT
# ___________________________________________________________________________________________________________ <- 110 char
#

# PRE_CHECK
# ----------------------------------------------- <- 50 char
#

pre_check;

# ##########################################################################################
#  EXTRACT SYSTEM & USER FOLDERS
# ##########################################################################################

# EXTRACT SYSTEM FOLDER & USER FOLDERS
is_enabled extract_system || is_enabled extract_folder && {
	ui_print " - Extracting"
}

set_progress 0.10
# AS_EXTRACT
# ----------------------------------------------- <- 50 char
#
is_enabled extract_system && {
	asExtract
}

set_progress 0.25
is_enabled extract_folder && {
	alLog "I: extracting user folders.."
	[ ! -z "$user_folders" ] && {
		for FOLDERS in $user_folders; do
			alLog "I: extracting -> $FOLDER"
			extract_zip "$ZIP" "$FOLDER/*" "$SOURCEFS"
		done
	} || alLog "W: no defined user folders"
}


set_progress 0.30
# CREATE_WIPELIST
# ----------------------------------------------- <- 50 char
#

create_wipelist;

# ##########################################################################################
#  CALCULTE SYSTEM SPACE
# ##########################################################################################

##### INIT CALCULTE SOURCEFS VS SYSTEM FREE plus wipe_list
# ------------------------------------------------------------------- <- 70 char
#
set_progress 0.37
is_enabled calculatespace && {
	ui_print " - Calculating Space"
	wipe_size=0;tmp_size=0;install_size=0;wipe_file_count=0;


	alLog "I: Calculating system INSTALL_SIZE"
	install_size=$(du -ck $SOURCESYS | tail -n 1 | awk '{ print $1 }')

	alLog "I: Calculating system WIPE_SIZE"
	for TARGET in $wipe_list; do
		[ -e /system/$TARGET ] && {
			tmp_size=$(du -ck /system/$TARGET | tail -n 1 | awk '{ print $1 }')
			wipe_size=$(($tmp_size+$wipe_size))
			wipe_file_count=$((++wipe_file_count))
			alLog "D: SIZE:$(printf "%-8s %s\n" $tmp_size "<- /system/$TARGET")"
		}
	done

	alLog "I: Total system install size -> $install_size"
	alLog "I: Total system wipe size    -> $wipe_size"
	alLog "I: Total system free size    -> $pc_free_sys"

	[ "$install_size" -gt "$(($pc_free_sys + $wipe_size))" ] && {
		ui_print "E: Install size is to large for free system space."
		exit 1
	} || alLog "I: Great! system has enough space for installation."
}

# ##########################################################################################
#  WIPE FILES IN WIPE LIST
# ##########################################################################################

set_progress 0.54
# AS_WIPELIST
# ----------------------------------------------- <- 50 char
#

is_enabled exec_wipe_list && {
	ui_print " - Removing Unwanted"
	asWipelist;
}


# INSTALLATION
# ___________________________________________________________________________________________________________ <- 110 char
#

# ##########################################################################################
#  INSTALL SYSTEM FILES FROM SYSTEM FOLDERS
# ##########################################################################################

set_progress 0.61
# AS_INSTALL
# ----------------------------------------------- <- 50 char
#
[ "$install_system" == "1" ] && {
	ui_print " - Installing System"
	asInstall;
}


# POST-INSTALLATION
# ___________________________________________________________________________________________________________ <- 110 char
#

set_progress 0.69
# INSTALL.SH
#############################
# LOAD INSTALL_MAIN			#
#############################
alLog "I: RUNNING install_main"
install_main || alLog "E: install_main exited with error $?"


# ##########################################################################################
#  CREATE AND CREATE ADDON.D SCRIPT
# ##########################################################################################

set_progress 0.72
# AS_ADDON
# ----------------------------------------------- <- 50 char
#
is_enabled create_addon_d && {
	ui_print " - Creating Addon Script"
	asAddon $addon_delay
}

# CLEAN-UP
# ___________________________________________________________________________________________________________ <- 110 char
#

set_progress 0.80
# CLEAN FILES
# ----------------------------------------------- <- 50 char
#
( is_enabled extract_system || is_enabled extract_folder ) && {
	ui_print " - Cleaning up"
	rm -rf "$SOURCESYS" || alLog "W: Errors were found during $SOURCESYS cleaning $?"
	[ -e "$SOURCESYS" ] && {
		alLog "W: Failed to remove $SOURCESYS"
		alLog "I: Manually remove it on reboot"
	}
}

set_progress 0.94
# UNMOUNTING SYSTEM
# ----------------------------------------------- <- 50 char
is_mounted /system && {
	ui_print " - Un-mounting system"
	umount /system || alLog "W: Errors were found during system unmount $?"
}
set_progress 1.0
# DONE
# ----------------------------------------------- <- 50 char
ui_print " - Done"
sleep 3

# POST-SCRIPT
# ___________________________________________________________________________________________________________ <- 110 char
#

# INSTALL.SH
#############################
# LOAD INSTALL_POST			#
#############################
alLog "I: RUNNING install_post"
install_post || alLog "W: install_post exited with error $?"


# FLUSH COLD LOGS
flush_logs;