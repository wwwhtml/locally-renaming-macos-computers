#!/bin/bash
# Script purpose: Locally rename MacOS computers, while using a csv as source of data. 
# The csv with data has four columns separated by comas: 1,userNameHere,laptopSerialNumber,newComputerName
# Author: Daniel Arauz - Created: 2023-02-08 Updated: 2023-02-09 - Twitter: @danarauz Mastodon: @danarauz@mastodon.online
clear
echo " "
echo "Finding the local computer serial number..."
echo "--------------------------------------------"
oldHostname=$(hostname)
system_profiler SPHardwareDataType | grep Serial > ~/SPHardwareDataTypeParsedOutPut.txt
serialNumber=$(awk '{print $4}' ~/SPHardwareDataTypeParsedOutPut.txt)
echo "Local Computer serial number found: $serialNumber"
echo " "
echo " "
echo "Attempting to rename computer..."
echo "--------------------------------"
IFS=","
while read f1 f2 f3 f4
do
if [ $serialNumber = $f3 ]; then
        name="$f4"
        local="$f4"
        sudo scutil --set HostName "$name"  && sudo scutil --set ComputerName "$name" && sudo scutil --set LocalHostName "$local"
        echo "$f1, $f2, $f3, $f4, $(date)" >> listOfRenamedComputers.txt
        echo "Old Hostname: $oldHostname"
        echo "New Hostname: $(hostname)"
        echo " "
fi
done < csv-with-serialNumbers.csv
echo "Command executed."
echo " "
