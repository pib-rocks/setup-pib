#! /bin/sh
# 
# This assumes that setup-pib.sh has run successfully.

for service in ros_cerebra_boot nginx ros_camera_boot; do
  a=$(systemctl status $service  | grep 'Active: ')
  echo "$service\n$a"; 
  echo "$a" | grep -q 'Active: active (running)' || systemctl restart $service
done
