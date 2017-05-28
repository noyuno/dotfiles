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

$scriptPath = $MyInvocation.MyCommand.Path
$base=Split-Path -Parent $scriptPath
$reporoot=Split-Path -Parent $base
foreach ($i in get-content $reporoot/list/deploy) {
    if (!$i.startswith("#")) {
        $i = $i.Replace("/", "\")
        $s = "$i" -split " "
		if ([string]::IsNullOrEmpty($s[0])) {
			continue
		}
		if ([string]::IsNullOrEmpty($s[1])) {
			$s+=($s[0])
		}
		$a="$reporoot\"+$s[0]
		$b="$HOME\"+$s[1]
		$bbase = Split-Path -Parent $b
		if ((Test-Path -Path $bbase) -eq $false) {
			New-Item -ItemType Directory $bbase
		}
        if ((Test-Path -path $b) -eq $false) {
            Write-Host -Foregroundcolor Green New-Item -ItemType SymbolicLink -Target $a -Path $b
			New-Item -ItemType SymbolicLink -Target $a -Path $b
		}
    }
}
$runvboxlink = [Environment]::GetFolderPath("Desktop") + "\runvbox.ps1.lnk"
if ((Test-Path "$runvboxlink") -eq $false) {
    $WsShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WsShell.CreateShortcut("$runvboxlink")
    $Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    $Shortcut.Arguments = " -ExecutionPolicy RemoteSigned -File " +
        "$reporoot" + "\windows\runvbox.ps1"
$Shortcut.Save()
}
Write-Host -Backgroundcolor Blue "Finished dfdeploy"

