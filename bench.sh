#!/bin/bash

for b in $(git for-each-ref --format='%(refname)' refs/heads/)
do
    git checkout $(basename $b)
    git rebase master
    ros ./testscr.ros 2>/dev/null | grep "seconds of real time"
done

