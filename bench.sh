#!/bin/bash

finish (){
    kill $pid
    exit
}
trap "finish" SIGINT

for b in $(git for-each-ref --format='%(refname)' refs/heads/)
do
    git checkout $(basename $b)
    git rebase master
    touch src/* t/*
    ros ./testscr.ros &
    pid=$!
    wait
done

