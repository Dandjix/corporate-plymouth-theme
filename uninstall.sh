#!/bin/bash
echo Please enter your sudo password if you are prompted to do so.
echo Uninstalling the corporate theme...
sudo update-alternatives --quiet --remove default.plymouth /usr/share/plymouth/themes/corporate/corporate.plymouth
sudo rm -rf /usr/share/plymouth/themes/corporate
sudo update-alternatives --quiet --auto default.plymouth
sudo update-initramfs -u
echo Done