#!/bin/bash
echo Please enter your sudo password if you are prompted to do so.
echo Installing the corporate theme...
sudo mkdir -p /usr/share/plymouth/themes/corporate
sudo cp corporate.plymouth corporate.script /usr/share/plymouth/themes/corporate/
sudo tar -xzf images.tar.gz -C /usr/share/plymouth/themes/corporate/
# you may get errors related to those two lines, they may be fine (it depends on how your images was compressed)
sudo mv /usr/share/plymouth/themes/corporate/images/* /usr/share/plymouth/themes/corporate/
sudo rmdir /usr/share/plymouth/themes/corporate/images
NB=$(ls /usr/share/plymouth/themes/corporate/ | grep -c '\.png')
sudo sed -i "s/NB_IMAGES/$NB/" /usr/share/plymouth/themes/corporate/corporate.script
sudo sed -i 's/CORPORATE_PATH/\/usr/g' /usr/share/plymouth/themes/corporate/corporate.plymouth
sudo update-alternatives --quiet --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/corporate/corporate.plymouth 200
sudo update-alternatives --quiet --set default.plymouth /usr/share/plymouth/themes/corporate/corporate.plymouth
sudo update-initramfs -u
echo Done!
echo Have a nice day!