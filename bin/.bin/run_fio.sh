#!/usr/bin/env bash

size=2G
iodepth=32

#sync; fio --name=job-randw --rw=randwrite --size=$size --ioengine=libaio --iodepth=$iodepth --bs=4k --direct=1 --filename=bench.file --output-format=normal,terse
#sync; fio --name=job-write --rw=write --size=$size --ioengine=libaio --iodepth=$iodepth --runtime=120 --time_based --group_reporting --bs=4k --direct=1 --filename=bench.file --output-format=normal,terse
#sync; fio --name=job-write --rw=write --size=$size --ioengine=libaio --iodepth=$iodepth --bs=4k --direct=1 --filename=bench.file --output-format=normal,terse
#
#sync; fio --name=job-read --readonly --rw=read --size=$size --ioengine=libaio --iodepth=$iodepth --bs=4K --direct=1 --filename=bench.file --output-format=normal,terse
#sync; fio --name=job-randr --readonly --rw=randread --size=$size --ioengine=libaio --iodepth=$iodepth --bs=4K --direct=1 --filename=bench.file --output-format=normal,terse
#
sync
fio --name=job-randrw --rw=randrw --size=$size --ioengine=libaio --iodepth=$iodepth --runtime=120 --time_based --group_reporting --bs=4k --direct=1 --filename=bench.file --output-format=normal,terse
