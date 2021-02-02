#!/bin/bash
​
# Written by quinningtime on 6/22/2020 
​
##########ABOUT THIS PROGRAM###############
#this script will check to see if cisco umbrella is active on the mac and then give the user a choice to change it from enabled to disabled or from disabled to enabled. After the user makes their choice the script checks the umbrella status again and lets the user know. 
​
​
#Checks to see if umbrelaa is active
umbrellaRunningCheck=$(launchctl list | grep com.opendns.osx.RoamingClientConfigUpdater | awk '{print $3}')
​
echo $umbrellaRunningCheck
​
#Displays popup message to user informating them of the current umbrella status and offering to enable it if its disable or disable it if its enabled
​
if [[ $umbrellaRunningCheck == com.opendns.osx.RoamingClientConfigUpdater ]]; then
	echo "umbrella is running"
	userChoice=$(osascript -e 'display dialog "Cisco Umbrella is currently ACTIVE. Would you like to disable it?" buttons {"Disable Umbrella", "Do Nothing"} default button 1')
	else
	echo "Umbrella is not running"
	userChoice=$(osascript -e 'display dialog "Cisco Umbrella is currently INACTIVE. Would you like to enable it?" buttons {"Enable Umbrella", "Do Nothing"} default button 1')
fi
​
echo $userChoice
​
#Enables umbrella if the user chose to enable it
​
if [[ $userChoice == "button returned:Enable Umbrella" ]]; then
	echo "Enabling Umbrella" 
	/bin/launchctl load /Library/LaunchDaemons/com.opendns.osx.RoamingClientConfigUpdater.plist 
		else
	echo "User chose to do nothing"
fi
​
#Disabled Umbrella if the user chose to disable it 
​
if [[ $userChoice == "button returned:Disable Umbrella" ]]; then
	echo "Disabling Umbrella" 
	/bin/launchctl unload /Library/LaunchDaemons/com.opendns.osx.RoamingClientConfigUpdater.plist 
		else
	echo "User chose to do nothing"
fi
​
​
#Checks umbrella status again to give user confirmation the change occurred. 
​
#Checks the umbrella status again after short delay
​
​
​
umbrellaRunningCheckConfirmation=$(launchctl list | grep com.opendns.osx.RoamingClientConfigUpdater | awk '{print $3}')
​
echo $umbrellaRunningCheckConfirmation
​
#Displays a message to the user of the current status 
​
​
if [[ $umbrellaRunningCheckConfirmation == com.opendns.osx.RoamingClientConfigUpdater ]]; then
	echo "umbrella is running"
	userChoiceConfirmation=$(osascript -e 'display dialog "Cisco Umbrella is now ACTIVE" buttons {"Ok"} default button 1')
		else
	echo "Umbrella is not running"
	userChoiceConfirmation=$(osascript -e 'display dialog "Cisco Umbrella is now INACTIVE" buttons {"Ok"} default button 1')
fi
