#!/bin/bash

# Ensure script runner = ROOT
rootID='0';

if [[ ${UID} -ne ${rootID} ]];
    then 
        echo "Sorry, you aren't ROOT!";
        exit 1;
else
    # If user's UID='0' = ROOT => Continue

    # Ask whether add a new NIC
    read -p "Do you wanna configure a new NIC? [Y/N]" newNIC;
    if [[ ${newNIC} -eq 'Y' ]] || [[ ${newNIC} -eq 'y' ]];
    then 
        echo "Alright! Adding a new NIC for you!";
        read -p "Enter NIC name for NAT: [ens33]" nicName;
        read -p "Confirm NIC name for NAT: [ens33]" confirmNicName;
        if [[ ${nicName} -eq ${confirmNicName} ]];
        then
            echo "Proceeding...";
            read -p "Enter ${nicName}'s IP [192.168.0.18]: " nicIP;
            read -p "Enter ${nicName}'s netmask: [255.255.255.0]" nicNetmask;
            read -p "Enter ${nicName}'s gateway: [192.168.0.1]" nicGateway;
            read -p "Enter ${nicName}'s network address: [192.168.0.0]" nicNetwork;
        else
            echo "NAT nic name ${nicName} does NOT MATCH ${confirmNicName}";
            echo "Please re-enter NAT nic name...";
            read -p "Enter NIC name for NAT: [ens33]" nicName;
            read -p "Confirm NIC name for NAT: [ens33]" confirmNicName;
        
        # Adding NAT NIC
        networkConfig='/etc/network/interfaces'
        printf "auto ${nicName}\niface ${nicName} inet static\naddress ${nicIP}\nnetmask ${nicNetmask}\ngateway ${nicGateway}\nup route add -net ${nicNetwork} netmask ${nicNetmask} gw ${nicGateway}" >> ${networkConfig};
        
        if [[ ${?} -eq 0 ]]
        then
            echo "Successfully added new NIC into ${networkConfig}";
            echo "Restarting networking services";
            # Stop networking service
            systemctl stop networking;
            if [[ ${?} -eq 0 ]]
            then
                echo "Succeeded in stopping networking service";
                echo "Starting networking service again...";
                systemctl start networking;
                if [[ ${?} -eq 0 ]]
                then
                    echo "Succeeded in starting networking service";
                    echo "Succeeded in adding ${nicName}";
                else
                    echo "Failed to start networking service...";
            else
                echo "Failed to stop networking service...";
                echo "Skipping networking service restart...";
        else
            echo "Failed to add new NIC into ${networkConfig}...";
    else
        echo "NOT gonna add a new NIC :)";
        echo "Skipping...";

    # Update expired Kali Linux keys on a Debian12 base-build image
    echo "Adding expired Kali Linux keys on this Debian Linux plain build";
    
    # Updating expired Kali Linux keys
    addKey=$(wget https://archive.kali.org/archive-key.asc -O /etc/apt/trusted.gpg.d/kali-archive-keyring.asc);
    if [[ ${?} -eq 0 ]];
    then
        echo "Succeeded in updating Kali Linux keys!";
    else
        echo "Failed to update Kali Linux keys...";

    # Backup existing Debian repository
    aptPath='/etc/apt/sources.list';
    aptBackup='/etc/apt/sources-backup.list';
    
    # Echo output of existing Apt Repository
    echo "Current Debian Apt Repository: ";
    cat ${aptPath};
    echo "Backup existing Apt repository before making it to Kali repo...";
    cp ${aptSource} ${aptBackup};
    if [[ ${?} -eq 0 ]];
    then
        echo "Succeeded in backing up existing Apt repo";
        echo "Proceeding to change Apt repo to Kali repo!";
        printf "deb https://http.kali.org/kali kali-rolling main non-free contrib\ndeb-src https://http.kali.org/kali kali-rolling main non-free contrib" > ${aptPath};
        if [[ ${?} -eq 0 ]]
        then
            echo "Succeeded in customizing this Debian repo to Kali repo!";
            echo "Proceeding to apt update && apt upgrade!";

            # apt update && apt upgrade
            apt update && apt upgrade;
            
            if [[ ${?} -eq 0]];
            then
                echo "Congrats! Your Debian has become a Kali Linux now :D!";
                echo "Continuing to Install Open-source hacking tools :D!";

                # Start installing tones of customized hacking tools
                # net-tools (ifconfig)
                # mac-robber
                # SNAP
                # Git
                # Docker
                # Ettercap-graphical
                # Hydra
                # Cassandra
                # Beef-XSS (Beef project)
                # Metasploit dependencies
                ## 'tee' 'curl' 'ca-certificates' 'openssl' 'apt-transport-https' 'software-properties-common' 'lsb-release' 'postgresql'
                #
                ## Import Metasploit APT Repository on Debian
                # curl -fsSL https://apt.metasploit.com/metasploit-framework.gpg.key | sudo gpg --dearmor | sudo tee /usr/share/keyrings/metasploit.gpg > /dev/null
                ## Add Metasploit Repository
                # echo "deb [signed-by=/usr/share/keyrings/metasploit.gpg] https://apt.metasploit.com/ buster main" | sudo tee /etc/apt/sources.list.d/metasploit.list
                ## Apt install Metasploit
                # apt install metasploit-framework
                ## First-time setup
                # msfconsole
                tools=('0trace'
                        'net-tools'
                        'galleta'
                        'gdb-peda'
                        'gdisk'
                        'getallurls'
                        'ghidra'
                        'aesfix'
                        'aeskeyfind'
                        'afflib'
                        'afflib-tools'
                        'libafflib-dev'
                        'libafflib0v5'
                        'afl++-doc'
                        'aircrack-ng'
                        'airgraph-ng'
                        'airgeddon'
                        'altdns'
                        'amap'
                        'nmap'
                        'amass'
                        'amass-common'
                        'apache2'
                        'apktool'
                        'apple-bleee'
                        'arjun'
                        'armitage'
                        'arp-scan'
                        'arping'
                        'arpwatch'
                        'asleap'
                        'assetfinder'
                        'atftp'
                        'autopsy'
                        'axel'
                        'b374k'
                        'backdoor-factory'
                        'bed'
                        'beef-xss'
                        'berate-ap'
                        'bettercap-ui'
                        'bind9'
                        'bing-ip2hosts'
                        'binwalk'
                        'bloodhound'
                        'blue-hydra'
                        'bluelog'
                        'blueranger'
                        'bluez'
                        'braa'
                        'bruteforce-luks'
                        'bruteforce-salted-openssl'
                        'bruteshark'
                        'brutespray'
                        'btscanner'
                        'bulk-extractor'
                        'bully'
                        'burpsuite'
                        'bytecode-viewer'
                        'cabextract'
                        'cadaver'
                        'caldera'
                        'calico'
                        'capstone'
                        'ccrypt'
                        'certgraph'
                        'certipy-ad'
                        'cewl'
                        'changeme'
                        'chaosreader'
                        'cherrytree'
                        'chirp'
                        'chisel'
                        'chkrootkit'
                        'chntpw'
                        'chromium'
                        'cifs-utils'
                        'cillium-cli'
                        'cisco-audting-tool'
                        'cisco-ocs'
                        'cisco-torch'
                        'cisco7crack'
                        'clamav'
                        'cloud-enum'
                        'cloudbrute'
                        'cmospwd'
                        'cmseek'
                        'cntlm'
                        'code-oss'
                        'colly'
                        'command-not-found'
                        'ifconfig'
                        ''
                        'libavcodec60'
                        'libavformat60'
                        'aflplusplus'

                        'mac-robber' 
                        'snapd' 
                        'git' 
                        'docker.io' 
                        'ettercap-graphical' 
                        'hydra' 
                        'cassandra' 
                        'beef-xss' 
                        'tee' 
                        'curl' 
                        'ca-certificates' 
                        'openssl' 
                        'apt-transport-https' 
                        'software-properties-common' 
                        'lsb-release' 
                        'postgresql'
                        );

                # Iterate through $tools[@] && Install each tool
                for tool in ${tools[@]};
                do
                    echo "Installing tool: ${tool}";
                    installTools=$(apt install ${tool} -y);
                    if [[ @{?} -eq 0 ]];
                    then
                        echo "Succeeded in installing ${tool}";
                    else
                        echo "Failed to install ${tool}";
                done
                



            else
                echo "We feel sorry that your Debian did NOT become a Kali Linux :(";
                # Terminate Customization here if failed to become a Kali linux
                exit 1;

        else
            echo "Failed to customize this Debian repo to Kali repo...";
            echo "Skipping...";


    else
        echo "Failed to back up existing Apt repo";
        echo "Skipping Debian customization...";




