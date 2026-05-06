# Corporate Plymouth Theme

## Dependecies
Have GIMP installed on your system to use 'bundle_images.sh'

## Customization
You can customize some parameters by modifying the values in 'params.env'
you can customize :
column count (row size)
inner and outer margin
the target background color (the color will be black at the start and will change to that color linearly as progress advances)

## Installation & Usage
### Bundling the images
put all your images in a directory named 'images' adjacent to the 'bundle_images.sh' script, 
run 'bundle_images.sh'. 

The script resizes the images while conserving aspect ratio to something reasonable (224x224) and converts any format to .png
It also renames the pictures to 1.png to n.png, with n the number of images in the images folder.
The 'bundle_images.sh' script simply generates an archive with all your images. If you want to test this theme with different settings, you don't need to bundle the images each time
You can do it by hand if you want, all your images should be pngs named 1.png to n.png with n the number of images in the directory. This way, the images appear in the order you numbered them.

### Installation
run 'install.sh' to install the theme. If you want to test this theme with different settings, you don't need to bundle the images each time.

### Uninstallation
to uninstall, run 'uninstall.sh'