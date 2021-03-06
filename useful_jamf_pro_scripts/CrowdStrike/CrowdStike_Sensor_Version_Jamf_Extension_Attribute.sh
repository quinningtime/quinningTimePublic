#!/bin/bash


#CrowdStrike Sensor Version Jamf Extension Attribute 1.0
#Written by Quinn Schreiner
#Last Updated on 1/28/2021

#Version 1.0 - Intial Release


#About this program
#This script is designed to be used as an extension attribute in jamf and will determine the version of the currently installed version of the CrowdStrike Sensor. 
#If the CrowdStrike sensor is not installed at all it will also report this. Supports  versions 5.x and above. 



#Section 1: Determine if the CrowdStrike sensor is installed at all

if [[ ! -e "/Applications/Falcon.app/Contents/Resources/falconctl" ]] && [[ ! -f "/Library/CS/" ]]; then
	echo "CrowdStrike Sensor Not Installed"
	falconSensorVersion="Sensor Not Installed"
else
	echo "Some version of the CrowdStrike sensor is installed. Will move on to determine which version installed"
fi


#Section 2: Determine the version of the installed sensor based on installed version

#Sensor Versions 6.11 and above
if [[ -e  "/Applications/Falcon.app/Contents/Resources/falconctl" ]]; then
	falconSensorVersion=$(/Applications/Falcon.app/Contents/Resources/falconctl stats | awk '/version/{print$NF}')
fi	

#Sensor Versions 5.36 to 6.10
if [[ -e  "/Library/CS/falconctl" ]]; then
	falconSensorVersion=$(/Library/CS/falconctl stats | awk '/version/{print$NF}')
fi	


#Sensor Versions 5.0 to 5.35	
if [[ -e "/Library/CS/" ]] && [[ ! -e "/Library/CS/falconctl" ]]; then
	falconSensorVersion=$(sysctl cs | grep cs.version | awk -F: '{print $2}')	
fi

#Section 3: Output result in jamf readible syntax for an extension attribute

echo "<result>$falconSensorVersion</result>"

