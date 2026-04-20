#!/bin/bash

tests=$(pwd)/all_tests.txt
touch $tests

for img in ./libpng-1.6.34/large-png-suite/*.png
do
    echo "$(pwd)/$img" >> $tests
done