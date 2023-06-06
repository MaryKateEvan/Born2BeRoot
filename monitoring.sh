#!/bin/bash

#Architecture and Kernel version
ARCH=$(uname -a)

#Number of physical processors
PHYS_PROCS=$(grep "physical id" /proc/cpuinfo | wc -l)

#Number of virtual processors
VIRT_PROCS=$(grep "processor" /proc/cpuinfo | wc -l)

#Current available RAM and % utilization rate
USED_RAM=$(free --mega | awk '$1 == "Mem:" {print $3}')
TOTAL_RAM=$(free --mega | awk '$1 == "Mem:" {print $2}')
RAM_UTIL_RATE=$(free --mega | awk '$1 == "Mem:" {printf("(%.2f%%)\n", ($3/$2)*100)}')

#Current available disk memory and % untilization rate
USED_DISK=$(df -m | grep "LVMG" | awk '{used_mem += $3} END {print used_mem}')
TOTAL_DISK=$(df -m | grep "LVMG" | awk '{total_mem += $2} END {printf("%dGb\n", total_mem/1024)}')
DISK_UTIL_RATE=$(df -m | grep "LVMG" | awk '{used += $3} {total += $2} END {printf("(%d%%)\n", (used/total)*100)}')

#CPU % utilization rate
CPU=$(vmstat 1 3 | tail -1 | awk '{printf("%.1f"), 100 - $15}')

#Date and time of last reboot
REBOOT=$(who -b | awk '{print $3 " " $4}')

#LVM status
LVM_STAT=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

#Active connections
TCP_CONS=$(ss -ta | grep "ESTAB" | wc -l)

#Number of users
USERS=$(users | wc -w)

#IPv4 and MAC address
IP_ADR=$(hostname -I)
MAC_ADR=$(ip link | grep "link/ether" | awk '{print $2}')

#Number of commands executed with sudo
SUDO_COMS=$(journalctl _COMM=sudo | grep "COMMAND" | wc -l)

wall "	#Architecture: $ARCH
	#CPU physical : $PHYS_PROCS
	#vCPU : $VIRT_PROCS
	#Memory Usage: $USED_RAM/${TOTAL_RAM}MB $RAM_UTIL_RATE
	#Disk Usage: $USED_DISK/${TOTAL_DISK} $DISK_UTIL_RATE
	#CPU load: $CPU%
	#Last boot: $REBOOT
	#LVM use: $LVM_STAT
	#Connections TCP : $TCP_CONS ESTABLISHED
	#User log: $USERS
	#Network: IP $IP_ADR ($MAC_ADR)
	#Sudo : $SUDO_COMS cmd "
	