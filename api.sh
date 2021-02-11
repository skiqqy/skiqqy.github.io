#!/bin/bash
set -B
export FLASK_APP=./src/main.py
pip3 install --user -r ./assets/api_deps.txt
python3 -m flask run --host=0.0.0.0 --port=8199
