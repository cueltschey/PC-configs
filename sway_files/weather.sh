while true; do
	# Get output silently, remove unwanted lines, reformat, output to temp file
	curl -s wttr.in/starkville?QT0 | grep -m 1 ' °F' | perl -pe 's/.*?\+(\d+2)(\(d+\))? °F.*$/$1$2 °F/' >/tmp/weather
	sleep 900
done
