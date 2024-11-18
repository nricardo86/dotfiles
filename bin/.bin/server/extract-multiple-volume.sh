#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BASEDIR=$(pwd)
FILE=$(echo $1 | cut -d- -f1)

echo 0 >$BASEDIR/$FILE.number

$SCRIPT_DIR/tar-multiple-volume-script x $BASEDIR $FILE

tar -M -F "$SCRIPT_DIR/tar-multiple-volume-script x $BASEDIR $FILE" -xf $FILE.tar $@

rm $BASEDIR/$FILE.tar
rm $BASEDIR/$FILE.number
