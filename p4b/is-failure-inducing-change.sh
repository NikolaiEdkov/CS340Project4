#!/bin/bash

# temporary file
FILE=$(mktemp)
cp wireworld-original.c $FILE.c

for i in $(printf "%s\n" "$@" | sort -n) # $@ - all positional arguments
do
    patch -p0 $FILE.c -s < patch.$i 
done;

# compiling file, redirect STDERR and STDOUT into a /dev/null file
gcc -c $FILE.c -o $FILE.o &> /dev/null

# saving and normalizing exit code
if [ $? == 0 ]; then
    EXITCODE=0
else
    EXITCODE=1
fi

# deleting temporary files
rm $FILE*

exit $EXITCODE


