#!/usr/bin/env bash

export RESTIC_REPOSITORY='sftp:vault:/data/asdfg98'
export RESTIC_PASSWORD_COMMAND='pass restic/asdfg98'
#export RESTIC_PASSWORD=''
export RESTIC_READ_CONCURRENCY=5
export RESTIC_COMPRESSION=auto

/usr/bin/restic $@
