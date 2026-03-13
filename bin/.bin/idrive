#!/usr/bin/env bash
export AWS_ACCESS_KEY_ID=$(pass idrivee2.com/key)
export AWS_SECRET_ACCESS_KEY=$(pass idrivee2.com/secret)
export RESTIC_REPOSITORY=$(pass idrivee2.com/asdf98)
export RESTIC_PASSWORD_COMMAND='pass restic/asdfg98'
export RESTIC_READ_CONCURRENCY=5
export RESTIC_COMPRESSION=auto

/usr/bin/restic $@
