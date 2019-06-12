#!/bin/bash

list=19-06
date="June 2019"

./create-certificate.py "$list" "$date" "10 Node Challenge" io500-10-node.csv 10node "io500__score"
./create-certificate.py "$list" "$date" "IO-500" io500.csv io500 "io500__score"
./create-certificate.py "$list" "$date" "IO-500 BW Score" full.csv bw "io500__bw"
./create-certificate.py "$list" "$date" "IO-500 MD Score" full.csv md "io500__md"
