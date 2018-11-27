#!/bin/bash
D='/sys/class/net'
for nic in $( ls $D )
do
	if [[ $nic != *"veth"* ]] && [[ $nic != *"br"* ]]
	then
		echo "Interface Name:" $nic
		echo "Mac Address:" 
		cat $D/$nic/address
		echo "State:"
		cat $D/$nic/operstate
		echo "IPs:" 
		ip addr show dev $nic | sed -En -e 's/.*inet ([0-9.]+).*/\1/p'
		echo "---------------------------------------\n"
	fi
done 
