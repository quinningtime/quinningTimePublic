#!/bin/bash

# read data from managed plist file

#########Variables set here#################

pathToPlist="/Library/Managed Preferences/com.userinfo.plist"
plistKeyToRead=email

###############This section contains various error checks and data validations#########

#checking to see if plist is present on the computer
if [[ -f $pathToPlist ]]; then
	echo "com.userinfo.plist exists in the expected location proceeding with reading $plistKeyToRead data"
	userEmail=$(defaults read "$pathToPlist" $plistKeyToRead)
		else
	echo "com.userinfo.plist not present, aborting script"
	exit 1
fi	

#checking to see if the read value is blank or not
if [[ $userEmail == "" ]]; then
	echo "plist file present but $userEmail is empty. Make sure the computer record for this computer has a value entered into the email field in its inventory record under User and Location then repush the Assigned Employee Information configuration profile. Existing script now, no further action will be taken"
	exit 1
		else
	echo "userEmail variable set with value $userEmail"
fi

	
############### rest of the script that is going to use data scraped from the userinfo plists below here#########
