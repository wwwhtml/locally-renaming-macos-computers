#!/bin/bash
# Script purpose: Locally rename MacOS computers, while using a csv as source of data. 
# The csv with data has four columns separated by comas: 1,userNameHere,laptopSerialNumber,newComputerName
# Author: Daniel Arauz - 2023-02-08 - Twitter: @danarauz Mastodon: @danarauz@mastodon.online


# Finding the local computer serial number:
# -----------------------------------------
oldHostname=$(hostname)
system_profiler SPHardwareDataType | grep Serial > ~/SPHardwareDataTypeParsedOutPut.txt
serialNumber=$(awk '{print $4}' ~/SPHardwareDataTypeParsedOutPut.txt)
echo "Local Computer serial number found: $serialNumber"
echo " "
echo "Attempting to rename computer..."
echo " "
IFS=","
while read f1 f2 f3 f4
do
if [ $serialNumber = $f3 ]; then 
  name="$f4"
	local="$f4"
	sudo scutil --set HostName "$name"  && sudo scutil --set ComputerName "$name" && sudo scutil --set LocalHostName "$local"
	#renamedComputersList="Renamed_computers_List.txt"
  echo "$f1, $f2, $f3, $f4" >> renamedComputerslist.txt 
	echo "Local Computer old Hostname: $oldHostname"
	echo "Local Computer new Hostname: $(hostname)"
fi
done < csv-with-serialNumbers.csv
