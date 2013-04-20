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
$psBaseName = $psName -replace "\.ps1$", ""
$dataDir = Join-Path $baseDir "TestData"
$resultDir = Join-Path $baseDir "TestResult"
$sep = "#" * 70

Write-Debug "$psName Start"

###
### 主処理
###

Write-Output $sep
Invoke-Expression "$baseDir\StepCounter.ps1"

Write-Output $sep
$beforeDir = Join-Path $baseDir "TestData\StepCounter\before"
$afterDir = Join-Path $baseDir "TestData\StepCounter\after"
$outDir = "$resultDir\StepCounter"
Invoke-Expression "$baseDir\StepCounter.ps1 $beforeDir $afterDir $outDir"

Write-Output $sep

###
### 後処理
###
Write-Debug "$psName End"
