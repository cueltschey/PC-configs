while true; do
  date=$(date +'%A, %b %d')
  time=$(date +'%I:%M %p')
  level=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
  status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
  [ -n "$level" ] && [ "$status" = "Charging" ] && charge="BAT $level%" || charge="BAT $level%"
  echo "$date  $time  [ $charge ]"
  sleep 1
done
