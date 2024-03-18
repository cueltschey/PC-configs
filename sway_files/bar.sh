while true; do
	# $(cmd) stores the output of cmd
	date=$(date +'%A, %b %d')
	time=$(date +'%I:%M %p')

	# => Friday, Mar 05 | 03:47 PM
	weather=$(cat /tmp/weather)
	echo "$weather | $date | $time"
	sleep 1
done
