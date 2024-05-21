#!/bin/sh
set -e

#echo "root hints"

#wget -S https://www.internic.net/domain/named.cache -O /etc/unbound/root.hints

#echo "Unbound status..." && service unbound status
#echo "Starting 'unbound'..."

#unbound -c /etc/unbound/unbound.conf.d/unbound-local.conf
#service unbound start
#echo "Unbound status..." && service unbound status

echo "Launching adguard"

exec $@
