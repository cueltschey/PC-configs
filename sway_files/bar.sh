while true; do
	# $(cmd) stores the output of cmd
	date=$(date +'%A, %b %d')
	time=$(date +'%I:%M %p')
	level=$(cat /sys/class/power_supply/BAT0/capacity)
	status=$(cat /sys/class/power_supply/BAT0/status)

	if [ "$status" = "Charging" ]; then
		charge="🔋 $level%"
	else
		charge="⚡ $level%"
	fi
	echo " $date  $time  | $charge"
	sleep 1
done
