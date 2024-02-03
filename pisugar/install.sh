#!/usr/bin/env bash

echo "Patching Pwnagotchi..."

### PiSugar
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
echo "Selected model: ${psmodel}"
# configure
echo "Installing PiSugar server..."
debconf-set-selections << EOF
pisugar-server pisugar-server/model select ${psmodel}
pisugar-server pisugar-server/auth-username string ${psusername}
pisugar-server pisugar-server/auth-password password ${pspassword}
EOF
DEBIAN_FRONTEND=noninteractive dpkg -i $(pwd)/dist/pisugar-server*.deb
echo "Installing PiSugar poweroff..."
debconf-set-selections << EOF
pisugar-poweroff pisugar-poweroff/model select "${psmodel}"
EOF
DEBIAN_FRONTEND=noninteractive dpkg -i $(pwd)/dist/pisugar-poweroff*.deb
echo "Installing PiSugar Python library..."
rm -rf /usr/local/lib/python3.7/dist-packages/pisugar2py
sudo cp -r ./dist/pisugar2py /usr/local/lib/python3.7/dist-packages
cp ./dist/pwnagotchi-pisugar2-plugin/pisugar2.py /usr/local/share/pwnagotchi/custom-plugins/pisugar2.py

# install other dependencies
echo "Installing Pwnagotchi custom plugins dependencies..."
DEBIAN_FRONTEND=noninteractive dpkg -i $(pwd)/dist/hwloc*.deb
DEBIAN_FRONTEND=noninteractive dpkg -i $(pwd)/dist/aircrack-ng*.deb
pip3 install ./dist/protobuf*.whl

# create /usr/share/wordlists if it doesn't exist
echo "Copying wordlists..."
mkdir -p /usr/share/wordlists
unzip -o ./dist/wordlists/*.zip -d /usr/share/wordlists

echo "Done patching!"
