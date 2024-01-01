#!/bin/bash
set -e

source ./scripts/env.sh

rm -rf ./windows-installer
mkdir ./windows-installer

PATH_INNO='C:\Program Files (x86)\Inno Setup 6'

"$PATH_INNO/iscc.exe" ".\inno-setup\setup.iss"
