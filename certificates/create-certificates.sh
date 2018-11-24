#!/bin/bash

mkdir 10node io500
list=18-11
date="Nov 2018"

./create-certificate.py "$list" "$date" "10 Node Challenge" io500-10-node.csv 10node
./create-certificate.py "$list" "$date" "IO-500" io500.csv io500
