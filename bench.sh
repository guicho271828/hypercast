#!/bin/bash

for b in $(git for-each-ref --format='basename %(refname)' refs/heads/)
do
    git checkout $(eval $b)
    ros ./testscr.ros 2>/dev/null | grep "seconds of real time"
done

