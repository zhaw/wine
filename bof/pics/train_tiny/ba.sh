for x in $(ls *.jpg); do ./../../../../../Downloads/overfeat/bin/linux_64/overfeat -f $x > $x.txt; echo $x; done
