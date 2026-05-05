i=1
e=$(ls ~/Coding/Plymouth-Creator/output/image-*.png | wc -l)
for n in $(seq 1 $e)
do
	if test -f "image-$n.png"; then
		echo "Renaming image-$n.png -> file=image-$i.png"
		mv image-$n.png image-$i.png
		i=$((i+1))
	else
		echo "image-$n.png does not exist"
	fi
done
