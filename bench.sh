#!/bin/bash

for b in $(git for-each-ref --shell --format='%(refname)' refs/heads/)
do
    git checkout $b
    ros ./testscr.ros 2>/dev/null | grep "seconds of real time"
done

