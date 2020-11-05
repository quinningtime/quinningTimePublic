ActivationCodeRotator Script READ ME:

DESCRIPTION:
This script was written by quinningtime and can be used to update the Activation Code on multiple Jamf Pro servers with the same Activation Code at once. Jamf MSP partners are required to use the same Activation Code on multiple Jamf Pro instances and update that code on a monthly or annual cadence so this script will save significant time. 

This script used the jamf classic API


VERION HISTORY:
11/03/2020 - 1.0 Initial Version Created and tested



HOW TO USE:
1. Open the script in a script editor like coderunner.app or bbedit.app. Update the following variables between the quotes. In the jamfProURLArray[1] variable you may enter as many Jamf Pro server URLs as you want separated by spaces. 

Line 12: newActivationCode=“NEW ACTIVATION CODE HERE”

Line 15: jamfProURLArray[1]=“https://PamfProServerUrl1.com https://PamfProServerUrl2.com https://PamfProServerUrl3.com” 

Line 21: apiUser=“Jamf Pro administrator username”

Line 22: apiPass=“Jamf Pro administrator password”

2. Run the script
3. Look for any errors in the output of the script and manually check the corresponding Jamf Pro servers to ensure activation code updated ok on servers that produce an error. 
4. Find the Activation Code Update Log.txt in /Users/Shared/ for your records.  


