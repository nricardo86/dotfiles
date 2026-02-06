#!/bin/bash

[[ "$(wifi | awk '{print $3}')" == "off" ]] && wifi on || wifi off
