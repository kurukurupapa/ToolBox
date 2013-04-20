# Windows PowerShell
# �e�X�g���s

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

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

Write-Debug "$psName Start"

###
### �又��
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
### �㏈��
###
Write-Debug "$psName End"
