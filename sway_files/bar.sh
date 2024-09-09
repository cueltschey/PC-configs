while true; do
	date=$(date +'%A, %b %d')
	time=$(date +'%I:%M %p')
	level=$(cat /sys/class/power_supply/BAT0/capacity)
	status=$(cat /sys/class/power_supply/BAT0/status)

	ps aux | grep "open" | grep -q "nrf" && open5gs="core: ✅" || open5gs="core: 🟥"
	ps aux | grep "gnb" | grep -q "\-c" && gnb="gnb: ✅" || gnb="gnb: 🟥"
	[ "$status" = "Charging" ] && charge="🔋 $level%" || charge="⚡ $level%"
	echo "$gnb  $open5gs  $date  $time  | $charge"
	sleep 1
done
