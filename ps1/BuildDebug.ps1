#!/usr/bin/env pwsh

if (-not (Test-Path build/build.ninja))
{
	"Project is not initialized. Can't build."
	exit
}

Set-Location build
ninja
