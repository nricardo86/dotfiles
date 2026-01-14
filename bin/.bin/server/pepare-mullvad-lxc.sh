#!/usr/bin/env bash
chown 100000:100000 /dev/net/tun
mkdir -p /tmp/net-cls-v1
mount -t cgroup -o net_cls none /tmp/net-cls-v1
chown -R 100000:100000 /tmp/net-cls-v1
