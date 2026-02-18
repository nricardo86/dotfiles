#!/usr/bin/env bash
ls -1 *.png || exit $? | xargs -n 1 bash -c 'magick "$0" "${0%.png}.jpg"'
