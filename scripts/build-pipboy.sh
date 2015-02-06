#!/bin/bash
echo $PATH
echo $CLASSPATH

java -Dfile.encoding=UTF-8 com.garmin.monkeybrains.Monkeybrains -a ../connect-win-sdk-latest/bin/api.db -i ../connect-win-sdk-latest/bin/api.debug.xml -o out/PipBoy30.prg -w -z ../PipBoy30/resources/resources.xml -m ../PipBoy30/manifest.xml -u ../connect-win-sdk-latest/bin/devices.xml ../PipBoy30/source/PipBoy30View.mc ../PipBoy30/source/PipBoy30App.mc -d vivoactive

java -Dfile.encoding=UTF-8 com.garmin.monkeybrains.Monkeybrains -a ../connect-win-sdk-latest/bin/api.db -i ../connect-win-sdk-latest/bin/api.debug.xml -o out/PipBoy30.prg -w -z ../PipBoy30/resources/resources.xml -m ../PipBoy30/manifest.xml -u ../connect-win-sdk-latest/bin/devices.xml ../PipBoy30/source/PipBoy30View.mc ../PipBoy30/source/PipBoy30App.mc -d epix

java -Dfile.encoding=UTF-8 com.garmin.monkeybrains.Monkeybrains -a ../connect-win-sdk-latest/bin/api.db -i ../connect-win-sdk-latest/bin/api.debug.xml -o out/PipBoy30.prg -w -z ../PipBoy30/resources/resources.xml -m ../PipBoy30/manifest.xml -u ../connect-win-sdk-latest/bin/devices.xml ../PipBoy30/source/PipBoy30View.mc ../PipBoy30/source/PipBoy30App.mc -d fr920xt