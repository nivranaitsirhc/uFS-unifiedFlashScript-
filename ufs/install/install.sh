#!/sbin/sh
#	
#	uniFlashScript
#
#	CodRLabworks
#	CodRCA : Christian Arvin
#

#	! Note This code is sourced by init.sh and used by        !
#   ! installer.sh at runtime.                                !
#	! Please be careful in scripting outside the functions    !
#	! it will probably break the script.                      !

##############################################################
# VARIABLE DEF_INIT                                                       #
##############################################################
# Define your variables here.
# It's good practice to start your variables with double
# __ (underscore) to prevent conflict with local variables.
__SAMPLE_VARIABLE=0;

##############################################################
# INIT                                                       #
##############################################################
#
install_init(){
	# This will be displayed as your header from TMHX to TMHX
	TMH1="Main config"
	TMH2="*******************************"
	TMH3="        uniFlashScript"
	TMH4="*******************************"
	TMH5="app: $uFS_name"
	TMH6="src: $uFS_src_ver"
	TMH7="rev: $uFS_rev_ver"
	TMH8="#"
	# ! DO NOT REMOVE THE RETURN CODE !
	return 0
}

###############################################################
# MAIN                                                        #
###############################################################
# Main Function called after the zip extract of user defined
# folders and install.
install_main() {
	# ! DO NOT REMOVE THE RETURN CODE !
	return 0
}

###############################################################
# POST SCRIPTS                                                #
###############################################################
# This function is called after the installer.sh has run with 
# its own sub shell.
install_post() {
	# ! DO NOT REMOVE THE RETURN CODE !
	return 0
}

##############################################################
# YOUR FUNCTIONS                                             #
##############################################################
# Define your functions here.
# It's good practice that your functions will start with a
# character then followed by an _ (underscore) to prevent
# conflict with local defined functions.
A_SAMPLE_FUNCTION(){
	return 0;
}