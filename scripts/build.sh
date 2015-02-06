#!/bin/bash
set -ev
pwd

for DEVICE in "${@:2}"; do
java -Dfile.encoding=UTF-8 -cp connect-sdk-win-latest/bin/monkeybrains.jar com.garmin.monkeybrains.Monkeybrains -a connect-sdk-win-latest/bin/api.db -i connect-sdk-win-latest/bin/api.debug.xml -o out/$1-$DEVICE.prg -w -z $1/resources/resources.xml -m $1/manifest.xml -u connect-sdk-win-latest/bin/devices.xml $1/source/* -d $DEVICE
done