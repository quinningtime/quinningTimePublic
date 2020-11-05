#!/bin/bash


####Written by quinningtime


####About this program:####
##Name: removeAdminRights.sh

##Description:
#this script is designed to remove admin rights from all user accounts on a mac with a UID above 500. User accounts may be excempted from this change by adding their user names as read in parameters 4-9. Read in parameters where designed with deployment via jamf pro in mind which allows the use of parameter 4-11 fields for any purpose. 

##Version:
#v1.0 - 10-22-2020 Script first created

###create the arrays
#create the allAdmins array with values populated from a list of all user accounts with a uniqueID number above 500 which should only be user accounts that can be logged into
allAdmins[1]=$(dscl . list /Users UniqueID | awk '$2>500{print $1}')

#Set List Of Exempted Users using read in parameter 4-9 value on jamf pro. You may leave blank parameter fields if you list of exempted user account is smaller then 6
exemptedAdmin1="$(echo ${4} | tr 'A-Z' 'a-z')"
exemptedAdmin2="$(echo ${5} | tr 'A-Z' 'a-z')"
exemptedAdmin3="$(echo ${6} | tr 'A-Z' 'a-z')"
exemptedAdmin4="$(echo ${7} | tr 'A-Z' 'a-z')"
exemptedAdmin5="$(echo ${8} | tr 'A-Z' 'a-z')"
exemptedAdmin6="$(echo ${9} | tr 'A-Z' 'a-z')"



#echo out the values of the all admins array
echo "The list of all users with a UID above 500 are: ${allAdmins[1]}"

#echo out the values of the exemptedAdmins Array
echo "The list of users exempted from admin rights removal are: $exemptedAdmin1 $exemptedAdmin2 $exemptedAdmin3 $exemptedAdmin4 $exemptedAdmin5 $exemptedAdmin6"



### Removing admin rights in this section for each user listed in the $adminsToRemove Array

for accountToRemove in ${allAdmins[@]}
do
	if [[ "$accountToRemove" != "root" ]]  && [[ "$accountToRemove" != "$exemptedAdmin1" ]] && [[ "$accountToRemove" != "$exemptedAdmin2" ]] && [[ "$accountToRemove" != "$exemptedAdmin3" ]] && [[ "$accountToRemove" != "$exemptedAdmin4" ]] && [[ "$accountToRemove" != "$exemptedAdmin5" ]] && [[ "$accountToRemove" != "$exemptedAdmin6" ]]; then 
		#echo-ing each account name just before performing demotion command against it for the log
			echo "performing demotion of $accountToRemove"
			#command that performs the actualy demotion of a specified account to standard user. 
			/usr/sbin/dseditgroup -o edit -d "$accountToRemove" -t user admin
	else
		echo "Admin user $accountToRemove left alone"
	fi
done
exit 0





