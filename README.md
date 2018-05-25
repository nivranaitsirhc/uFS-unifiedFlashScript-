## uniFlashScript
**Unified Flash Script | FLASH INSTALLER**

**Description:**

This script creates a platform for simplified
flash script installation. It is intended for
users who doesn't want the hassle of creating
and coding the "update_binary".


## Features
- [x] Automated Install
	* extract and install files inside the system zip folder
	* set permissions
- [x] Pre-Space Calculation Checking
- [x] Addon Script Generation
- [x] Script Configurable Settings
- [x] Custom User script
- [ ] Revert Install

## Usage

 1. Anything inside the system folder will be automatically installed
 2. User Configuration **`install/*`**
	* **config**       - modify installer script behavior *refer to core/config/ufconfig* for the right settings
	* **install.sh**   - custom user script that will be loaded at runtime.
	* **installer.sh** - put your custom script here, <br />
	**Note. Main installer.sh will only load the configs and library then run this script if it exist inside the install folder**




<br /> <br />
**CodRLabworks** <br />
**CodR C.A | Christian Arvin** <br/>
**Contact:** <br />
*naitsirhc.uriel@gmail.com* <br />
