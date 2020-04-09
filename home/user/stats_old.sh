#!/bin/bash
cpulasttotal=0
cpulastidle=0

mapfile -t netdev < /proc/net/dev
i=0
for line in "${netdev[@]}"; do
	IFS=' ' read -a netdevline <<< $line
	if [[ ${netdevline[0]} != 'lo:' && ${netdevline[9]} != '0' ]]; then
		netdevice=$i
	fi
	((i++))
done

for cputempdevice in /sys/class/hwmon/*; do
	cputempname=$(<$cputempdevice/name);
	if [[ $cputempname == 'coretemp' || $cputempname == 'it87'* || $cputempname == 'nct6775' || $cputempname == 'k8temp' || $cputempname == 'k9temp' ]]; then
		break;
	fi
done

if [[ ! -f /sys/class/power_supply/AC/online ]]; then
	acdev='N/A'
fi

if [[ ! -f /sys/class/power_supply/BAT0/capacity ]]; then
	battery='N/A'
fi

if compgen -G /sys/class/backlight/* > /dev/null; then
	backlightdevice=(/sys/class/backlight/*)
	backlightdevice=${backlightdevice[-1]}
else
	brightness='N/A'
fi

if [[ -f ~/.asoundrc ]]; then
	read alsadevice < ~/.asoundrc
	alsadevice=${alsadevice/defaults.pcm.card /}
	if [ $alsadevice -eq $alsadevice ] 2> /dev/null; then
		:
	else
		alsadevice=0
	fi
else
	alsadevice=0
fi
i=0
if [[ -f /proc/asound/card$alsadevice/codec#0 ]]; then
	while read line; do
	if [[ $line == 'Amp-Out vals:  '* ]]; then
		alsaline=$i
		break
	fi
	((i++))
	done < /proc/asound/card$alsadevice/codec#0
else
	volume='N/A'
fi

while :
do
system=$(</proc/version)
system=${system%% (*}
system=${system/ version/}

uptime=$(</proc/uptime)
uptime=${uptime%%.*}
hrs=$((uptime/3600))
min=$((uptime/60%60))
if [[ ${#min} -eq 1 ]]; then
	min=0$min
fi
uptime="$hrs:$min"

processes=1
for line in /proc/[0-9]*; do
	((processes++))
done

mapfile -t procstat < /proc/stat
activeprocesses=${procstat[-3]}
activeprocesses=${activeprocesses:14}

IFS=' ' read -a cpustats <<< ${procstat[0]}
cpustats=(${cpustats[@]:1})
cpuidle=${cpustats[3]}
cputotal=0
for i in "${cpustats[@]}"; do
	cputotal=$(($cputotal+$i))
done
cpuusage=$(((1000*(($cputotal-$cpulasttotal)-($cpuidle-$cpulastidle))/($cputotal-$cpulasttotal)+5)/10))%
cpulasttotal=$cputotal
cpulastidle=$cpuidle

mapfile -t meminfo < /proc/meminfo
memory[0]=${meminfo[0]} #memtotal
memory[1]=${meminfo[1]} #memfree
memory[2]=${meminfo[3]} #buffers
memory[3]=${meminfo[4]} #cached
memory[4]=${meminfo[20]} #shmem
memory[5]=${meminfo[22]} #sreclaimable
for ((i=0; i<=5; i++)); do
	memory[$i]=${memory[i]#* };
	memory[$i]=${memory[i]:0:-3
};
done
memused=$((${memory[0]}+${memory[4]}-${memory[1]}-${memory[2]}-${memory[3]}-${memory[5]}));
meminfo="$(($memused/1024)) MiB / $((${memory[0]}/1024)) MiB"

mapfile -t netdev < /proc/net/dev
IFS=' ' read -a netdev <<< ${netdev[$netdevice]}
netin=$((${netdev[1]}/1048576))\ MiB
netout=$((${netdev[9]}/1048576))\ MiB

if [[ $acdev != 'N/A' ]]; then
	ac=$(</sys/class/power_supply/AC/online)
	if [[ $ac == '1' ]]; then
		ac='Y'
	else
		ac='N'
	fi
else
	ac='Y'
fi

temp=$(<$cputempdevice/temp1_input)
temp=${temp:0:-3}C

if [[ $volume != 'N/A' ]]; then
mapfile -t asound < /proc/asound/card$alsadevice/codec#0
	volume=${asound[$alsaline]}
	volume=${volume:20:2}
	volume=$((16#$volume))%
fi

if [[ $battery != 'N/A' ]]; then
	battery=$(</sys/class/power_supply/BAT0/capacity)%
fi

if [[ $brightness != 'N/A' ]]; then
	brightness=$(($(<$backlightdevice/actual_brightness)*100/$(<$backlightdevice/max_brightness)))%
fi

mapfile -t signal -ra signal < /proc/net/wireless
if [[ ${#signal[@]} -gt 2 ]]; then
	signal=${signal[2]}
	IFS=' ' read -a signal <<< $signal
	signal=${signal[2]}
	signal=${signal:0:-1}
	signal=$((signal*100/70))%
else
	signal='N/A'
fi

date=$(printf '%(%c)T')

clr1='\e[37m'
clr2='\e[32m'

echo -ne "\e[?25l$clr1$system Up: $clr2$uptime$clr1 Proc: $clr2$processes$clr1 Active: $clr2$activeprocesses$clr1 Cpu: $clr2$cpuusage$clr1 Mem: $clr2$meminfo$clr1 Net in: $clr2$netin$clr1 Net out: $clr2$netout$clr1 AC: $clr2$ac$clr1 Temp: $clr2$temp$clr1 Volume: $clr2$volume$clr1 Battery: $clr2$battery$clr1 Brightness: $clr2$brightness$clr1 Wifi: $clr2$signal$clr1 $date        \r"

sleep 2
done
