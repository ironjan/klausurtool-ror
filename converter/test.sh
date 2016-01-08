#!/bin/bash
yes | cp ../db/development.sqlite3.bak ../db/development.sqlite3
clear
python converter.py 
