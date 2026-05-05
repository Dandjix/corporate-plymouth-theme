#!/bin/bash
echo Please enter your sudo password if you are prompted to do so.
echo If you see nothing, switch to a graphics-less session and execute it there by using ctrl alt F2
echo Testing...
sudo plymouthd
sudo plymouth --show-splash
sleep 3
sudo plymouth quit
echo Done!
echo Have a nice day!