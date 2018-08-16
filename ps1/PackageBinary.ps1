#!/usr/bin/env pwsh

if (Test-Path release)
{
	Remove-Item -Recurse -Force release
}
New-Item -ItemType Directory release | out-null

Set-Location release
cmake -GNinja -DCMAKE_BUILD_TYPE=Release ..
ninja package

foreach ($PACKAGE in Get-ChildItem -Filter ((Get-Content CMakeCache.txt | Select-String -Pattern "BIN_PACKAGE:").Tostring().Split("=")[1] + ".*"))
{
	scp ($PACKAGE).Name $ENV:CHIKARA_UPLOAD_PATH
}
