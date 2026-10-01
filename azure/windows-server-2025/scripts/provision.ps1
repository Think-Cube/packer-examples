#Requires -RunAsAdministrator
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "Installing Windows features..."
Install-WindowsFeature -Name Web-Server -IncludeManagementTools

Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Host "Installing base packages..."
choco install -y git 7zip notepadplusplus

Write-Host "Running Windows Update..."
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PSWindowsUpdate -Force -AllowClobber
Import-Module PSWindowsUpdate
Get-WindowsUpdate -Install -AcceptAll -IgnoreReboot | Out-Null
