##!/bin/bash


############## Name ################
# userApprovedMDMPrompt.sh


############# About this Program ###########
##Written by quinningtime using some code originally found a script written by rtrouton. Original script can be found here: https://github.com/quinningtime/rtrouton_scripts/tree/master/rtrouton_scripts/detect_user-approved_mdm


########### Description ##############
# This script will evalute if the installed jamf pro MDM profile is user approved, if the MDM status comes back as not user approved it then uses jamf helper to generate a pop-up message to prompt the user to approve the MDM profile. The Pop up message will give the user the choice to approve the MDM later or right away. If they choose to proceed with approveding the MDM profile the Self Service Store will be launched to display instructions for how to approve the MDM profile. This function relies on enabling the "Enable User Approved MDM Profile Notification" option on in the macOS Self Service settings on Jamf Pro.  If the MDM has already been approved then a jamf recon is run to update inventory. 


######## Requirements ###############
# 1. This script is designed to be exclusively deployed with Jamf Pro
# 2. The "Enable User Approved MDM Profile Notification" option on in the macOS Self Service settings on Jamf Pro must be selected
# 3. Custom branding icon for the pop-up message must already be present at a known file path on the scoped computers. 
# 4. Variables defined using read in parameters 4-8 in jamf pro



####### Variables Defined Here ##########


#Enter the path to a custom icon file to be used in the popup message. ex: "/Library/Application Support/ACMECorp/acmeCorpIcon.png" in the Jamf Pro Parameter 4 field 
#USES PARAMETER 4 FIELD IN JAMF PRO
customIconFile="$4"

#Body Text to display in popup message. Ex. "Hi Team Member, ACME IT needs you to approve the Jamf MDM profile. Please click 'Lets Do It!' below for instructions. This notification will appear daily until this is completed."
#USES PARAMETER 5 FIELD IN JAMF PRO
messageBodyText="$5"

#Button Text for the button that opens the jamf pro Self Service app to show user instructions for how to approve the MDM profile ex. "Lets Do It!"
#USES PARAMETER 6 FIELD IN JAMF PRO
proceedButtonText="$6"

#button text for the button that lets user close the prompt with no further action ex. "Later"
#USES PARAMETER 7 FIELD IN JAMF PRO
cancelButtonText="$7"

#Self Service Application Name Ex. "ACME Corp Self Service.app"
#USES PARAMETER 8 FIELD IN JAMF PRO
selfServiceName="$8"





########## Script Code Here #############


##########################################All Code in this section written by rtrouton#############################################

# Script which reports if user-approved mobile device management
# is enabled on a particular Mac.

UAMDMCheck(){

# This function checks if a Mac has user-approved MDM enabled.
# If the UAMDMStatus variable returns "User Approved", then the
# following status is returned:
#
# Yes
#
# If anything else is returned, the following status is
# returned:
#
# No

UAMDMStatus=$(profiles status -type enrollment | grep -o "User Approved")

if [[ "$UAMDMStatus" = "User Approved" ]]; then
   result="Yes"
else
   result="No"
fi
}

# Check to see if the OS version of the Mac includes a version of the profiles tool which
# can report on user-approved MDM. If the OS check passes, run the UAMDMCheck function.

osvers_major=$(/usr/bin/sw_vers -productVersion | awk -F. '{print $1}')
osvers_minor=$(/usr/bin/sw_vers -productVersion | awk -F. '{print $2}')
osvers_dot_version=$(/usr/bin/sw_vers -productVersion | awk -F. '{print $3}')

if [[ ${osvers_major} -eq 10 ]] && [[ ${osvers_minor} -ge 14 ]]; then
	UAMDMCheck
elif [[ ${osvers_major} -eq 10 ]] && [[ ${osvers_minor} -eq 13 ]] && [[ ${osvers_dot_version} -ge 4 ]]; then
	UAMDMCheck
else

# If the OS check did not pass, the script sets the following string for the "result" value:
#
# "Unable To User-Approved MDM On", followed by the OS version. (no quotes)

	result="Unable To Detect User-Approved MDM On $(/usr/bin/sw_vers -productVersion)"
fi

##################### All code below was written by quinningtime ########################################

#test expression to evalute if rtrouton's user approved MDM script code detected if the MDM was approved or not. If the MDM profile is not approve a popup message will be displayed using the jamf helper utility 
if [[ $result == "No" ]]; then
	echo "MDM not user approved, running notification policy"
	#using the jamf help utility to generate a popup message
	userResponse=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -windowPosition ur -icon "$customIconFile" -title "Action Needed" -description "$messageBodyText" -alignDescription left -button1 "$proceedButtonText" -button2 "$cancelButtonText" -defaultButton 1 -cancelButton 1 -lockHUD)
	#evaluate users response to pop-up message if they choose button1 the self service application will launch
	if [[ $userResponse = 2 ]]; then
		echo "user chose to approve the MDM later"
		exit 0
			else
		echo "users wants to proceed with approving MDM"
		open "/Applications/$selfServiceName"
	fi	
	else		
	echo "MDM user approved, running inventory update"
	#invokes the jamf binery to run an inventory update
	jamf recon
	exit 0
fi

exit 0
