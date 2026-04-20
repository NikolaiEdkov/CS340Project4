#!/bin/bash

source /home/edkovnikolai/cs340/Project4/p4c/.venv/bin/activate

# $1 is the "test" file
# NOTE: assuming that the lib-png is pre-compiled
TEST_FILE=$1

TEST_PNGS=$(cat $TEST_FILE)

cd /home/edkovnikolai/cs340/Project4/p4c/libpng-1.6.34

ALL_TEST_PNGS=$(cat ../all_tests.txt)


CLEAN_COV="rm -rf *.gcda pngout.png"
RUN_COV="gcovr -s -e contrib -e intel -e mips -e powerpc -e arm -r . --gcov-ignore-errors=source_not_found 2> /dev/null"
GET_LINES="eval $RUN_COV | tail -n 5 | head -n 1 | awk '{print \$3}'"

$CLEAN_COV


# going over all tests
# for f in $ALL_TEST_PNGS
# do
#     ./pngtest $f &> /dev/null
# done

# recording lines of all tests
# MAX_LINES=$($GET_LINES)
# $CLEAN_COV

MAX_LINES=4092

# going over selected tests
for f in $TEST_PNGS
do
    ./pngtest $f &> /dev/null
done

# recording selected tests line coverage
CUR_LINES=$($GET_LINES)
echo $CUR_LINES
$CLEAN_COV

# comparing results
if [ $CUR_LINES -ge $MAX_LINES ]
then
    exit 0 # interesting
else
    exit 1
fi
