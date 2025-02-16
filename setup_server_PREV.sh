#!/bin/bash
# Created by Roel Van de Paar, Percona LLC

echo "Initial Setup Reminders (based on Centos minimal cd install):"
echo "-------------------------------------------------------------"
echo "Syntax:    {variable} needs replacing with your specific configuration, for example {your_port} becomes 22"
echo "SSHD:      follow http://www.cyberciti.biz/faq/centos-ssh/ except;"
echo "           Set port to new number in sshd_config and add this line instead in iptables (adjust port, and adjust your subnet if needed);"
echo "             -A INPUT -s 192.168.0.0/24 -m state --state NEW -m tcp -p tcp --dport {your_port} -j ACCEPT"
echo "           Note there is likely a similar line there already that needs removing"
echo "User:      useradd {username} -m -U; su passwd {username}"
echo "Disk:      use parted for partition management, fdisk -l for partition list"
echo "Net:       set ONBOOT=yes and BOOTPROTO=dhcp in /etc/sysconfig/network-scripts/ifcfg-eth0 if using Centos minimal install CD"
echo "           also set NETWORKING=yes /etc/sysconfig/network and set a HOSTNAME={your_host_name}.{your_domain_name} in /etc/sysconfig/network"
echo "Sudo:      # visudo (or sudo visudo), then add this line:"
echo "             {username}            ALL=(ALL)       NOPASSWD: ALL"
echo "fstab:     /dev/sdd	/ssd	/ext4    noatime,nodiratime,discard,errors=remount-ro	0 2      # use fdisk -l | mkfs.ext4"
echo "Packages:  remember you can search available packages using 'yum search <string>', which will search all package names for that <string>"
echo "Git:       to get this script to continue setting up a server once this initial setup is done, use:"
echo "           sudo yum install git; cd ~; git clone --depth=1 https://github.com/mariadb-corporation/mariadb-qa.git; cd mariadb-qa; ./setup_server.sh"
echo "Git setup: [Optional] to configure git for uploading code, follow the information in handy_gnu.txt"
echo ""
echo "As for the setup & tuning this script does:"
echo "-------------------------------------------"
echo "This script makes major changes to any machine it is executed on (installs packages, enables core files, changes significant security settings etc.)."
echo "Please review the planned changes by reviewing the script contents. All of the changes in the script prepare this machine to be a proper QA server."
echo "This script is meant for use on Centos (6.x mainly). Make sure that you want to continue. Hit CTRL+C to abort now, or press enter twice to continue..."
echo "Please note this script removes pulseaudio drivers. If you are using a desktop/would like to keep pulseaudio, please remark the line in the script first."
echo "Finally, this script can be executed multiple times without doubling up configurations/without messing up anything. It was specifically coded for this."
echo "This script requires sudo and su commands to be availabe already. Use visudo as described above (in 'Sudo:') to add yourself to sudo list (faster run)."
echo "This script is provided AS-IS with no warranty of any kind. Do NOT run on production machines. This script lowers the servers security. Use at own risk."
read -p "Hit enter or CTRL-C now:"
read -p "Hit enter or CTRL-C now:"

# EPEL
if [ -z "$(yum list | grep 'epel-release.noarch')" ]; then
  sudo yum install epel-release
  #if (uname -a | grep -q "el7"); then
  #  sudo su -c 'rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm'
  #elif (uname -a | grep -q "el6"); then
  #  sudo su -c 'rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm'
  #fi
fi

# Set CPU Governor to Performance. This makes sense on for example a regularly used QA server or a performance testing box
# Consider; electricity/power and heating. To do so, see the following document especially under 'cpufreq_powersave';
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/power_management_guide/cpufreq_governors
# sudo cpupower frequency-set --governor performance
# cat /sys/devices/system/cpu/intel_pstate/*  # Should read 100,100,[0]
# cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor  # Should read "performance"

# SCLo SIG
# https://wiki.centos.org/SpecialInterestGroup/SCLo
# https://centos.pkgs.org/7/centos-sclo-rh/devtoolset-7-gcc-c++-7.2.1-1.el7.x86_64.rpm.html
# https://github.com/sclorg/centos-release-scl
# https://www.centos.org/keys/  # You can check the SIG key here
if [ -z "$(yum list | grep 'centos-release-scl-rh')" ]; then
  sudo yum install centos-release-scl-rh
  # sudo yum install devtoolset-7-gcc-c++  - install gcc 7 and near-latest binutils
