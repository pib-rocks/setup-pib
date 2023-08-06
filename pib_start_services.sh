#! /bin/sh
# 
# This assumes that setup-pib.sh has run successfully.
# Use this script, in cases where systemd is not running (docker, wsl, etc...)
# We search for systemd start scripts and run all the ExecStart commands that we find.
#
# Expected error messages:
#  ros_working_dir/ros_cerebra_boot.sh unconditionally runs 
#	sudo service nginx restart
#  This cannot work in our sitation, thus we start nginx ourselves as a well known service.




well_known_services="nginx"
ros_services="ros_*"

all_service_files=
for srv in $well_known_services $ros_services; do
  files=$(find /etc/systemd /lib/systemd -name "$srv.service")
  for file in $files; do
    if [ ! -L $file ]; then
      all_service_files="$all_service_files $file"
    fi
  done
done

echo "Services found: $all_service_files"

for file in $all_service_files; do
  start_cmd=$(sed -ne 's/^ExecStart=//p' $file)
  echo "-------------------------"
  echo "Start this service? (Y/n):"
  echo "    $start_cmd & "
  # FIXME: This needs safeguard against duplicate starts.
  #        Dummy implementation: ask a human.
  read a
  if [ -z "$a" -o "$a" = "y" -o "$a" = "Y" ]; then
    nohup $start_cmd &
  fi
done

# for service in ros_cerebra_boot nginx ros_camera_boot; do
#   a=$(systemctl status $service  | grep 'Active: ')
#   echo -e "$service\n$a"; 
#   if ! echo "$a" | grep -q 'Active: active (running)'; then
#     echo "... restarting $service"
#   fi
# done


