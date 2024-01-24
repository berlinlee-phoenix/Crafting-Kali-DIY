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

    # Update Debian login page to a less scary image
    # Download Anonymous .jpg
    anonymousImage='https://media.wnyc.org/i/800/0/l/85/1/we-are-anonymous.jpg'
    cd /home/${user}/Downloads && wget ${anonymousImage};
    if [[ ${?} -eq 0 ]];
    then
        anonymousImagePath="/home/${user}/Downloads/we-are-anonymous.jpg";
        echo "Succeeded in downloading Anonymous Image :D";
        echo "Proceeding to change Debian profile :D";
        # Change Debian profile image

    else
        echo "Failed to download Anonymous Image :(";
    fi

    # Update expired Kali Linux keys on a Debian12 base-build image
    echo "Adding expired Kali Linux keys on this Debian Linux plain build";
    
    # Updating expired Kali Linux keys
    addKey=$(wget https://archive.kali.org/archive-key.asc -O /etc/apt/trusted.gpg.d/kali-archive-keyring.asc);
    if [[ ${?} -eq 0 ]];
    then
        echo "Succeeded in updating Kali Linux keys!";
    else
        echo "Failed to update Kali Linux keys...";
        exit 1;
    fi

    # Backup existing Debian repository
    aptPath='/etc/apt/sources.list';
    aptBackup='/etc/apt/sources-backup.list';
    
    # Echo output of existing Apt Repository
    echo "Current Debian Apt Repository: ";
    cat ${aptPath};
    echo "Backup existing Apt repository before making it to Kali repo...";
    cp ${aptPath} ${aptBackup};
    if [[ ${?} -eq 0 ]];
    then
        echo "Succeeded in backing up existing Apt repo";
        echo "Proceeding to change Apt repo to Kali repo!";
        printf "deb https://http.kali.org/kali kali-rolling main non-free contrib\ndeb-src https://http.kali.org/kali kali-rolling main non-free contrib" > ${aptPath};
        if [[ ${?} -eq 0 ]];
        then
            echo "Succeeded in customizing this Debian repo to Kali repo!";
            echo "Proceeding to apt update && apt upgrade!";

            # apt update && apt upgrade
            apt-get update && apt-get -y upgrade;
            if [[ ${?} -eq 0 ]];
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
                else
                    echo "Failed to clean up ATPT trash :(";
                    echo "Let's try to do APT update => upgrade again";
                fi

                apt-get update && apt-get -y upgrade;
                if [[ ${?} -eq 0 ]];
                then
                    echo "Succeeded in apt-get update && apt-get -y upgrade";
                    echo "Proceeding 2nd time apt autoremove...";
                    apt autoremove -y;

                    if [[ ${?} -eq 0 ]];
                    then
                        echo "Succeeded in 2nd time APT clean up :D";
                        echo "Proceeding to install tones of Attack tools :D";
                    else
                        echo "Failed to clean up APT for 2nd time";
                        echo "You may manually APT clean up";
                    fi
                else
                    echo "Failed 2nd time to apt-get update && apt-get -y upgrade";
                    echo "No worries :) We'll try to breakthrough though :D";
                fi
            else
                echo "Failed to upgrade to Kali linux :(";
                exit 1;
            fi

            # 1st time apt update && apt -y upgrade 
            if [[ ${?} -eq 0 ]];
            then
                echo "Congrats! Your Debian has now become a Kali Linux now :D!";
                echo "Continuing to Install Open-source hacking tools :D!";

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
                        'openssh-server'
                        'tcpdump'
                        'docker.io'
                        'kaboxer'
                        'xdg-utils'
                        'vim'
                        '0trace'
                        'net-tools'
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
                        'airserv-ng'
                        'airodump-ng'
                        'airmon-ng'
                        'python3-dnspython'
                        'python3-termcolor'
                        'python3-tldextraact'
                        'altdns'
                        'libc6'
                        'amap'
                        'amass-common'
                        'libc6'
                        'amass'
                        'android-sdk-build-tools'
                        'android-sdk-common'
                        'android-sdk-platform-tools'
                        'proguard-cli'
                        'android-sdk'
                        'apache2-bin'
                        'apache2-data'
                        'apache2-utils'
                        'init-system-helpers'
                        'media-types'
                        'perl'
                        'procps'
                        'apache2'
                        'aapt'
                        'android-framework-res'
                        'default-jre-headless'
                        'ava8-runtime-headless'
                        'libantlr3-runtime-java'
                        'libcommons-cli-java'
                        'libcommons-io-java'
                        'libcommons-lang3-java'
                        'libcommons-text-java'
                        'libguava-java'
                        'libsmali-java'
                        'libstringtemplate-java'
                        'libxmlunit-java'
                        'libxpp3-java'
                        'libyaml-snake-java'
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
                        'atftp'
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
                        'aflplusplus'
                        'binutils'
                        'perl'
                        'sleuthkit'
                        'autopsy'
                        'libc6'
                        'libssl3'
                        'axel'
                        'kali-defaults'
                        'php-cli'
                        'b374k'

                        'curl'
                        'osslsigncode'
                        'python3'
                        'python3-capstone'
                        'python3-pefile'
                        'python3-pkg-resources'
                        'backdoor-factory'
                        'perl'
                        'bed'
                        'adduser'
                        'ruby-ansi'
                        'ruby-em-websocket'
                        'ruby-eventmachine'
                        'ruby-maxmind-db'
                        'ruby-otr-activerecord'
                        'ruby-rack'
                        'ruby-sinatra'
                        'ruby-term-ansicolor'
                        'ruby-xmlrpc'
                        'thin'
                        'lsof'
                        'ruby-async-dns'
                        'ruby-erubis'
                        'ruby-execjs'
                        'ruby-mime-types'
                        'ruby-parseconfig'
                        'ruby-rack-protection'
                        'ruby-slack-notifier'
                        'ruby-terser'
                        'ruby-zip'
                        'xdg-utils'
                        'ruby'
                        'ruby-dev'
                        'ruby-espeak'
                        'ruby-json'
                        'ruby-msfrpc-client'
                        'ruby-qr4r'
                        'ruby-rushover'
                        'ruby-sqlite3'
                        'ruby-twitter'
                        'rubygems-integration'
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
                        'debconf-2.0'
                        'libfstrm0'
                        'libmaxminddb0'
                        'libssl3'
                        'libxml2'
                        'zlib1g'
                        'bind9-libs'
                        'dns-root-data'
                        'libc6'
                        'libjson-c5'
                        'libnghttp2-14'
                        'libsystemd0'
                        'lsb-base'
                        'bind9-utils'
                        'init-system-helpers'
                        'libcap2'
                        'liblmdb0'
                        'libprotobuf-c1'
                        'libuv1'
                        'netbase'
                        'bind9'
                        'bind9-host'
                        'host'
                        'libedit2'
                        'libprotobuf-c1'
                        'bind9-libs'
                        'libidn2-0'
                        'libc6'
                        'libkrb5-3'
                        'bind9-dnsutils'
                        'bind9-libs'
                        'libc6'
                        'libidn2-0'
                        'bind9-host'
                        'libjemalloc2'
                        'liblmdb0'
                        'libprotobuf-c1'
                        'libuv1'
                        'libfstrm0'
                        'libjson-c5'
                        'libmaxminddb0'
                        'libssl3'
                        'libxml2'
                        'libgssapi-krb5-2'
                        'libkrb5-3'
                        'libnghttp2-14'
                        'liburcu8'
                        'zlib1g'
                        'bind9-libs'
                        'bind9-dnsutils'
                        'dnsutils'
                        'wget'
                        'bing-ip2hosts'
                        'python3-binwalk'
                        'binwalk'
                        'neo4j'
                        'bloodhound'
                        'bluez-test-scripts'
                        'libsqlite3-0'
                        'libruby3.1'
                        'ruby'
                        'blue-hydra'
                        'libbluetooth3'
                        'ieee-data'
                        'libbluetooth-dev'
                        'bluelog'
                        'blueranger'
                        'libbluetooth3'
                        'bluesnarfer'
                        'cups'
                        'libglib2.0-0'
                        'libdbus-1-3'
                        'bluez-hcidump'
                        'libglib2.0-0'
                        'libdbus-1-3'
                        'libjson-c5'
                        'libell0'
                        'libreadline8'
                        'bluez-meshd'
                        'init-system-helpers'
                        'libical3'
                        'libdbus-1-3'
                        'bluez-obexd'
                        'bluez-test-scripts'
                        'braa'
                        'libcryptsetup12'
                        'bruteforce-luks'
                        'bruteforce-salted-openssl'
                        'libdb5.3'
                        'bruteforce-wallet'
                        'libcap0.8'
                        'libgcc1'
                        'libstdc++6'
                        'libgssapi-krb5-2'
                        'zlib1g'
                        'bruteshark'
                        'medusa'
                        'brutespray'
                        'libncurses6'
                        'libinfo6'
                        'libxml2'
                        'btscanner'
                        'libgcc-s1'
                        'libewf2'
                        'libgcrypt20'
                        'libexpat1'
                        'libstdc++6'
                        'bulk-extractor'
                        'aircrack-ng'
                        'libpcap0.8'
                        'pixiewps'
                        'liblua5.3-0'
                        'bully'
                        'default-jre'
                        'java-wrappers'
                        'burpsuite'
                        'bytecode-viewer'
                        'capstone-tool'
                        'libcrypt1'
                        'ccrypt'
                        'certgraph'
                        'python3-dnspython'
                        'python3-ldap3'
                        'python3-pycryptodome'
                        'python3-unicrypto'
                        'python3-asn1crypto'
                        'python3-dsinternals'
                        'python3-openssl'
                        'python3-requests'
                        'python3-cryptography'
                        'python3-impacket'
                        'python3-pyasn1'
                        'python3-requests-ntlm'
                        'certipy-ad'
                        'ruby-mini-exiftool'
                        'ruby-spider'
                        'ruby-mime'
                        'ruby-net-http-digest-auth'
                        'ruby-zip'
                        'ruby-mime-types'
                        'ruby-nokogiri'
                        'cewl'
                        'python3-libnmap'
                        'python3-memcache'
                        'python3-paramiko'
                        'python3-pyodbc'
                        'python3-requests'
                        'python3-sqlalchemy'
                        'python3-cerberus'
                        'python3-logutils'
                        'python3-netaddr'
                        'python3-psycopg2'
                        'python3-pysnmp4'
                        'python3-selenium'
                        'python3-tabulate'
                        'python3-jinja2'
                        'python3-lxml'
                        'python3-nose'
                        'python3-pymongo'
                        'python3-redis'
                        'python3-shodan'
                        'python3-yaml'
                        'changeme'
                        'desktop-file-utils'
                        'libcairo2'
                        'libfmt9'
                        'libglib2.0-0'
                        'libgtk-3-0'
                        'libpango-1.0-0'
                        'libsqlite3-0'
                        'libvte-2.91-0'
                        'libatkmm-1.6-1v5'
                        'libcairomm-1.0-1v5'
                        'libfribidi0'
                        'libglibmm-2.4-1v5'
                        'libgtkmm-3.0-1v5'
                        'libpangomm-1.4-1v5'
                        'libstdc++6'
                        'libxml++2.6-2v5'
                        'libcurl4'
                        'libgcc-s1'
                        'libgspell-1-2'
                        'libgtksourceviewmm-3.0-0v5'
                        'libsigc++-2.0-0v5'
                        'libuchardet0'
                        'libxml2'
                        'cherrytree'
                        'python3-yattag'
                        'python3-future'
                        'python3-serial'
                        'wxpython-tools'
                        'python3-importlib-resources'
                        'python3-supported-min'
                        'python3-six'
                        'chirp'
                        'chisel'
                        'chkrootkit'
                        'chntpw'
                        'chromium-common'
                        'libatk1.0-0'
                        'libdbus-1-3'
                        'libevent-2.1-7'
                        'libfontconfig1'
                        'libjpeg62-turbo'
                        'libminizip1'
                        'libopenh264-7'
                        'libpango-1.0-0'
                        'libsnappy1v5'
                        'libwebpdemux2'
                        'libx11-6'
                        'libxdamage1'
                        'libxkbcommon0'
                        'libxrandr2'
                        'libasound2'
                        'libatomic1'
                        'libcairo2'
                        'libdouble-conversion3'
                        'libexpat1'
                        'libfreetype6'
                        'libglib2.0-0'
                        'libjsoncpp25'
                        'libnspr4'
                        'libopenjp2-7'
                        'libpng16-16'
                        'libwebpmux3'
                        'libxcb1'
                        'libxext6'
                        'libxslt1.1'
                        'libatk-bridge2.0-0'
                        'libatspi2.0-0'
                        'libcups2'
                        'libdrm2'
                        'libflac12'
                        'libgbm1'
                        'libgtk-3-0'
                        'xdg-desktop-portal-backend'
                        'liblcms2-2'
                        'libnss3'
                        'libopus0'
                        'libpulse0'
                        'libwebp7'
                        'libwoff1'
                        'libxcomposite1'
                        'libxfixes3'
                        'libxnvctrl0'
                        'zlib1g'
                        'chromium'
                        'cilium-cli'
                        'cisco-global-exploiter'
                        'cisco7crack'
                        'libnet-snmp-perl'
                        'libnet-ssh2-perl'
                        'libnet-telnet-perl'
                        'cisco-torch'
                        'cisco-ocs'
                        'python3-requests-futures'
                        'python3-dnspython'
                        'cloud-enum'
                        'cloudbrute'
                        'cmospwd'
                        'cmseek'
                        'cntlm'
                        'nodejs'
                        'code-oss'
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
                        'gcc-mingw-w64-x86-64-win32'
                        'libpcap0.8'
                        'libsqlite3-0'
                        'nasm'
                        'oracle-instantclient-basic'
                        'rake'
                        'wget'
                        'git'
                        'libffi8'
                        'libpq5'
                        'libssl3'
                        'nmap'
                        'postgresql'
                        'ruby'
                        'gcc-mingw-w64-i686-win32'
                        'john'
                        'libgcc-s1'
                        'libruby3.1'
                        'openssl'
                        'ruby-json'
                        'metasploit-framework'
                        'netbase'
                        'python3-scapy'
                        'libssl3'
                        'samdump2'
                        'libio-socket-inet6-perl'
                        'sendemail'
                        'python3-paramiko'
                        'python3-pil'
                        'python3-qrcode'
                        'ettercap-common'
                        'nginx'
                        'python3-impacket'
                        'python3-pefile'
                        'python3-pycryptodome'
                        'libapache2-mod-php'
                        'python3-openssl'
                        'openssl'
                        'python3-pexpect'
                        'python3-pymssql'
                        'upx-ucl'
                        'set'
                        'zlib1g'
                        'libssl3'
                        'siege'
                        'aapt'
                        'libantlr3-runtime-java'
                        'libcommons-lang3-java'
                        'libsmali-java'
                        'libxpp3-java'
                        'android-framework-res'
                        'libcommons-cli-java'
                        'libcommons-text-java'
                        'libstringtemplate-java'
                        'libyaml-snake-java'
                        'default-jre-headless'
                        'java8-runtime-headless'
                        'libcommons-io-java'
                        'libguava-java'
                        'libxmlunit-java'
                        'apktool'
                        'metasploit-framework'
                        'apache2-bin'
                        'init-system-helpers'
                        'procps'
                        'apache2-data'
                        'media-types'
                        'apache2-utils'
                        'apache2'
                        'libpcap0.8'
                        'libtcl8.6'
                        'hping3'
                        'httprobe'
                        'httpx-toolkit'
                        'libhttrack2'
                        'httrack'
                        'libcgi-pm-perl'
                        'hurl'
                        'publicsuffix'
                        'python3-fpdf'
                        'python3-colorama'
                        'python3-tldextract'
                        'humble'
                        'hubble'
                        'libapr1'
                        'libfbclient2'
                        'libidn12'
                        'libmongoc-1.0-0'
                        'libssh-4'
                        'libtinfo6'
                        'libbson-1.0-0'
                        'libfreerdp2-2'
                        'libmariadb3'
                        'libpcre2-8-0'
                        'libssl3'
                        'libwinpr2-2'
                        'libgcrypt20'
                        'libmemcached11'
                        'libpq5'
                        'libsvn1'
                        'hydra'
                        'libpcap0.8'
                        'tcpdump'
                        'tftp-hpa'
                        'smbclient'
                        'librtmp1'
                        'libidn2-0'
                        'libgnutls30'
                        'libcrypt1'
                        'libgssapi-krb5-2'
                        'libldap-2.5-0'
                        'sqsh'
                        'libgmp10'
                        'libhogweed6'
                        'libnettle8'
                        'samba-common-bin'
                        'winexe'
                        'passing-the-hash'
                        'libpcap0.8'
                        'irpas'
                        'peirates'
                        'python3-tld'
                        'python3-urllib3'
                        'python3-socks'
                        'photon'
                        'libapache2-mod-php8.2'
                        'libapache2-mod-php'
                        'default-jdk'
                        'javasnoop'
                        'libcurl4'
                        'zlib1g'
                        'curl'
                        'libicu72'
                        'libicu71'
                        'libicu70'
                        'libicu'
                        'libssl3'
                        'libssl1.1'
                        'libssl1.0.2'
                        'libssl'
                        'libstdc++6'
                        'libgssapi-krb5-2'
                        'libgcc1'
                        'libgssapi-krb5-2'
                        'libicu68'
                        'libicu67'
                        'libicu66'
                        'bicu65'
                        'libicu63'
                        'libicu60'
                        'libicu57'
                        'libicu55'
                        'libicu52'
                        'kali-defaults'
                        'powercat'
                        'default-mysql-server'
                        'python3-bcrypt'
                        'python3-donut'
                        'python3-flask'
                        'python3-jinja2'
                        'python3-macholib'
                        'python3-prompt-toolkit'
                        'python3-pydispatch'
                        'python3-pyparsing'
                        'python3-simplejson'
                        'python3-sqlalchemy-utc'
                        'python3-urllib3'
                        'python3-websockets'
                        'python3-xlutils'
                        'starkiller'
                        'python3-cryptography'
                        'python3-dropbox'
                        'python3-flask-socketio'
                        'python3-jose'
                        'python3-multipart'
                        'python3-packaging'
                        'python3-pycryptodome'
                        'python3-pyinstaller'
                        'python3-pyperclip'
                        'python3-secretsocks'
                        'python3-socketio'
                        'python3-terminaltables'
                        'python3-uvicorn'
                        'python3-websockify'
                        'python3-aiofiles'
                        'python3-docopt'
                        'python3-fastapi'
                        'python3-humanize'
                        'python3-jq'
                        'python3-netifaces'
                        'python3-passlib'
                        'python3-pydantic'
                        'python3-pymysql'
                        'python3-pyvnc'
                        'python3-setuptools'
                        'python3-sqlalchemy'
                        'python3-tk'
                        'python3-websocket'
                        'python3-xlrd'
                        'python3-zlib-wrapper'
                        'powershell-empire'
                        'powersploit'
                        'proxify'
                        'libgcc-s1'
                        'libpython3.11'
                        'libqt5widgets5'
                        'libstdc++6'
                        'proxmark3-firmwares'
                        'libbz2-1.0'
                        'libjansson4'
                        'libqt5core5a'
                        'libreadline8'
                        'libwhereami0'
                        'liblua5.2-0'
                        'libqt5gui5'
                        'libqt5gui5-gles'
                        'proxmark3-common'
                        'proxmark3'
                        'pgcli'
                        'python3-alembic'
                        'python3-autobahn'
                        'python3-bleach'
                        'python3-cryptography'
                        'python3-distro'
                        'python3-faraday-agent-parameters-types'
                        'python3-filteralchemy'
                        'python3-flask-kvsession'
                        'python3-flask-mail'
                        'python3-flask-sqlalchemy'
                        'python3-marshmallow'
                        'python3-pyasn1'
                        'python3-service-identity'
                        'python3-syslog-rfc5424-formatter'
                        'python3-twisted'
                        'python3-wtforms'
                        'xdg-utils'
                        'gir1.2-gtk-3.0'
                        'python3-apispec'
                        'python3-click'
                        'python3-cvss'
                        'python3-distutils'
                        'python3-faraday-plugins'
                        'python3-flask-limiter'
                        'python3-flask-principal'
                        'python3-flaskext.wtf'
                        'python3-marshmallow-sqlalchemy'
                        'python3-pil'
                        'python3-pyotp'
                        'python3-simplekv'
                        'python3-tornado'
                        'python3-webargs'
                        'zsh'
                        'gir1.2-vte-2.91'
                        'python3-apispec-webframeworks'
                        'python3-bidict'
                        'python3-dateutil'
                        'python3-email-validator'
                        'python3-filedepot'
                        'python3-flask-classful'
                        'python3-flask-login'
                        'python3-flask-socketio'
                        'python3-jwt'
                        'python3-nplusone'
                        'python3-psycopg2'
                        'python3-sqlalchemy-schemadisplay'
                        'python3-tqdm'
                        'python3-werkzeug'
                        'sudo'
                        'faraday'
                        'libmoose-perl'
                        'perl-tk'
                        'uniscan'
                        'libsmartcols1'
                        'libtinfo6'
                        'bsdextrautils'
                        'python3-sarge'
                        'python3-easygui'
                        'python3-wxgtk4.0'
                        'python3-pymetasploit3'
                        'kali-autopilot'
                        'python3-importlib-metadata'
                        'python3-supported-min'
                        'python3-setuptools-whl'
                        'python3-distlib'
                        'python3-pip-whl'
                        'python3-setuptools-whl'
                        'python3-distutils'
                        'python3-filelock'
                        'python3-platformdirs'
                        'python3-wheel-whl'
                        'python3-virtualenv'
                        'ca-certificates'
                        'python3-setuptools'
                        'python3-wheel'
                        'python3-distutils'
                        'python3-pip'
                        'snapd'
                        'libaudit1'
                        'libsmartcols1'
                        'util-linux-extra'
                        'libsmartcols1'
                        'libuuid1'
                        'init-system-helpers'
                        'libsystemd0'
                        'libuuid1'
                        'uuid-runtime'
                        'libsmartcols1'
                        'uuid-runtime'
                        'flashrom'
                        'cgpt'
                        'git'
                        'mono-mcs'
                        'wine'
                        'mingw-w64'
                        'python3-pycryptodome'
                        'unzip'
                        'veil'
                        'python3-pyperclip'
                        'python3-netifaces'
                        'villain'
                        'python3-pil'
                        'vinetto'
                        'libpcap0.8'
                        'voiphopper'
                        'vpnc-scripts'
                        'libgcrypt20'
                        'libgnutls30'
                        'vpnc'
                        'libio-socket-socks-perl'
                        'liburi-perl'
                        'webacoo'
                        'wce'
                        'python3-pycurl'
                        'python3-chardet'
                        'python3-pyparsing'
                        'python3-distutils'
                        'python3-six'
                        'wfuzz'
                        'python3-dev'
                        'python-is-python3'
                        'python-dev-is-python3'
                        'whatmask'
                        'ruby-interpreter'
                        'uby-addressable'
                        'ruby-ipaddress'
                        'whatweb'
                        'libcrypt1'
                        'libidn2-0'
                        'whois'
                        'aircrack-ng'
                        'screen'
                        'wifi-honey'
                        'cowpatty'
                        'iptables'
                        'python3-pbkdf2'
                        'python3-scapy'
                        'dnsmasq-base'
                        'python3-pyric'
                        'python3-tornado'
                        'hostapd'
                        'python3-roguehostapd'
                        'wifiphisher'
                        'hostapd'
                        'python3-bs4'
                        'python3-flask-restful'
                        'python3-dnslib'
                        'python3-loguru'
                        'python3-ping3'
                        'python3-termcolor'
                        'wireless-tools'
                        'python3-dhcplib'
                        'python3-isc-dhcp-leases'
                        'python3-netifaces'
                        'python3-pyqt5'
                        'python3-twisted'
                        'python3-aiofiles'
                        'python3-pyqt5.sip'
                        'python3-tabulate'
                        'python3-urwid'
                        'python3-pkg-resources'
                        'tshark'
                        'python3-chardet'
                        'reaver'
                        'wifite'
                        'python3-setproctitle'
                        'python3-impacket'
                        'python3-pcapy'
                        'wig-ng'
                        'windows-binaries'
                        'windows-privesc-check'
                        'libtevent0'
                        'libpopt0'
                        'samba-libs'
                        'libtalloc2'
                        'winexe'
                        'libcrypt1'
                        'wmi-client'
                        'wordlists'
                        'python3-pydotplus'
                        'wotmate'
                        'python3-geoip'
                        'python3-bs4'
                        'python3-geoip2'
                        'python3-pycurl'
                        'python3-cairocffi'
                        'python3-gi'
                        'xsser'
                        'libx11-6'
                        'xspy'
                        'libssl-dev'
                        'libmagic-dev'
                        'libjansson-dev'
                        'libyara10'
                        'libyara-dev'
                        'libpcap0.8'
                        'libtinfo6'
                        'libnet1'
                        'yersinia'
                        'gir1.2-gtk-3.0'
                        'python3-xdg'
                        'python3-gi'
                        'xdg-utils'
                        'zim'
                        'e2fsprogs'
                        'lynis'
                        'libglib2.0-0'
                        'libexpat1'
                        'rfdump'
                        'python3-pkg-resources'
                        'python3-netifaces'
                        'responder'
                        'libjs-sphinxdoc'
                        'python-requests-doc'
                        'gnupg'
                        'rephrase'
                        'libpython3.11'
                        'libgvc6'
                        'libqt5network5'
                        'librizin0'
                        'libcgraph6'
                        'libkf5syntaxhighlighting5'
                        'libqt5core5a'
                        'libqt5svg5'
                        'libshiboken2-py3-5.15'
                        'libgcc-s1'
                        'libpyside2-py3-5.15'
                        'libqt5gui5-gles'
                        'libqt5widgets5'
                        'rizin-cutter'
                        'rifiuti'
                        'rifiuti2'
                        'robotstxt'
                        'python3-filebytes'
                        'python3-capstone'
                        'ropper'
                        'libqt5script5'
                        'libqt5dbus5'
                        'libgcc-s1'
                        'libqt5widgets5'
                        'libqt5core5a'
                        'libqt5network5'
                        'routerkeygenpc'
                        'python3-pysnmp4'
                        'python3-paramiko'
                        'routersploit'
                        'rtpflood'
                        'libfindrtp'
                        'libnet1'
                        'rtpmixsound'
                        'libnet1'
                        'rtpinsertsound'
                        'libdumbnet1'
                        'libnet1'
                        'firewalk'
                        'kaboxer'
                        'docker.io'
                        'docker-ce'
                        'firefox-developer-edition-en-us-kbx'
                        'ffuf'
                        'fierce'
                        'libgcc-s1'
                        'fatcat'
                        'proxytunnel'
                        'lsb-base'
                        'libselinux1'
                        'ptunnel'
                        'debianutils'
                        'bsdutils'
                        'ucf'
                        'debconf-2.0'
                        'lsb-release'
                        'debconf '
                        'tiger'
                        'thc-pptp-bruter'
                        'thc-ssl-dos'
                        'python3-aiosqlite'
                        'python3-certifi'
                        'python3-fastapi'
                        'python3-pyppeteer'
                        'python3-shodan'
                        'python3-ujson'
                        'python3-aiohttp'
                        'python3-bs4'
                        'python3-dateutil'
                        'python3-lxml'
                        'python3-slowapi'
                        'python3-aiodns'
                        'python3-aiomultiprocess'
                        'python3-censys'
                        'python3-netaddr'
                        'python3-retrying'
                        'python3-starlette'
                        'python3-uvloop'
                        'theharvester'
                        'gnome-terminal'
                        'metasploit-framework'
                        'teamsploit'
                        'terraform'
                        'systemd'
                        'netbase'
                        'sysusers'
                        'systemd-sysusers'
                        'libsystemd0'
                        'libwrap0'
                        'stunnel4'
                        'libjson-c5'
                        'libnet1'
                        'ssldump'
                        'libboost-filesystem1.74.0'
                        'libgcc-s1'
                        'libboost-thread1.74.0'
                        'liblog4cpp5v5'
                        'libssl3'
                        'sslsniff'
                        'python3-twisted'
                        'sslstrip'
                        'libjs-sphinxdoc'
                        'python3-nassl'
                        'python3-pydantic'
                        'python3-tls-parser'
                        'python3-cryptography'
                        'python3-pkg-resources'
                        'python3-typing-extensions'
                        'sslyze'
                        'python3-magic'
                        'sqlmap'
                        'libio-socket-ip-perl'
                        'libnet-rawip-perl'
                        'libnet-dns-perl'
                        'libnetpacket-perl'
                        'libnet-pcap-perl'
                        'sqlninja'
                        'libnet-snmp-perl'
                        'libnumber-bytes-human-perl'
                        'ruby-snmp'
                        'snmpcheck'
                        'python3-termcolor'
                        'python3-impacket'
                        'python3-pyasn1'
                        'smbmap'
                        'mac-robber'
                        'libgdbm-compat4'
                        'dcraw'
                        'flac'
                        'libjpeg-turbo-progs'
                        'mpg123'
                        'zip'
                        'magicrescue'
                        'python3-nltk'
                        'python3-pandas'
                        'python3-vadersentiment'
                        'python3-cloudscraper'
                        'python3-matplotlib'
                        'python3-plotly'
                        'maryam'
                        'maltego'
                        'python3-easygui'
                        'python3-metaconfig'
                        'python3-adns'
                        'python3-levenshtein'
                        'python3-msgpack'
                        'python3-bs4'
                        'tmux'
                        'python3-mechanize'
                        'maltego-teeth'
                        'maskprocessor'
                        'masscan'
                        'massdns'
                        'golang-github-binject-go-donut-dev'
                        'golang-github-cretz-gopaque-dev'
                        'golang-github-mattn-go-shellwords-dev'
                        'golang-github-quic-go-qpack-dev'
                        'golang-golang-x-crypto-dev'
                        'golang-golang-x-sync-dev'
                        'golang-github-cheekybits-genny-dev'
                        'golang-github-fatih-color-dev'
                        'golang-github-ne0nd0g-ja3transport-dev'
                        'golang-github-satori-go.uuid-dev'
                        'golang-golang-x-exp-dev'
                        'golang-golang-x-sys-dev'
                        'golang-github-chzyer-readline-dev'
                        'golang-github-francoispqt-gojay-dev'
                        'golang-github-olekukonko-tablewriter-dev'
                        'golang-go.dedis-kyber-dev'
                        'golang-golang-x-net-dev'
                        'golang-gopkg-square-go-jose.v2-dev'
                        'golang-github-ne0nd0g-merlin-dev'
                        'merlin-agent'
                        'liblua5.4-0'
                        'ndiff'
                        'nmap-common'
                        'libpcap0.8'
                        'liblua5.4-0'
                        'libpcap0.8'
                        'liblinear4'
                        'libpcre2-8-0'
                        'nmap'
                        'nping'
                        'bind9-dnsutils'
                        'libqt5core5a'
                        'libqt5network5'
                        'libqt5webenginewidgets5'
                        'libqt5dbus5'
                        'libqt5qml5'
                        'libqt5widgets5'
                        'libgcc-s1'
                        'libqt5gui5'
                        'libqt5quick5'
                        'nmapsi4'
                        'statsprocessor'
                        'libterm-readline-gnu-perl'
                        'libdbd-sqlite3-perl'
                        'libhtml-linkextractor-perl'
                        'libwww-perl'
                        'liblwp-protocol-socks-perl'
                        'sqlsus'
                        'libqt5printsupport5'
                        'libsqlite3-0'
                        'libqt5core5a'
                        'libqt5gui5 '
                        'libqscintilla2-qt5-15'
                        'libqt5network5'
                        'libqt5xml5'
                        'sqlitebrowser'
                        'spire'
                        'spike'
                        'python3-cherrypy-cors'
                        'python3-gexf'
                        'python3-mako'
                        'python3-openpyxl'
                        'python3-pptx'
                        'python3-whois'
                        'python3-adblockparser'
                        'python3-cherrypy3'
                        'python3-docx'
                        'python3-ipwhois'
                        'python3-netaddr'
                        'python3-publicsuffixlist'
                        'python3-secure'
                        'python3-exifread'
                        'python3-networkx'
                        'python3-phonenumbers'
                        'python3-pypdf2'
                        'python3-socks'
                        'spiderfoot'
                        'python3-openpyxl'
                        'python3-torrequest'
                        'python3-certifi'
                        'python3-socks'
                        'python3-stem'
                        'sherlock'
                        'libio-socket-inet6-perl'
                        'sendemail'
                        'libsnmp40'
                        'libmariadb3'
                        'libsnmp-base'
                        'libnetsnmptrapd40'
                        'libsnmp-base'
                        'libsensors-dev'
                        'libwrap0-dev'
                        'libnetsnmptrapd40'
                        'libsnmp40'
                        'procps'
                        'libpci-dev'
                        'libssl-dev'
                        'libsnmp-dev'
                        'perlapi-5.36.0'
                        'libnetsnmptrapd40'
                        'libsnmp40'
                        'libsnmp-perl'
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
                        'libnl-genl-3-200'
                        'radiotap-library'
                        'libev4'
                        'libnl-route-3-200'
                        'libnl-3-200'
                        'owl'
                        'xterm'
                        'owasp-mantra-ff'
                        'default-jre'
                        'dirbuster'
                        'libnids1.21'
                        'libtirpc3'
                        'libdb5.3'
                        'libx11-6'
                        'libnet1'
                        'libxmu6'
                        'dsniff'
                        'python3-validators'
                        'emailharvester'
                        'ettercap-common'
                        'ettercap-graphical'
                        'libgdk-pixbuf-2.0-0'
                        'pkexec'
                        'libbsd0'
                        'libpcre2-8-0'
                        'libgtk-3-0'
                        'libc6'
                        'libtinfo6'
                        'ettercap-text-only'
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
                        'make'
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
                        'apt-transport-https' 
                        'software-properties-common' 
                        'lsb-release' 
                        'postgresql');

                # Iterate through $tools[@] && Install each tool
                for tool in ${tools[@]};
                do
                    echo "Installing tool: ${tool}";
                    installTools=$(apt install ${tool} -y);
                    if [[ ${?} -eq 0 ]];
                    then
                        echo "Succeeded in installing ${tool}";
                    else
                        echo "Failed to install ${tool}";
                    fi
                done

                userProfile=$(find / -name '.profile' 2>/dev/null | tail -n 1);
                copyProfile=$(cat ${userProfile} > /home/${user}/.profile);
                if [[ ${?} -eq 0 ]];
                then
                    echo "Succeeded in copying a normal user profile to ${user}'s profile";
                    echo "${user}'s profile is in /home/${user}/.profile";
                    echo "Content of ${user}'s .profile is:";
                    cat /home/${user}/.profile;
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
                    echo "Succeeded in updating SYS PATH :D!";
                else
                    echo "Failed to update SYS PATH :(";
                    echo "You have to update SYS PATH yourself :(";
                fi

                # Add back all Debian repositories after turning Debian into Kali
                printf "\n\ndeb https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware\ndeb-src https://ftp.debian.org/debian/ bookworm contrib main non-free non-free-firmware\n\ndeb https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware\ndeb-src https://ftp.debian.org/debian/ bookworm-updates contrib main non-free non-free-firmware\n\ndeb https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware\ndeb-src https://ftp.debian.org/debian/ bookworm-proposed-updates contrib main non-free non-free-firmware\n\ndeb https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware\ndeb-src https://ftp.debian.org/debian/ bookworm-backports contrib main non-free non-free-firmware\n\ndeb https://security.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware\ndeb-src https://security.debian.org/debian-security/ bookworm-security contrib main non-free non-free-firmware" >> ${aptPath};

                if [[ ${?} -eq 0 ]];
                then
                    echo "Succeeded in adding back Debian repositories! :D";
                    echo "Proceeding to final apt update && apt -y upgrade!! :D";
                    
                    apt update && apt -y upgrade;

                    if [[ ${?} -eq 0 ]];
                    then
                        echo "Succeeded in apt update && apt -y upgrade :D";
                        echo "Proceeding to apt autoremove -y;";
                        apt autoremove -y;
                        if [[ ${?} -eq 0 ]];
                        then
                            echo "Succeeded in APT clean up :D";
                            echo "apt update && apt -y upgrade again :D";
                            apt update && apt -y upgrade;
                            if [[ ${?} -eq 0 ]];
                            then
                                echo "Final apt update && apt -y upgrade OK!";
                            else
                                echo "Failed to last apt update && apt -y upgrade :(";
                                echo "You may manually perform apt update && apt -y upgrade";
                            fi
                        else
                            echo "Failed to APT clean up :(";
                            echo "You may apt autoremove -y manually";
                        fi
                    else
                        echo "Failed to apt update && apt -y upgrade after adding back Debian repositories :(";
                        echo "You may apt update && apt -y upgrade manually :D";                        
                    fi   
                else
                    echo "Failed to add back Debian repositories :(";
                    echo "You may manually add back those :)";
                fi
                ##################################################
                # Exit with 0 after all processes have completed
                #################################################
                echo "Succeeded in completing this script";
                echo "Exiting with 0...";
                exit 0;

            else
                echo "We feel sorry that your Debian did NOT become a Kali Linux :(";
                # Terminate Customization here if failed to become a Kali linux
                exit 1;
            fi

        else
            echo "Failed to customize this Debian repo to Kali repo...";
            echo "Exiting...";
            exit 1;
        fi

    else
        echo "Failed to back up existing Apt repo";
        echo "Skipping Debian customization...";
        exit 1;
    fi
else
    echo "You aren't ROOT";
    echo "Exiting...";
fi