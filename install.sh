#!/bin/bash
echo Please enter your sudo password if you are prompted to do so.
echo Installing the corporate theme...
sudo mkdir -p /usr/share/plymouth/themes/corporate
sudo cp corporate.plymouth corporate.script /usr/share/plymouth/themes/corporate/
sudo tar -xzf images.tar.gz -C /usr/share/plymouth/themes/corporate/
sudo sed -i 's/EVANGELION_UI_PATH/\/usr/g' /usr/share/plymouth/themes/corporate/corporate.plymouth
sudo update-alternatives --quiet --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/corporate/corporate.plymouth 100
sudo update-alternatives --quiet --set default.plymouth /usr/share/plymouth/themes/corporate/corporate.plymouth
sudo update-initramfs -u
echo Done!
# echo Testing...
# sudo plymouthd
# sudo plymouth --show-splash
# sleep 10
# sudo plymouth quit
# echo Done!
echo Have a nice day!