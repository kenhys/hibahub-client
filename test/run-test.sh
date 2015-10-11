#!/bin/bash

BASE_DIR=`dirname $0`
TOP_DIR="$BASE_DIR/../"

for rb in `find $BASE_DIR -name '*.rb'`; do
    ruby -I$TOP_DIR/lib $rb
done
