#!/bin/sh
set -e

echo "root hints"

wget -S https://www.internic.net/domain/named.cache -O /etc/unbound/root.hints

echo "Starting 'unbound'..."

unbound -c /etc/unbound/unbound.conf.d/unbound-local.conf

echo "Launching adguard"

exec $@
