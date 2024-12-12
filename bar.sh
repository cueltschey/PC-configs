while true; do
	date=$(date +'%A, %b %d')
	time=$(date +'%I:%M %p')
	level=$(cat /sys/class/power_supply/BAT0/capacity)
	status=$(cat /sys/class/power_supply/BAT0/status)
	root_total=$(df -h | awk '$6 == "/"{print $4}')
	root_used=$(df -h | awk '$6 == "/"{print $5}')

	[ "$status" = "Charging" ] && charge="🔋 $level%" || charge="⚡ $level%"
	echo "Disk: [ $root_total $root_used ]  $date  $time  Battery: [ $charge ]"

	sleep 1
done
