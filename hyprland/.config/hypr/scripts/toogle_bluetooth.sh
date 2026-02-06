#!/bin/bash

[[ "$(bluetooth: | awk '{print $3}')" == "off" ]] && bluetooth on || bluetooth off
