#! /bin/sh
# 
# This assumes that setup-pib.sh has run successfully.

for service in ros_cerebra_boot nginx ros_camera_boot; do
  a=$(systemctl status $service  | grep 'Active: ')
  echo -e "$service\n$a"; 
  if ! echo "$a" | grep -q 'Active: active (running)'; then
    echo "... restarting $service"
  fi
done
