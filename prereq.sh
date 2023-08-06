#! /bin/sh
# 
# prerequisites:
# - user pib exists, if we run as root, we can create pib.
# - we run as user pib, 
# - and we have sudo power.
#

DEFAULT_USER=pif
if [ "$(id -u)" -eq 0 ]; then
  echo "You are running as root. We will change to user $DEFAULT_USER now. (and eventually change back to root via sudo)"
  # find, if user pib exists.
  if [ "0$(su - $DEFAULT_USER -c 'id -u' 2>/dev/null)" -eq 0 ]; then
    echo " ... creating user pib"
    useradd --create-home --password=$DEFAULT_USER $DEFAULT_USER
  fi
  # assert the sudoers entry
  echo "$DEFAULT_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$DEFAULT_USER
  # assert the sudo group.
  usermod -aG sudo $DEFAULT_USER
  
  exec su - $DEFAULT_USER -c "exec $SHELL $(readlink -f $0)"	# restart this script as as $DEFAULT_USER, we trust, we won't come here again.
fi

if [ -n "$(id -a | grep '(sudo)')" ]; then
  # we already have the sudo group
  # assert that we have a sudoers file.
  echo "Asserting sudoers entry."
  echo "For this change please enter your password..."
  sudo bash -c "echo '$DEFAULT_USER ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/$DEFAULT_USER"
else
  echo "Asserting sudo group and sudoers entry."
  echo "For this change please enter the root-password. It is most likely just your normal one..."
  su root bash -c "usermod -aG sudo $DEFAULT_USER ; echo '$DEFAULT_USER ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/$DEFAULT_USER"
fi
  
# check, if that was successful
if [ ! -f "/etc/sudoers.d/$DEFAULT_USER" ]; then
  echo "ERROR: creating sudoers entry failed. Try running this script as user root."
  exit 2
fi
    

## test who we are
id -a
## test if we can sudo
sudo id -a
