# Corporate Plymouth Theme

## Dependecies
Have GIMP installed on your system to use 'bundle_images.sh'

## Customization
You can customize some parameters by modifying the values in 'params.env'

## Installation & Usage
put all your images in a directory named 'images', 
run 'bundle_images.sh'. 


The script resizes the images while conserving aspect ratio to something reasonable (224x224) and converts any format to .png
It also renames the pictures to 1.png to n.png, with n the number of images in the images folder.

then run 'install.sh' to install the theme.

to uninstall, run 'uninstall.sh'