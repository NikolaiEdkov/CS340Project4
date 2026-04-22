#!/bin/bash
python3 delta.py 9 ./is-interesting.sh --verbose
python3 delta.py 3 ./is-interesting.sh --verbose
python3 delta.py 5 ./is-interesting.sh --verbose
python3 delta.py 6 ./is-interesting.sh --verbose
python3 delta.py 6 "/bin/bash ./is-interesting.sh" --verbose