#!/usr/bin/env bash
source ./scripts/env.sh

# ----- prepare for windows -----
# lib
nginx=nginx-1.25.2

# delete and re-create output folder
rm -rf ./$windowsBuildDir
mkdir $windowsBuildDir

# copy all extra files of windows and repo common to output folder
cp -a ./extra-files-windows/. ./$windowsBuildDir

cd ./$windowsBuildDir
# install node-windows
npm i

unzip $nginx.zip
rm $nginx.zip
mv -f ./nginx.conf ./$nginx/conf/nginx.conf
rm -rf ./$nginx/html
cp -a ../$sourceDir/$repoFrontend ./$nginx/html
mv ./$nginx ./nginx
cd ../

outBuildDir="../$windowsBuildDir"

service=backend
cd ./$sourceDir
echo installing $service
cd ./$service

outServiceDir="../../$windowsBuildDir/$service"

echo outServiceDir $outServiceDir

# copy project to workspace and change name
echo copy service $service

# create folder of repo in ouput
mkdir -p $outServiceDir

npm install
npm run build
ncc build dist/main.js -m -o out

# copy out folder to output folder
mv out $outServiceDir/dist
echo folder out $outServiceDir/dist

cd ../..
./scripts/build-inno.sh
