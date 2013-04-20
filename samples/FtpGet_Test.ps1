# Windows PowerShell
# テスト実行

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

$basedir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psname = Split-Path $MyInvocation.InvocationName -Leaf
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

######################################################################
### 処理実行
######################################################################

###
### 前処理
###

$baseDir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psName = Split-Path $MyInvocation.InvocationName -Leaf
$psBaseName = $psName -replace "\.ps1$", ""
$dataDir = Join-Path $baseDir "TestData"
$resultDir = Join-Path $baseDir "TestResult"
$sep = "#" * 70
Write-Verbose "$psName Start"

###
### 主処理
###

Invoke-Expression "$basedir\FtpGet.ps1"

Write-Output $sep

$srcUrl = "ftp://ftp.jaist.ac.jp/pub/sourceforge.jp/ffftp/58201/ffftp-1.98g.zip"
$destPath = "$resultDir\ffftp-1.98g.zip"
Invoke-Expression "$basedir\FtpGet.ps1 $srcUrl $destPath"

Write-Output $sep

###
### 後処理
###
Write-Verbose "$psName End"
