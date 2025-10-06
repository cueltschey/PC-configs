while true; do
	date=$(date +'%A, %b %d')
	time=$(date +'%I:%M %p')
	level=$(cat /sys/class/power_supply/BAT0/capacity)
	status=$(cat /sys/class/power_supply/BAT0/status)

	[ "$status" = "Charging" ] && charge="🔋 $level%" || charge="⚡ $level%"
	echo "$date  $time  [ $charge ]"

	sleep 1
done
