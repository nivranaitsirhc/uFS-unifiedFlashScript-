## uniFlashScript
**Unified Flash Script | FLASH INSTALLER**

**Description:**

This script creates a platform for simplified
flash script installation. It is intended for
users who doesn't want the hassle of creating
and coding the "update_binary".


## Features
- [x] Automated Install System Files
	* [x] extract and install files inside the system zip folder
	* [x] set proper permissions
- [x] Pre-Space Calculation Checking
- [x] Addon Script Generation
- [x] Script Configurable Settings
- [x] Custom User script
- [ ] Failsafe Revert Install

## Usage

 1. Anything inside the system folder will be automatically installed
 2. User Configuration **`install/*`**
	* **`config`**       - modify installer script behavior *refer to `/core/config/ufsconfig`* for the right settings
	* **`install.sh`**   - user script that will be used incoherence by the default `/core/installer.sh`.
	* **`installer.sh`** - user custom `installer.sh`, write your custom script here, <br />
	**Note. `init.sh` will load the configs and library then run this script if it exist inside the install folder**

## External Sources
This repo uses busybox binaries from busybox.net, maintained by [Denys Vlasenko](mailto:vda.linux@googlemail.com) under the [GNU GPLv2](https://busybox.net/license.html).<br> 
Check the [source](https://git.busybox.net/busybox).


<br /> <br />
**CodRLabworks** <br />
**CodR C.A | Christian Arvin** <br/>
**Contact: [Me](mailto:naitsirhc.uriel@gmail.com)**<br />
