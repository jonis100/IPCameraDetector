#! /bin/bash

if [ "$#" -ne 4  ]
then
	exit
fi
IF=$1
CONTROL_CH=$2
BW=$3
CENTRAL_CH1=$4
START_RUN=${IF}_$(date +%Y-%m-%d-%H-%M-%S)

function configure_wireshark  {
echo Unload iwlwifi
modprobe iwlmvm -r
modprobe iwlwifi -r
sleep 1

echo Load iwlwifi
modprobe iwlwifi
sleep 1

echo $IF down and set as Monitor
ifconfig $IF down
iw $IF set type monitor

echo $IF UP and set $CONTROL_CH $BW $CENTRAL_CH1
ifconfig $IF up
iw $IF set freq $CONTROL_CH $BW $CENTRAL_CH1
sleep 0.1

}

function capture {
	tshark -i $IF -w ~/$START_RUN/sniffer_capture.pcap -b filesize:100000 -b files:1000
}

killall wpa_supplicant
mkdir ~/$START_RUN
configure_wireshark 
capture
