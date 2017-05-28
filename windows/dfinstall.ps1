# powershell v5.0

function Test-Admin
{
     (
        [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::
        GetCurrent()
     ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (!(Test-Admin)) {
    Write-Host Permission denied.
    exit 1
}

$ErrorActionPreference = "Stop"
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Error "PowerShell least version 5"
}

$base=Split-Path -Parent $MyInvocation.MyCommand.Path

$ErrorActionPreference = "Continue"
$choco = (Get-Command choco).Definition 2> $null
if ([string]::IsNullOrEmpty($choco)) {
    iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex
    cinst -y packages.config
} else {
    Write-Host 'Chocolatey has been installed.'
}
$ErrorActionPreference = "Stop"
. "$base\dfdeploy.ps1"

