#!/bin/bash
set -ev
wget https://www.dropbox.com/s/7ewfu362h5chtt0/connect-sdk-win-latest.zip?dl=1 -O connect-win-sdk-latest.zip
unzip -a connect-win-sdk-latest.zip
export PATH=$PATH:connect-win-sdk-latest/bin/
export CLASSPATH=$CLASSPATH:connect-win-sdk-latest/bin/monkeybrains.jar