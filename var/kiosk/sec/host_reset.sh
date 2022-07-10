#!/usr/bin/env bash

echo -n quiet >/sys/module/apparmor/parameters/audit

truncate -s 0 /var/log/syslog
truncate -s 0 /var/log/kern.log
truncate -s 0 /var/kiosk/kiosk_url
truncate -s 0 /var/kiosk/sec/kiosk_menu_pwd

rm -rf /Certificados/*

rm /root/.bash_history
