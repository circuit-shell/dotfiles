#!/bin/bash

echo "Changing input"

# MSE_CH = channel on unifying receiver for the destination mouse. Typically maps 1 minus the channel button you press on the mouse to switch
MSE_CH=0x02
# MSE_ID = ID of the mouse (typically this maps to the order of mouse devices you see in the unifying software app in Advanced settings)
MSE_ID=0x01

# These typically don't change, but tap Apple menu->About This Mac->System Report->USB->USB Receiver for Logitech 
# and make sure Product ID (RCVR_PID) and Vendor ID (RCVR_VID) are accurate 
RCVR_VID=046D
RCVR_PID=B023

echo "Using VID:PID ${RCVR_VID}:${RCVR_PID}"
echo "Using MSE_CH: ${MSE_CH}, MSE_ID: ${MSE_ID}"

 # sudo ./hidapitester --vidpid ${RCVR_VID}:${RCVR_PID} --open --length 7 --send-output 0x05,0x04,0x00,0x00,0x02,0x13
 # sudo ./hidapitester --vidpid ${RCVR_VID}:${RCVR_PID} --open --length 7 --send-output 0x0f,0x04,0x00,0x01,0x19,0x04
 #
 # sudo ./hidapitester --vidpid ${RCVR_VID}:${RCVR_PID} --open --length 7 --send-output 0x10,${KYB_ID},0x09,0x1e,${KYB_CH},0x00,0x00
 # sudo ./hidapitester --vidpid 046D:B023 --open --length 7 --send-output 0x10,0x02,0x0a,0x1e,0x01,0x00,0x00
sudo ./hidapitester --vidpid 046D:B023 --usage 0x0001 --usagePage 0xFF00 --open --length 7 --send-output 0x10,0x01,0x09,0x1e,0x01,0x00,0x00

