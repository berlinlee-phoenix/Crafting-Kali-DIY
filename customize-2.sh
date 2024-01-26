#!/bin/bash

# Ensure script runner = ROOT
rootID='0';

if [[ ${UID} -eq ${rootID} ]];
then 
    # If user's UID='0' = ROOT => Continue

    # # Ask whether add a new NIC
    # read -p "Do you wanna configure a new NIC? [Y/N]" newNIC;
    # if [[ ${newNIC} -eq 'Y' ]] || [[ ${newNIC} -eq 'y' ]];
    # then 
    #     echo "Alright! Adding a new NIC for you!";
    #     read -p "Enter NIC name for NAT: [ens33]" nicName;
    #     read -p "Confirm NIC name for NAT: [ens33]" confirmNicName;
    #     if [[ ${nicName} -eq ${confirmNicName} ]];
    #     then
    #         echo "Proceeding...";
    #         read -p "Enter ${nicName}'s IP [192.168.0.18]: " nicIP;
    #         read -p "Enter ${nicName}'s netmask: [255.255.255.0]" nicNetmask;
    #         read -p "Enter ${nicName}'s gateway: [192.168.0.1]" nicGateway;
    #         read -p "Enter ${nicName}'s network address: [192.168.0.0]" nicNetwork;
    #     else
    #         echo "NAT nic name ${nicName} does NOT MATCH ${confirmNicName}";
    #         echo "Please re-enter NAT nic name...";
    #         read -p "Enter NIC name for NAT: [ens33]" nicName;
    #         read -p "Confirm NIC name for NAT: [ens33]" confirmNicName;
    #     fi
        
    #     # Adding NAT NIC
    #     networkConfig='/etc/network/interfaces'
    #     printf "auto ${nicName}\niface ${nicName} inet static\naddress ${nicIP}\nnetmask ${nicNetmask}\ngateway ${nicGateway}\nup route add -net ${nicNetwork} netmask ${nicNetmask} gw ${nicGateway}" >> ${networkConfig};
        
    #     if [[ ${?} -eq 0 ]]
    #     then
    #         echo "Successfully added new NIC into ${networkConfig}";
    #         echo "Restarting networking services";
    #         # Stop networking service
    #         systemctl stop networking;
    #         if [[ ${?} -eq 0 ]]
    #         then
    #             echo "Succeeded in stopping networking service";
    #             echo "Starting networking service again...";
    #             systemctl start networking;
    #             if [[ ${?} -eq 0 ]]
    #             then
    #                 echo "Succeeded in starting networking service";
    #                 echo "Succeeded in adding ${nicName}";
    #             else
    #                 echo "Failed to start networking service...";
    #             fi

    #         else
    #             echo "Failed to stop networking service...";
    #             echo "Skipping networking service restart...";
    #         fi

    #     else
    #         echo "Failed to add new NIC into ${networkConfig}...";
    #     fi

    # else
    #     echo "NOT gonna add a new NIC :)";
    #     echo "Skipping...";
    # fi

    # Checking internet access
    checkInternet=$(ping -c 2 1.1.1.1);
    if [[ ${checkInternet} -eq 0 ]];
    then
        echo "Confirm internet connectivity :D";
        echo "Proceeding!!!!";
    else
        echo "Cannot confirm internet connectivity :(";
        echo "Will attempt customization, but likely to fail...";
    fi

    # Create /home/root
    user=$(whoami);
    mkdir /home/${user};
    if [[ ${?} -eq 0 ]];
    then
        echo "Succeeded in creating /home/${user}";
    else
        echo "Failed to create /home/${user}";
    fi

    # Create /home/root/Desktop
    mkdir /home/${user}/Desktop;
    if [[ ${?} -eq 0 ]];
    then
        echo "Succeeded in creating /home/${user}/Desktop";
    else
        echo "Failed to create /home/${user}/Desktop";
    fi

    # Create /home/root/Downloads
    mkdir /home/${user}/Downloads;
    if [[ ${?} -eq 0 ]];
    then
        echo "Succeeded in creating /home/${user}/Downloads";
    else
        echo "Failed to create /home/${user}/Downloads";
    fi

    echo "======== START - Debian background theme============";
    # Update Debian login page to a less scary image
    # Download Anonymous .jpg
    findImage=$(find /home/${user}/Downloads | grep 'anonymous');

    if [[ ${?} -ne 0 ]];
    then
        echo "========================";
        echo "========================";
        echo "Cannot find Image, downloading...";
        echo "";
        anonymousImage='https://media.wnyc.org/i/800/0/l/85/1/we-are-anonymous.jpg'
        cd /home/${user}/Downloads && wget ${anonymousImage};
        if [[ ${?} -eq 0 ]];
        then
            anonymousImagePath="/home/${user}/Downloads/we-are-anonymous.jpg";
            echo "Succeeded in downloading Anonymous Image :D";
            echo "Proceeding to change Debian profile :D";
            imagePath='/usr/share/backgrounds/';
            # Change Debian profile image
            cp $findImage $imagePath;
            if [[ ${?} -eq 0 ]];
            then
                echo "Succeeded in adding a lock screen Image :D";
                echo "Removing existing Kali Linux lock screen images";
                lockScreen='/usr/share/backgrounds/';
                #rm -rf $lockScreengnome
                rm -rf $lockScreenkali
                rm -rf $lockScreenkali*
            else
                echo "Failed to copy new image to lock screen image :(";
            fi
        else
            echo "Failed to download Image";
            echo "Skipping...";
            echo "========================";
            echo "========================";
        fi

    else
        echo "Not downloading Anonymous Image :(";
    fi
    echo "======== END - Debian background theme============";

    # Update expired Kali Linux keys on a Debian12 base-build image
    echo "============= Adding expired Kali Linux keys on this Debian Linux plain build =================";
    
    # Updating expired Kali Linux keys
    addKey=$(wget https://archive.kali.org/archive-key.asc -O /etc/apt/trusted.gpg.d/kali-archive-keyring.asc);
    if [[ ${?} -eq 0 ]];
    then
        echo "Succeeded in updating Kali Linux keys!";
        echo "======================================";
    else
        echo "Failed to update Kali Linux keys...";
        echo "======================================";
        exit 1;
    fi

    # Backup existing Debian repository
    aptPath='/etc/apt/sources.list';
    aptBackup='/etc/apt/sources-backup.list';
    
    # Echo output of existing Apt Repository
    echo "Current Debian Apt Repository: ";
    echo "";
    cat ${aptPath};
    echo "";
    echo "";
    echo "Backup existing Apt repository before making it to Kali repo...";
    cp ${aptPath} ${aptBackup};
    if [[ ${?} -eq 0 ]];
    then
        echo "Succeeded in backing up existing Apt repo";
        echo "Proceeding to change Apt repo to Kali repo!";
        echo "";
        echo "";
        printf "deb https://http.kali.org/kali kali-rolling main non-free contrib\ndeb-src https://http.kali.org/kali kali-rolling main non-free contrib" > ${aptPath};
        if [[ ${?} -eq 0 ]];
        then
            echo "Succeeded in customizing this Debian repo to Kali repo!";
            echo "Proceeding to apt update && apt upgrade!";
            echo "";
            echo "";

            # apt update && apt upgrade
            apt-get update && apt-get -y upgrade;
            if [[ ${?} -eq 0 ]] || [[ ${?} -eq 100 ]];
            then
                # If SUCCEEDED apt update & apt upgrade 
                # APT Repository already becomes Kali!!
                echo "Succeeded in APT update => upgrade!:D";
                # Proceed apt autoremove to remove obsolete apt resources
                echo "Cleaning up APT!";
                apt autoremove -y;
                if [[ ${?} -eq 0 ]];
                then
                    echo "Succeeded in cleaning up APT trash :D";
                    echo "Proceeding to apt-get update && apt-get -y upgrade; the 2nd time";
                    echo "======================================";
                    echo "======================================";
                else
                    echo "Failed to clean up ATPT trash :(";
                    echo "Let's try to do APT update => upgrade again";
                    echo "======================================";
                    echo "======================================";
                    echo "";
                fi

                apt-get update && apt-get -y upgrade;
                if [[ ${?} -eq 0 ]];
                then
                    echo "Succeeded in apt-get update && apt-get -y upgrade";
                    echo "Proceeding 2nd time apt autoremove...";
                    echo "======================================";
                    echo "======================================";
                    echo "";
                    apt autoremove -y;

                    if [[ ${?} -eq 0 ]];
                    then
                        echo "Succeeded in 2nd time APT clean up :D";
                        echo "Please reboot this Debian :D";
                        echo "";
                        echo "======================================";
                        echo "======================================";
                        echo "";
                    else
                        echo "Failed to clean up APT for 2nd time";
                        echo "You may manually APT clean up";
                        echo "";
                        echo "======================================";
                        echo "======================================";
                        echo "";
                    fi
                else
                    echo "Failed 2nd time to apt-get update && apt-get -y upgrade";
                    echo "No worries :) We'll try to breakthrough though :D";
                    echo "";
                    echo "======================================";
                    echo "======================================";
                    echo "";
                fi
            else
                echo "Failed to upgrade to Kali linux :(";
            fi

            # 1st time apt update && apt -y upgrade 
            if [[ ${?} -eq 0 ]];
            then
                echo "Congrats! Your Debian has now become a Kali Linux now :D!";
                echo "Changing Kernel settings to disable Restart pop-ip in /etc/needrestart/needrestart.conf";
                echo "To avoid Daemons Restart pop-up during Open-source attack tools installation";
                restartConf='/etc/needrestart/needrestart.conf';
                existingRestart=$(grep '$nrconf{restart}' ${restartConf});
                targetRestart="\$nrconf{restart} = 'a'";
                sed -i "s/$existingRestart/$targetRestart/g" $restartConf;
                if [[ ${?} -eq 0 ]];
                then
                    echo "Succeeded in disabling Daemon pop-up before Tools installation";
                    echo "Please reboot before running this script to install tools :D!!";
                else
                    echo "Failed to disable Daemon pop-up";
                    echo "Daemon alert may come up during Tools installation";
                fi

                echo "Continuing to Install Open-source hacking tools :D!";
                echo "";
                echo "======================================";
                echo "======================================";
                echo "";
                
                # Start installing tones of customized hacking tools
                ## ifconfig must be added to sys variables
                # net-tools (ifconfig)
                ##
                # VIM Editor
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
                tools=('net-tools'
                        'tcpdump'
                        'kaboxer'
                        'xdg-utils'
                        'vim'
                        'libc6'
                        'libgcc-s1'
                        'libstdc++6'
                        'aesfix'
                        'aeskeyfind'
                        'libafflib0v5'
                        'libc6'
                        'libexpat1'
                        'libfuse2'
                        'libgcc-s1'
                        'libssl3'
                        'libstdc++6'
                        'afflib-tools'
                        'libafflib0v5'
                        'libafflib-dev'
                        'build-essential'
                        'clang'
                        'clang-14'
                        'libc6'
                        'libgcc-s1'
                        'libpython3.11'
                        'libstdc++6'
                        'procps'
                        'afl++'
                        'afl++-doc'
                        'graphviz'
                        'python3'
                        'aircrack-ng'
                        'gawk'
                        'iproute2'
                        'iw'
                        'pciutils'
                        'procps'
                        'tmux'
                        'xterm'
                        'perl'
                        'apktool'
                        'kali-defaults'
                        'python3-bluez'
                        'python3-bs4'
                        'python3-ctypescrypto'
                        'python3-fleep'
                        'python3-libarchive-c'
                        'python3-netifaces'
                        'python3-pil'
                        'python3-prettytable'
                        'python3-pycryptodome'
                        'python3-requests'
                        'apple-bleee'
                        'python3-dicttoxml'
                        'python3-requests'
                        'arjun'
                        'openjdk-11-jre'
                        'libc6'
                        'libcap2'
                        'libpcap0.8'
                        'arp-scan'
                        'libnet1'
                        'libpcap0.8'
                        'libseccomp2'
                        'arping'
                        'adduser'
                        'gawk'
                        'init-system-helpers'
                        'libc6'
                        'libpcap0.8'
                        'lsb-base'
                        'arpwatch'
                        'libpcap0.8'
                        'asleap'
                        'assetfinder'
                        'libreadline8'
                        'nmap'
                        'arp-scan'
                        'autopsy'
                        'curl'
                        'lsof'
                        'beef-xss'
                        'hostapd-mana'
                        'iproute2'
                        'iw'
                        'procps'
                        'libc6'
                        'libusb-1.0-0'
                        'libnetfilter-queue1'
                        'libpcap0.8'
                        'bettercap'
                        'bettercap-caplets'
                        'bettercap-ui'
                        'wget'
                        'golang-github-antchfx-htmlquery-dev'
                        'golang-github-jawher-mow.cli-dev'
                        'golang-github-saintfish-chardet-dev'
                        'golang-google-appengine-dev'
                        'golang-github-antchfx-xmlquery-dev'
                        'golang-github-kennygrant-sanitize-dev'
                        'golang-github-temoto-robotstxt-dev'
                        'golang-github-gobwas-glob-dev'
                        'golang-github-puerkitobio-goquery-dev'
                        'golang-golang-x-net-dev'
                        'golang-github-gocolly-colly-dev'
                        'unicorn-magic'
                        'libwireshark17'
                        'libwiretap-dev'
                        'libwsutil-dev'
                        'libwireshark-dev'
                        'bundler'
                        'hping3'
                        'httprobe'
                        'httpx-toolkit'
                        'hydra'
                        'smbclient'
                        'zsh'
                        'sudo'
                        'ca-certificates'
                        'python3-pip'
                        'snapd'
                        'git'
                        'unzip'
                        'veil'
                        'whatmask'
                        'ruby-interpreter'
                        'uby-addressable'
                        'ruby-ipaddress'
                        'whatweb'
                        'whois'
                        'screen'
                        'wifi-honey'
                        'cowpatty'
                        'iptables'
                        'netmask'
                        'netsed'
                        'debconf'
                        'liblz4-1'
                        'libnl-genl-3-200'
                        'liblzo2-2'
                        'libpam0g'
                        'libcap-ng0'
                        'libnl-3-200'
                        'libpkcs11-helper1'
                        'openvpn'
                        'ettercap-graphical'
                        'libnfc6'
                        'libnfc-bin'
                        'forensic-artifacts'
                        'python3-artifacts'
                        'rtpflood'
                        'ruby-multipart-post'
                        'ruby-awesome-print'
                        'ruby-iostruct'
                        'ruby-zhexdump'
                        'ruby-pedump'
                        'libdevmapper-event1.02.1'
                        'liblvm2cmd2.03'
                        'libdevmapper1.02.1'
                        'dmeventd'
                        'rainbowcrack'
                        'iproute2'
                        'vlan'
                        'traceroute'
                        'ncat'
                        'commix'
                        'bruteforce-luks'
                        'bruteforce-salted-openssl'
                        'bruteshark'
                        'brutespray'
                        'btscanner'
                        'bulk-extractor'
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
                        'commix'
                        'copy-router-config'
                        'cosign'
                        'covenant-kbx'
                        'cowpatty'
                        'make'
                        'crack-common'
                        'libc6'
                        'libcrypt1'
                        'libavcodec60'
                        'libavformat60'
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
                        'postgresql');

                # Iterate through $tools[@] && Install each tool
                for tool in ${tools[@]};
                do
                    echo "Installing tool: ${tool}";
                    installTools=$(apt install ${tool} -y);
                    if [[ ${?} -eq 0 ]];
                    then
                        echo "======================================";
                        echo "";
                        echo "";
                        echo "Succeeded in installing ${tool}";
                        echo "======================================";
                        echo "======================================";
                        echo "";
                        echo "";
                    else
                        echo "======================================";
                        echo "";
                        echo "";
                        echo "Failed to install ${tool}";
                        echo "======================================";
                        echo "======================================";
                        echo "";
                        echo "";
                    fi
                done

                userProfile=$(find / -name '.profile' 2>/dev/null | tail -n 1);
                copyProfile=$(cat ${userProfile} > /home/${user}/.profile);
                if [[ ${?} -eq 0 ]];
                then
                    echo "Succeeded in copying a normal user profile to ${user}'s profile";
                    echo "${user}'s profile is in /home/${user}/.profile";
                    echo "=================================";
                    echo "=================================";
                    echo "Content of ${user}'s .profile is:";
                    cat /home/${user}/.profile;
                    echo "=================================";
                    echo "=================================";
                else
                    echo "Failed to copy a normal user profile to ${user}'s profile";
                fi
                # Adding System variables to .profile in your Kernel
                printf "export PATH=$PATH: /sbin/" >> .profile;
                ## You should SEE export PATH=/usr/local/bin:/usr/bin:/usr/local/games:/usr/games: /sbin/
                ## At the end of your .profile
                targetTailProfile='export PATH=/usr/local/bin:/usr/bin:/usr/local/games:/usr/games: /sbin/'
                checkPATH=$(tail -n 1 .profile);
                if [[ ${targetTailProfile} -eq ${checkPath} ]];
                then   
                    echo "=================================";
                    echo "Succeeded in updating SYS PATH :D!";
                    echo "=================================";
                else
                    echo "=================================";
                    echo "Failed to update SYS PATH :(";
                    echo "You have to update SYS PATH yourself :(";
                    echo "=================================";
                fi

                # Add back all Debian repositories after turning Debian into Kali
                #printf "\n\ndeb https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware\ndeb-src https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware\n\ndeb https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware\ndeb-src https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware\n\ndeb https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware\ndeb-src https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware\n\ndeb https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware\ndeb-src https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware\n\ndeb https://security.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware\ndeb-src https://security.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware" >> ${aptPath};

                # if [[ ${?} -eq 0 ]];
                # then
                    
                #     echo "Succeeded in adding back Debian repositories! :D";
                #     echo "Proceeding to final apt update && apt -y upgrade!! :D";

                    
                #     apt update && apt -y upgrade;

                #     if [[ ${?} -eq 0 ]];
                #     then
                #         echo "Succeeded in apt update && apt -y upgrade :D";
                #         echo "Proceeding to apt autoremove -y;";
                #         apt autoremove -y;
                #         if [[ ${?} -eq 0 ]];
                #         then
                #             echo "Succeeded in APT clean up :D";
                #             echo "apt update && apt -y upgrade again :D";
                #             apt update && apt -y upgrade;
                #             if [[ ${?} -eq 0 ]];
                #             then
                #                 echo "Final apt update && apt -y upgrade OK!";
                #             else
                #                 echo "Failed to last apt update && apt -y upgrade :(";
                #                 echo "You may manually perform apt update && apt -y upgrade";
                #             fi
                #         else
                #             echo "Failed to APT clean up :(";
                #             echo "You may apt autoremove -y manually";
                #         fi
                #     else
                #         echo "Failed to apt update && apt -y upgrade after adding back Debian repositories :(";
                #         echo "You may apt update && apt -y upgrade manually :D";                        
                #     fi   
                # else
                #     echo "Failed to add back Debian repositories :(";
                #     echo "You may manually add back those :)";
                # fi
                ##################################################
                # Exit with 0 after all processes have completed
                #################################################
                echo "Succeeded in completing this script";
                echo "Exiting with 0...";
                exit 0;

            else
                echo "We feel sorry that your Debian did NOT become a Kali Linux :(";
                # Terminate Customization here if failed to become a Kali linux
            fi

        else
            echo "Failed to customize this Debian repo to Kali repo...";
            echo "Exiting...";
        fi

    else
        echo "Failed to back up existing Apt repo";
        echo "Skipping Debian customization...";
    fi
else
    echo "You aren't ROOT";
    echo "Exiting...";
fi