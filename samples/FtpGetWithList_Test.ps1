# Windows PowerShell
# テスト実行

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

######################################################################
### 処理実行
######################################################################

###
### 前処理
###

$baseDir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psName = Split-Path $MyInvocation.InvocationName -Leaf
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$dataDir = Join-Path $baseDir "TestData"
$resultDir = Join-Path $baseDir "TestResult"
$sep = "#" * 70
Write-Verbose "$psName Start"

###
### 主処理
###

Write-Output $sep

Invoke-Expression "$basedir\FtpGetWithList.ps1"

Write-Output $sep

$hostName = "ftp.jaist.ac.jp"
$user = "anonymous"
$password = "password"
$listPath = "$dataDir\FtpGetWithList.txt"
$destDir = "$resultDir\FtpGetWithList"
Invoke-Expression "$basedir\FtpGetWithList.ps1 $hostName $user $password $listPath $destDir"

Write-Output $sep

###
### 後処理
###
Write-Verbose "$psName End"
