#!/usr/bin/env pwsh

if (Test-Path release)
{
	Remove-Item -Recurse -Force release-source
}
New-Item -ItemType Directory release-source | out-null

Set-Location release-source
cmake -GNinja -DCMAKE_BUILD_TYPE=Release ..
ninja package_source

foreach ($PACKAGE in Get-ChildItem -Filter ((Get-Content CMakeCache.txt | Select-String -Pattern "SRC_PACKAGE:").Tostring().Split("=")[1] + ".*"))
{
	scp ($PACKAGE).Name $ENV:CHIKARA_UPLOAD_PATH
}
