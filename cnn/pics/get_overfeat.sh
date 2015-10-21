for x in test2_cutted/*.jpg; do
	convert -resize 231x231! $x test2_cutted_tiny/${x#*/}; 
	./../../../../Downloads/overfeat/bin/linux_64/overfeat -f test2_cutted_tiny/${x#*/} > test2_cutted_overfeat/${x#*/}.txt; 
	echo $x;
done

# for x in train/*.jpg; do
# 	convert -resize 231x231! $x train_tiny/${x#*/}; 
# 	./../../../../Downloads/overfeat/bin/linux_64/overfeat -f train_tiny/${x#*/} > train_overfeat/${x#*/}.txt; 
# 	echo $x;
# done
