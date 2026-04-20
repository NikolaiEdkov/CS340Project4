#!/bin/bash

# changes file
CHANGES=$(mktemp)
for i in $(printf "%s\n" "$@" | sort -n) # $@ - all positional arguments
do
    cat patch.$i >> $CHANGES
done;

# applying changes in temperaray file
FILE=$(mktemp)
cat $CHANGES | patch -p0 wireworld-original.c -o $FILE.c

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
rm $CHANGES

exit $EXITCODE


