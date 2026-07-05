#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

if [ "$(id -u)" -eq 0 ]; then
	exec /usr/local/bin/roothide-tweaktool
fi

exec /usr/bin/sudo /usr/local/bin/roothide-tweaktool
