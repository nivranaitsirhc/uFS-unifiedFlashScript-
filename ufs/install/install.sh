#!/sbin/sh
#	
#	uniFlashScript
#
#	CodRLabworks
#	CodRCA : Christian Arvin
#

#	! Note This code is sourced at installer.sh init          !
#   ! Please be careful in scripting outside the functions    !
#   ! it will probably break the script.                      !

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
# This function is called after the intaller.sh has run with 
# its own sub shell.
install_post() {
	# ! DO NOT REMOVE THE RETURN CODE !
	return 0
}
