#!/bin/bash
#set -x


#rotate activation code script


#DESCRIPTION:
#This script was written by Quinn Schreiner and can be used to update the Activation Code on multiple Jamf Pro servers with the same Activation Code at once. Jamf MSP partners are required to use the same Activation Code on multiple Jamf Pro instances and update that code on a monthly or annual cadence so this script will save significant time. 
#
#This script used the jamf classic API
#
#
#VERION HISTORY:
#11/03/2020 - 1.0 Initial Version Created and tested
#
#
#
#HOW TO USE:
#1. Open the script in a script editor like coderunner.app or bbedit.app. Update the following variables between the quotes. In the jamfProURLArray[1] variable you may enter as many Jamf Pro server URLs as you want separated by spaces. 
#
#Line 40: newActivationCode=“NEW ACTIVATION CODE HERE”
#
#Line 43: jamfProURLArray[1]=“https://PamfProServerUrl1.com https://PamfProServerUrl2.com https://PamfProServerUrl3.com” 
#
#Line 49: apiUser=“Jamf Pro administrator username”
#
#Line 50: apiPass=“Jamf Pro administrator password”
#
#2. Run the script
#3. Look for any errors in the output of the script and manually check the corresponding Jamf Pro servers to ensure activation code updated ok on servers that produce an error. 
#4. Find the Activation Code Update Log.txt in /Users/Shared/ for your records.  



#########################################################
############ Variables to Define ########################
#########################################################

newActivationCode=""

#Enter each jamf pro server whose activation code you want to update between the quotes seperated by ONE space eg "https://PamfProServerUrl1.com https://PamfProServerUrl2.com https://PamfProServerUrl3.com" You can enter in as many server as you like this way. 
jamfProURLArray[1]="" 

#########################################################
###### Jamf User Credentials Entered Here ###############

#this account must exist and use the same defined password on all jamf pro servers defined in the jamfProURLArray variable above
apiUser=""
apiPass=""



##########Use API calls to: ######################
# 1. Get the current activation code for each jamf pro server for reference 
# 2. Update each jamf pro server with the new activation code 
# 3. Get the current activation code for each jamf pro server again to error check
# 4. Check to see if the current activation code on each jamf pro now matches the new activation code entered into this script
# 5. Output the date and time, the old activation code and the new Actication code for each server to a log file and the script log



for jamfProURL in ${jamfProURLArray[@]}
do

#Step 1: API Call to get current activation code for reference
oldActivationCode=$(curl -sku $apiUser:$apiPass "$jamfProURL/JSSResource/activationcode" -H "accept: text/xml" -X GET | xmllint --xpath '/activation_code/code/text()' - )

#Step 2: API Call to update activation code to new code
curl -sku $apiUser:$apiPass "$jamfProURL/JSSResource/activationcode" -H "content-type: text/xml"  -X PUT -d "<activation_code><code>$newActivationCode</code></activation_code>"

#pause script for 2 seconds to chance of false error during error checking steps
sleep 2

#Step 3: API Call to get the currently set Activation Code again after updating above to error check. 
activationCodeCheck=$(curl -sku $apiUser:$apiPass -X GET "$jamfProURL/JSSResource/activationcode" -H "accept: text/xml" | xmllint --xpath '/activation_code/code/text()' - )

#Step 4: Error check to make sure activation code changed to the new code properly
if [[ $activationCodeCheck == $newActivationCode ]]; then
	echo "There was no issues updating the code for server $jamfProURL"
	else
	echo "THERE WAS AN ISSUE UPDATIG THE CODE ON $jamfProURL, please manually check this server to make sure it is setup with the new activation code"
fi


#Step 5: Echo code to output with current date and time
echo " `date` $jamfProURL activation code was changed from $oldActivationCode to $activationCodeCheck"

#Step 5: Echo output with current date and time to a Activation Code Update Log.txt text file at /Users/Shared/
echo " `date` $jamfProURL activation code was changed from $oldActivationCode to $activationCodeCheck" >> /Users/Shared/Activation\ Code\ Update\ Log.txt 


done


