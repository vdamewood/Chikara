#!/usr/bin/env pwsh

if (-not (Test-Path CMakeLists.txt))
{
	"This doesn't look like the project directory."
	exit
}

if (Test-Path build)
{
	Remove-Item -Recurse -Force build
}

New-Item -ItemType Directory build | out-null
Set-Location build

cmake -GNinja -DCMAKE_BUILD_TYPE=Debug ..
