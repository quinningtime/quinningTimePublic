#!/bin/bash

#written by quinningTimePublic

#Version History
# 2/1/2021 - Version 1.0 - Intial Release

#About this program
# This script is designed to uninstall the cisco umbrella roaming client from a mac. If deploying via jamf it is highly recomended you add the Maintenance with Update Inventory selected so jamf will know the computer no longer has umbrella right away. 



#Invoke the cisco umbrella command line uninstaller as documented on this umbrella KB article: https://support.umbrella.com/hc/en-us/articles/230901028-Umbrella-Roaming-Client-Uninstalling


/Applications/OpenDNS\ Roaming\ Client/rcuninstall



#Kill the umbrella menu bar process that gets left after the uninstall 
killall UmbrellaMenu
