while true; do
	# $(cmd) stores the output of cmd
	date=$(date +'%A, %b %d')
	time=$(date +'%I:%M %p')
	level=$(cat /sys/class/power_supply/BAT1/capacity)
	status=$(cat /sys/class/power_supply/BAT1/status)

	if [ $status == "Charging" ]; then
		charge="🔋 $level%"
	else
		charge="⚡ $level%"
	fi
	# => Friday, Mar 05 | 03:47 PM
	weather=$(cat /tmp/weather)
	echo "$weather  | $date  |  $time  | $charge"
	sleep 1
done