fi

# EPEL - Debuginfo packages enable (gives lots of output, but basically just sets 'enabled=1' in /etc/yum.repos.d/epel.repo for [epel-debuginfo] section
sudo yum-config-manager --enable epel-debuginfo

# Software
# libssh (Centos) / libssh-dev (Ubuntu) was added here (27/02/17). Though not strictly needed, seemed like a good lib to have.
# If it causes issues, please remove it again.
# Temporary removed sysbench from the list as it causes issues on Centos7 - see https://bugs.launchpad.net/sysbench/+bug/1340092
sudo yum install kernel-devel wget patch make cmake automake autoconf bzr git htop man lsof gdb \
     gcc gcc-c++ ncurses-devel ncurses-devel-5* libtool libaio libaio-devel bison libcurl-devel \
     valgrind perl-DBD-mysql perl-Time-HiRes cpan bzip2 valgrind-devel svn strace screen \
     hdparm pam-devel openssl openssl-devel gtest zlib zlib-devel zlib-static tree vim libasan \
     yum-utils readline-devel lshw lscpu iotop pymongo bats lzma lzma bzip2-devel snappy-dev \
     boost-devel lz4-devel gflags-devel xz jemalloc jemalloc-devel jemalloc-debuginfo libssh \
     fail2ban libz-dev libgcrypt20 libgcrypt20-dev libssl-dev libboost-all-dev valgrind \
     python-mysqldb mdm clang libasan5 clang-format

sudo yum remove abrt  # abrt: see redhat solution 61536 linked below in core file section (otherwise core_pattern setting will not work)
sudo yum remove pulseaudio*  # Only do this on servers, to avoid writing of pulse* files into /dev/shm. Best to leave on workstations (for audio)

# Apt-get equivalent
# Ubuntu 16.10
#sudo apt-get install build-essential man-db wget patch make cmake automake autoconf bzr git htop lsof gdb gcc libtool bison valgrind strace screen hdparm openssl tree vim yum-utils lshw iotop bats lzma lzma-dev git linux-headers-generic g++ ncurses-dev libncurses-dev libaio1 libaio-dev libjemalloc1 libjemalloc-dev libdbd-mysql libtime-hires-perl libssl-dev subversion libgtest-dev zlib1g zlib1g-dbg zlib1g-dev libasan1 libreadline6 libreadline6-dbg libreadline6-dev debhelper devscripts pkg-config dpkg-dev lsb-release terminator libpam0g-dev libbz2-dev libsnappy-dev libboost-all-dev liblz4-dev libgflags-dev libcurl4-openssl-dev libssh-dev
# Ubuntu 17.04
#sudo apt-get install build-essential man-db wget patch make cmake automake autoconf bzr git htop lsof gdb gcc libtool bison valgrind strace screen hdparm openssl tree vim yum-utils lshw iotop bats lzma lzma-dev git linux-headers-generic g++ libncurses5-dev libaio1 libaio-dev libjemalloc1 libjemalloc-dev libdbd-mysql libperl5.24 libssl-dev subversion libgtest-dev zlib1g zlib1g-dbg zlib1g-dev libasan1 libreadline-dev libreadline6-dbg libreadline6-dev debhelper devscripts pkg-config dpkg-dev lsb-release terminator libpam0g-dev libcurl4-openssl-dev libssh-dev fail2ban libz-dev libgcrypt20 libgcrypt20-dev libssl-dev libboost-all-dev valgrind python-mysqldb mdm clang libasan5 clang-format libbz2-dev
# Ubuntu 17.10
#sudo apt-get install build-essential man-db wget patch make cmake automake autoconf bzr git htop lsof gdb gcc libtool bison valgrind strace screen hdparm openssl tree vim yum-utils lshw iotop bats lzma lzma-dev git linux-headers-generic g++ libncurses5-dev libaio1 libaio-dev libjemalloc1 libjemalloc-dev libdbd-mysql libssl-dev subversion libgtest-dev zlib1g zlib1g-dbg zlib1g-dev libreadline-dev libreadline6-dbg libreadline6-dev debhelper devscripts pkg-config dpkg-dev lsb-release terminator libpam0g-dev libcurl4-openssl-dev libssh-dev fail2ban libz-dev libgcrypt20 libgcrypt20-dev libssl-dev libboost-all-dev valgrind python-mysqldb mdm clang libasan5 clang-format libbz2-dev
# Ubuntu 18.04 (same as 17.10 without libreadline6-dbg)
# For 18.04 (Bionic) you may also want to do this; https://sites.google.com/site/easylinuxtipsproject/swappiness - use 1 instead of 10 if you have SSD disks. Basically sudo vi /etc/sysctl.conf and add this line: vm.swappiness=1 then reboot and check with cat /proc/sys/vm/swappiness
# sudo apt-get install build-essential man-db wget patch make cmake automake autoconf bzr git htop lsof gdb gcc libtool bison valgrind strace screen hdparm openssl tree vim yum-utils lshw iotop bats lzma lzma-dev git linux-headers-generic g++ libncurses5-dev libaio1 libaio-dev libjemalloc1 libjemalloc-dev libdbd-mysql libssl-dev subversion libgtest-dev zlib1g zlib1g-dbg zlib1g-dev libreadline-dev libreadline7-dbg debhelper devscripts pkg-config dpkg-dev lsb-release terminator libpam0g-dev libcurl4-openssl-dev libssh-dev fail2ban libz-dev libgcrypt20 libgcrypt20-dev libssl-dev libboost-all-dev valgrind python-mysqldb mdm clang libasan5 clang-format libbz2-dev gnutls-dev

