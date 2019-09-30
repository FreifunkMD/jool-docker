#!/bin/sh
for ip in $V4IP
do
	jool -4 $i --mark $MARK_DEC
done

jool --pool6 $V6IP
jool --enable

exec joold /root/netsocket.json
