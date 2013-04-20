# Windows PowerShell
# テスト実行

Set-StrictMode -Version Latest
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
$psBaseName = $psName -replace "\.ps1$", ""
$dataDir = "$baseDir\TestData"
$resultDir = "$baseDir\TestResult"
$sep = "#" * 70
Write-Verbose "$psName Start"

###
### 主処理
###

Write-Output $sep
Invoke-Expression "$basedir\CnvLang.ps1"
Write-Output $sep
$inPath = "$PSHOME\ja-JP\default.help.txt"
$outDir = "$resultDir"
Invoke-Expression "$basedir\CnvLang.ps1 $inPath $outDir"
Write-Output $sep

###
### 後処理
###
Write-Verbose "$psName End"
