# Windows PowerShell
# �e�X�g���s

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

$basedir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psname = Split-Path $MyInvocation.InvocationName -Leaf
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

######################################################################
### �������s
######################################################################

###
### �O����
###

$baseDir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psName = Split-Path $MyInvocation.InvocationName -Leaf
$psBaseName = $psName -replace "\.ps1$", ""
$dataDir = Join-Path $baseDir "TestData"
$resultDir = Join-Path $baseDir "TestResult"
$sep = "#" * 70
Write-Verbose "$psName Start"

###
### �又��
###

Invoke-Expression "$basedir\FtpGet.ps1"

Write-Output $sep

$srcUrl = "ftp://ftp.jaist.ac.jp/pub/sourceforge.jp/ffftp/58201/ffftp-1.98g.zip"
$destPath = "$resultDir\ffftp-1.98g.zip"
Invoke-Expression "$basedir\FtpGet.ps1 $srcUrl $destPath"

Write-Output $sep

###
### �㏈��
###
Write-Verbose "$psName End"
