#!/usr/bin/env bash

# variables - TODO: make these configurable
psmodel="PiSugar 2 (2-LEDs)"
psusername="admin"
pspassword="admin"

# uninstall if already installed
if [ -f /usr/local/lib/python3.7/dist-packages/pisugar2py ]; then
  echo "Uninstalling PiSugar..."
  apt-get remove -y pisugar-server pisugar-poweroff
  rm -rf /usr/local/lib/python3.7/dist-packages/pisugar2py
  rm -rf /usr/local/share/pwnagotchi/custom-plugins/pisugar2.py
fi

# start
echo "Selected ${psmodel}"

# configure
echo "Configuring PiSugar..."
debconf-set-selections << EOF
pisugar-server pisugar-server/model select "${psmodel}"
pisugar-server pisugar-server/auth-username string "${psusername}"
pisugar-server pisugar-server/auth-password password "${pspassword}"
EOF
DEBIAN_FRONTEND=noninteractive dpkg -i $(pwd)/dist/pisugar-server*.deb
#rm $(pwd)/dist/pisugar-server*.deb

debconf-set-selections << EOF
pisugar-poweroff pisugar-poweroff/model select "${psmodel}"
EOF
DEBIAN_FRONTEND=noninteractive dpkg -i $(pwd)/dist/pisugar-poweroff*.deb
#rm $(pwd)/dist/pisugar-poweroff*.deb

ln -s $(pwd)/dist/pisugar2py /usr/local/lib/python3.7/dist-packages/pisugar2py
ln -s $(pwd)/dist/pwnagotchi-pisugar2-plugin/pisugar2.py /usr/local/share/pwnagotchi/custom-plugins/pisugar2.py

