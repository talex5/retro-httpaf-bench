#!/bin/bash
set -xe

run_duration="${RUN_DURATION:-10}"

export GOMAXPROCS=1

rm -rf output/*
mkdir -p output

for cmd in "httpaf_eio.exe" "rust_hyper.exe" "httpaf_effects.exe"; do
  for rps in 100000 200000 400000 600000; do
    for cons in 1000; do
      ./build/$cmd &
      running_pid=$!
      sleep 2;
      ./build/wrk2 -t 24 -d${run_duration}s -L -s ./build/json.lua -R $rps -c $cons http://localhost:8080 > output/run-$cmd-$rps-$cons.txt;
      kill ${running_pid};
      sleep 1;
    done
  done
done

source build/pyenv/bin/activate
mv build/parse_output.ipynb .
jupyter nbconvert --to html --execute parse_output.ipynb
mv parse_output* output/
