#!/bin/bash
#set -x


#Create new jamf pro user accounts on multiple jamfs using the jamf classic API


#DESCRIPTION:
#This script was written by quinningtime and can be used create a standard jamf pro user account on multiple jamfs at once where something like LDAP login isn't an option. Note the jamf API documentation says you cannot define a new standard user account password with the API so this script will not attempt to do so though it does seem to work in testing on a jamf server running 10.26.1. As is the script will create the account with no password set so you wont be able to log in with the account from the stand jamf pro login screen. This solution is ideally used with an SSO like OneLogin or Okta configured on the jamf to just provision the accounts on jamf pro and then users use their SSO to log in which does not require a password to be set for the jamf account. 
#
#LICENCE: Free for non-commercial use if the headers are kept in tact. 
#
#
#VERION HISTORY:
#3/05/2021 - 1.0 Initial Version Created and tested
#
#
#########################################################
################ HOW TO USE: ############################
#########################################################

#1. Open the script in a script editor like coderunner.app or bbedit.app. Update the following variables between the quotes. In the jamfProURLArray[1] variable you may enter as many Jamf Pro server URLs as you want separated by spaces. 
#
#Line 77: newUserUserName=“USERNAME OF NEW USER HERE”
#
#Line 80: newUserFullName=“FULL NAME OF NEW USER” 
#
#Line 83: newUserEmail="EMAIL ADDRESS OF NEW USER" 
#
#Line 86: newUserPrivilegeSet="PRIVILEDGE SET USER SHOULD HAVE"
#
#Line 89: forceUserToChangePassword="true or false all lowercase"
#
#Line 92: jamfProURLArray[1]=“https://PamfProServerUrl1.com https://PamfProServerUrl2.com https://PamfProServerUrl3.com” 
#
#Line 101: apiUser=“Jamf Pro administrator username”
#
#Line 102: apiPass=“Jamf Pro administrator password”
#
#2. Run the script
#3. Look for any errors in the output of the script and manually check the corresponding Jamf Pro servers to ensure account was created successfully on servers that produce an error. 
#


#########################################################
####### HOW TO USE A CUSTOM PRIVILEDGE SET ##############
#########################################################

#This section will tell you how to create the new user with a custom privilege set with a small change to the script. Here are the steps:
# Step 1. Manually create a user account one 1 jamf server with your desired custom priviledge set that you want to duplicate to all your other jamf servers
# Step 2. Use a classic API call to pull the XML that defines that priviledge set. Use can use this small script to get this (copy this code in a new script and uncomment all lines. Do not run it in this same script to create the new user on all jamf instances):

# #!/bin/bash
# jamfProURL="" 
# apiUser=""
# apiPass=""
# newUserUserName="USERNAME OF USER WHOSE PRIVILDGE SET YOU WANT TO COPY"
# curl -sku $apiUser:$apiPass "$jamfProURL/JSSResource/accounts/username/$newUserUserName" -H "accept: text/xml" -X GET

# Step 3. The above script will output a big block XML that defines the priviledges of the defined user. Take this block of text and remove the following chuncks 
# 1. <?xml version="1.0" encoding="UTF-8"?>
# 2. <id>11</id>
# 3. <password_sha256 since="9.32">e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855</password_sha256>

# Step 4. Replace the contents of the userPrivsXML variable on line 109 with the chunk of XML text that you got in Step 2 and edited in step 3. 

# Step 5: Run this script to duplicate the user created manually on one jamf server on all the entered jamf server. 




#########################################################
############ Variables to Define ########################
#########################################################

#required field 
newUserUserName=""

#required field
newUserFullName=""

#this field is optional
newUserEmail=""

#Privilege set. You can enter "Administrator", "Auditor", "Enrollment Only", or "Custom". Please be case sensitive. For a Custom priviledge set you will need to add in the required xml keys for each priviledge. For full detials on how to easily get this see the custom privilege section of this script. 
newUserPrivilegeSet=""

#Enter "true" or "false" in all lowercase
forceUserToChangePassword=""

#Enter each jamf pro server whose you want to create the new jamf pro user account on between the quotes seperated by ONE space eg "https://PamfProServerUrl1.com https://PamfProServerUrl2.com https://PamfProServerUrl3.com" You can enter in as many servers as you like in this way. 
jamfProURLArray[1]="" 



#########################################################
###### Jamf API Credentials Entered Here ################
#########################################################

#this account must exist and use the same defined password on all jamf pro servers defined in the jamfProURLArray variable above. This account will need priviledges to create new standard jamf pro users
apiUser=""
apiPass=""



#########################################################
###### User Priviledges XML defined here ################
#########################################################
userPrivsXML="<account><name>$newUserUserName</name><directory_user>false</directory_user><full_name>$newUserFullName</full_name><email>$newUserEmail</email><email_address>$newUserEmail</email_address><enabled>Enabled</enabled><force_password_change>$forceUserToChangePassword</force_password_change><access_level>Full Access</access_level><privilege_set>$newUserPrivilegeSet</privilege_set></account>"



##########Use API calls to: ######################
# 1. Get a list of current users code for each jamf pro server for reference 
# 2. Check to see if the user account your planning to create exists on the jamf server already or not. 
# 3. If the user is not present it will create a new user account using the user information defined above. 
# 4. Output a list into the stdout for each jamf server saying if an account was created or not. 


for jamfProURL in ${jamfProURLArray[@]}
do

#Step 1: API Call to see if the user to be created exists already
userNameCheck=$(curl -sku $apiUser:$apiPass "$jamfProURL/JSSResource/accounts" -H "accept: text/xml" -X GET | xmllint -format - | grep "$newUserUserName")

if [[ $userNameCheck != "" ]]; then
	echo "$jamfProURL - user account already exists on will not attempt to create it"
else
	echo "$jamfProURL - user account doest NOT exist, proceeding with account creation"
	curl -sku $apiUser:$apiPass -H "content-type: text/xml"  "$jamfProURL/JSSResource/accounts/userid/0"  -X POST -d "$userPrivsXML"
fi
	
done