# Facebook MTR test support (https://github.com/facebook/mysql-5.6/wiki/Build-Steps)
#sudo apt-get install -y python python-mysqldb
#sudo apt-get install -y libdbd-mysql libdbi-perl libdbd-mysql-perl

# Bash Profile
if [ -z "$(cat ~/.bash_profile|grep 'pshugD')" ]; then
  echo 'alias tree="tree -pshugD"' >> ~/.bash_profile
fi
if ! egrep -qi "CDPATH=" ~/.bash_profile; then
  echo "export CDPATH=.:~:/ssd" >> ~/.bash_profile
fi

# GDB Script
touch ~/.gdbinit
if [ -z "$(cat ~/.gdbinit|grep 'print elements')" ]; then cat << EOF > ~/.gdbinit
# Next line avoids libary loading issues/manual work, see: bash$ info "(gdb)Auto-loading safe path" (do not add anything after "/" on next line, even comments)
set auto-load safe-path /
# [Temporarily/Permanently] disabled; it should not use /usr/lib/ but /lib64, and it seems to cause issues with thread debugging lib loading (warnings at start)
#                                     also see http://stackoverflow.com/questions/11585472/unable-to-debug-multi-threaded-application-with-gdb
# See http://sourceware.org/gdb/onlinedocs/gdb/Threads.html - this avoids the following warning:
# "warning: unable to find libthread_db matching inferior's threadlibrary, thread debugging will not be available"
#set libthread-db-search-path /usr/lib/
set trace-commands on
set pagination off
set print pretty on
set print array on
set print array-indexes on
set print elements 1500
EOF
fi

# Screen Script
touch ~/.screenrc
if [ -z "$(cat ~/.screenrc|grep 'termcapinfo xterm')" ]; then cat << EOF > ~/.screenrc
# General settings
vbell on
vbell_msg '!Bell!'
autodetach on
startup_message off
defscrollback 10000

