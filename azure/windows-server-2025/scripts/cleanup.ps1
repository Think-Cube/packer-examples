#Requires -RunAsAdministrator
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "Cleaning temp files..."
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Clearing Windows Update cache..."
Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service -Name wuauserv -ErrorAction SilentlyContinue

Write-Host "Running Sysprep..."
& "$env:SystemRoot\System32\Sysprep\Sysprep.exe" /oobe /generalize /quiet /shutdown
