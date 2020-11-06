#!/bin/bash -v
exec 2>&1


####Written by quinningtime


####About this program:####
##Name: GrantAdminRights.sh

##Description:
#this script is designed to promote specified user accounts to admins on macOS and create a log of its changes 
##Version:
#v1.0 - 11-04-2020 Script first created

###create the arrays
#Variables set here. Hard code as many usernames as desired seperated by spaces between the quotes. Leave quotes as is if your deploying this script in jamf pro and instead use the Paramter 4 field for the list of users to promote
listOfSubmittedUsernames[1]=""

#Check to see if parameter 4 field was used or if the script is hardcoded
if [ "$4" != "" ] && [ "${listOfSubmittedUsernames[1]}" == "" ]; then
	listOfSubmittedUsernames[1]="$4"
fi

#proccess users to translate all upper case characters to lowercase 
proccessedUsers[2]="$(echo ${listOfSubmittedUsernames[1]} | tr 'A-Z' 'a-z')"


#Output list of users that will be promoted to admin 
echo "These users will be promoted to admin: ${proccessedUsers[2]}" 


###Logging Section####
#this section does not perform promotions, instead allows the script to create a protected directory in the JAMF folder to make a log of its actions"

#check to see if Approved Admin Users directory already exists and creates it if not
if [[ -d "/Library/Application Support/JAMF/Approved Admin Users" ]]; then
	echo "/Library/Application Support/JAMF/Approved Admin Users already exists"
	else
	mkdir "/Library/Application Support/JAMF/Approved Admin Users"
fi

#protect /Library/Application Support/JAMF/Approved Admin Users directory by setting owner as root and granting only the owner read/write/execute permissions 
chown root:admin "/Library/Application Support/JAMF/Approved Admin Users"
chmod 700 "/Library/Application Support/JAMF/Approved Admin Users"


#perform promotion of each specified user account and log the action to the "promotedUsersLog.txt" file in /Library/Application Support/JAMF/Approved Admin Users/
for accountToPromote in ${proccessedUsers[2]}
do
	echo "promoting user $accountToPromote"
	dseditgroup -o edit -a "$accountToPromote" -t user admin >> "/Library/Application Support/JAMF/Approved Admin Users/promotedUsersLog.txt"
	echo "$(date +%F\ %T) $accountToPromote Promoted" >> "/Library/Application Support/JAMF/Approved Admin Users/promotedUsersLog.txt"
done
exit 0