# Termcapinfo for xterm
termcapinfo xterm* Z0=\E[?3h:Z1=\E[?3l:is=\E[r\E[m\E[2J\E[H\E[?7h\E[?1;4;6l   # Do not resize window
termcapinfo xterm* OL=1000                                                    # Increase output buffer for speed

# Remove various keyboard bindings
bind x    # Do not lock screen
bind ^x   # Idem
bind h    # Do not write out copy of screen to disk
bind ^h   # Idem
bind ^\   # Do not kill all windows/exit screen
bind .    # Disable dumptermcap

# Add keyboard bindings
bind } history
bind k kill
EOF
fi

# Python (for LP API)
sudo yum install python python-pip
sudo pip install launchpadlib

# Corefiles & system limits (fs.aio-max-nr/fs.file-max) for reducer
#https://www.kernel.org/doc/Documentation/sysctl/fs.txt     (good suid_dumpable info)
#http://www.mysqlperformanceblog.com/2011/08/26/getting-mysql-core-file-on-linux/
#https://www.mail-archive.com/linux-390@vm.marist.edu/msg60338.html
#https://access.redhat.com/site/solutions/61536
if [ "$(grep -m1 'kernel.core_pattern=core.%p.%u.%g.%s.%t.%e' /etc/sysctl.conf)" != 'kernel.core_pattern=core.%p.%u.%g.%s.%t.%e' ]; then
  sudo bash -c 'echo "kernel.core_pattern=core.%p.%u.%g.%s.%t.%e" >> /etc/sysctl.conf'
fi
if [ "$(grep -m1 'suid_dumpable=1' /etc/sysctl.conf)" != 'fs.suid_dumpable=1' ]; then
  sudo bash -c 'echo "fs.suid_dumpable=1" >> /etc/sysctl.conf'
fi
if [ "$(grep -m1 'fs.aio-max-nr=300000' /etc/sysctl.conf)" != 'fs.aio-max-nr=1048576' ]; then
  sudo bash -c 'echo "fs.aio-max-nr=300000" >> /etc/sysctl.conf'
fi
if [ "$(grep -m1 '* soft core unlimited' /etc/security/limits.conf)" != '* soft core unlimited' ]; then
  sudo bash -c 'echo "* soft core unlimited" >> /etc/security/limits.conf'
fi
if [ "$(grep -m1 '* hard core unlimited' /etc/security/limits.conf)" != '* hard core unlimited' ]; then
  sudo bash -c 'echo "* hard core unlimited" >> /etc/security/limits.conf'
fi
# With all disabled settings below, it is likely that only one of them caused the original system hangs
#if [ "$(grep -m1 'fs.file-max=6815744' /etc/sysctl.conf)" != 'fs.file-max=6815744' ]; then  # May cause system hangs on Centos7?
#  sudo bash -c 'echo "fs.file-max=6815744" >> /etc/sysctl.conf'
#fi
# Do not increase nofile soft/hard limit beyond 1048576, unless you want serious Linux authentication/login issues.
#if [ "$(grep -m1 '* soft nofile 1048576' /etc/security/limits.conf)" != '* soft nofile 1048576' ]; then
#  sudo bash -c 'echo "* soft nofile 1048576" >> /etc/security/limits.conf'
#fi
if [ "$(grep -m1 '* hard nofile 1048576' /etc/security/limits.conf)" != '* hard nofile 1048576' ]; then
  sudo bash -c 'echo "* hard nofile 1048576" >> /etc/security/limits.conf'
fi
if [ "$(grep -m1 '* soft stack 20480' /etc/security/limits.conf)" != '* soft stack 20480' ]; then
  sudo bash -c 'echo "* soft stack 20480" >> /etc/security/limits.conf'
fi
if [ "$(grep -m1 '* hard stack 20480' /etc/security/limits.conf)" != '* hard stack 20480' ]; then
  sudo bash -c 'echo "* hard stack 20480" >> /etc/security/limits.conf'
fi
if [ "$(grep -m1 '* soft nproc 300000' /etc/security/limits.conf)" != '* soft nproc 300000' ]; then  # Previously; 1048576. May cause system hangs on Centos7? Was then reduced to 20480. Readjusted to 300000 as it seems that (in Bionic) the number of processes allowed accross various opened shells is cumulative.
  sudo bash -c 'echo "* soft nproc 300000" >> /etc/security/limits.conf'
fi
if [ "$(grep -m1 '* hard nproc 300000' /etc/security/limits.conf)" != '* hard nproc 300000' ]; then  # Previously; 1048576. May cause system hangs on Centos7? Was then reduced to 20480. Readjusted to 300000 as it seems that (in Bionic) the number of processes allowed accross various opened shells is cumulative.
  sudo bash -c 'echo "* hard nproc 300000" >> /etc/security/limits.conf'
fi
#if [ "$(grep -m1 '* soft memlock 128' /etc/security/limits.conf)" != '* soft memlock 128' ]; then  # May cause system hangs on Centos7?
#  sudo bash -c 'echo "* soft memlock 128" >> /etc/security/limits.conf'
#fi
#if [ "$(grep -m1 '* hard memlock 128' /etc/security/limits.conf)" != '* hard memlock 128' ]; then  # May cause system hangs on Centos7?
#  sudo bash -c 'echo "* hard memlock 128" >> /etc/security/limits.conf'
#fi
if [ "$(grep -m1 'DAEMON_COREFILE_LIMIT' /etc/sysconfig/init)" != "DAEMON_COREFILE_LIMIT='unlimited'" ]; then
  sudo bash -c 'echo "DAEMON_COREFILE_LIMIT='"'unlimited'"'" >> /etc/sysconfig/init'
fi

# Ensuring nproc limiter is gone or not present
if [ -r /etc/security/limits.d/90-nproc.conf ]; then
  sudo rm -f /etc/security/limits.d/90-nproc.conf
  if [ -r /etc/security/limits.d/90-nproc.conf ]; then
    echo "Tried to remove the file /etc/security/limits.d/90-nproc.conf (to enable raising of nproc) without succes. Exiting prematurely."
    exit 1
  fi
fi

# Hugepage Checks
THP1='/sys/kernel/mm/transparent_hugepage'
THP2='/sys/kernel/mm/redhat_transparent_hugepage'
THP1_STR1="echo never > ${THP1}/enabled"; THP1_STR2="echo never > ${THP1}/defrag"
THP2_STR1="echo never > ${THP2}/enabled"; THP2_STR2="echo never > ${THP2}/defrag"
# This needs further work (though it works on both RHEL/Centos 6 and 7) - requires a reboot on 6 ftm.
# * Centos 6.3 also has /etc/rc.d/rc.local?
# * The auto-restart of rc-local can also be done on RHEL6/Centos6
if [ -r ${THP1} ] ; then  # THP present
  if (uname -a | grep -q "el7"); then  # RHEL7/Centos7
    if [ "$(grep -m1 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' /etc/rc.d/rc.local)" != "${THP1_STR1}" ]; then
      sudo bash -c "echo '${THP1_STR1}' >> /etc/rc.d/rc.local"
      sudo bash -c "echo '${THP1_STR2}' >> /etc/rc.d/rc.local"
      sudo chmod 744 /etc/rc.d/rc.local
      sudo systemctl restart rc-local.service
    fi
  else
    if [ "$(grep -m1 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' /etc/rc.local)" != "${THP1_STR1}" ]; then
      sudo bash -c "echo '${THP1_STR1}' >> /etc/rc.local"
      sudo bash -c "echo '${THP1_STR2}' >> /etc/rc.local"
    fi
  fi
else  # THP not present
  if [ -r ${THP2} ]; then  # redhat_THP present
    if (uname -a | grep -q "el7"); then  # RHEL7/Centos7
      if [ "$(grep -m1 'echo never > /sys/kernel/mm/redhat_transparent_hugepage' /etc/rc.d/rc.local)" != "${THP2_STR1}" ]; then
        sudo bash -c "echo '${THP2_STR1}' >> /etc/rc.d/rc.local"
        sudo bash -c "echo '${THP2_STR2}' >> /etc/rc.d/rc.local"
        sudo chmod 744 /etc/rc.d/rc.local
        sudo systemctl restart rc-local.service
      fi
    else
      if [ "$(grep -m1 'echo never > /sys/kernel/mm/redhat_transparent_hugepage' /etc/rc.local)" != "${THP2_STR1}" ]; then
        sudo bash -c "echo '${THP2_STR1}' >> /etc/rc.local"
        sudo bash -c "echo '${THP2_STR2}' >> /etc/rc.local"
      fi
    fi
  else  # THP nor redhat_THP present
    echo "Error: neither /sys/kernel/mm/transparent_hugepage/enabled nor /sys/kernel/mm/redhat_transparent_hugepage/enabled was found. Exiting prematurely."
    echo "If you are running this script on a non-Centos/Redhat OS, please find the correct transparent_hugepage file for your system and update the script."
    exit 1
  fi
fi

echo "Post Install Suggestions"
echo "------------------------"
echo "RQG modules:   Use the following command to install all required perl modules (assuming this script was executed first):"
echo "                 sudo perl -MCPAN -e 'shell'"
echo "                  cpan[1]> install Test::More Digest::MD5 Log::Log4perl XML::Writer DBIx::MyParsePP Statistics::Descriptive JSON Test::Unit"
echo "               After this, re-execute the same command once more to see if all modules installed properly"
echo "RQG mysqldump: sudo cp /ssd/Percona-Server/bin/mysqldump /usr/bin/ to avoid issues with RQG not finding mysqldump"
echo "Other items:   See above 'initial information' shown at the start of this script's execution"
