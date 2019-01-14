#!/bin/bash


#First, check if an active network connection exists

ping 8.8.8.8 -c1 -w1 &>/dev/null
if [[ "$?" == 1 ]]; then 
	echo " No active connection. Please check"
	exit 
fi


#Update the system
echo "Updateing the system"
echo&&echo&&echo 
yum -y update
yum -y install bash-completion bash-completion-extras yum-utils curl wget vim epel-release
#Remove older kernels
echo "Removing older Kernels"
sleep 1
package-cleanup --oldkernels --count=1

#Install Virtual Box Tools
   #First Check if the user defined it
if [[ "$1" == "--virtual" ]] ; then
	echo "Installing VirtualBox tools"
	echo "Please make sure you have Inserted the media"
	echo "-----------------"
	echo "Did the media is plugged in?.....  yes/no"
	read var
	if [[ "$var" == "yes" ]]; then
		echo "Will setup Virtualbox tools" 
	elif [[ "$var" == "no" ]]; then
		echo "Aboring install of virtual box tools"
		exit 
	else
		echo "No correct answer given"
		exit
	fi
	rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	yum -y install perl gcc dkms kernel-devel kernel-headers make bzip2
	mkdir /media/VirtualBoxGuestAdditions
	mount -r /dev/cdrom /media/VirtualBoxGuestAdditions
	rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	KERN_DIR=/usr/src/kernels/`uname -r`/build
	cd /media/VirtualBoxGuestAdditions
	./VBoxLinuxAdditions.run
fi

#Install Google Chrome
echo "Install chrome"
sleep 1
cp -n ./google-chrome.repo /etc/yum.repos.d/
yum info google-chrome-stable
yum -y install google-chrome-stable byobu

#reboot
echo "rebooting"
reboot	
	

