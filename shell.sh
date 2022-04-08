#!/bin/bash
[ -d /var/run/chrony/ ] || mkdir -p /var/run/chrony/
mv /var/run/chronyd.pid /var/run/chrony/
