#!/bin/sh

xcompmgr -c -C -t-5 -l-5 -r4.2 -o.55 &
feh --bg-scale /home/delta/pictures/bg.jpg

_test() {
#	echo -e '\uE015'
	echo "$(date)"
}

xset +fp /usr/share/fonts/local
xset +fp /usr/share/fonts/gao
xset +fp /usr/share/fonts/terminus
xset fp rehash

while true; do
	xsetroot -name "$(_test)"
	sleep 1
done &
exec dwm
