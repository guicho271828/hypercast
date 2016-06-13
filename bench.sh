#!/bin/bash

branches="master bitvector-opt"

for b in $branches
do
    git checkout $b
    ros ./testscr.ros
done

