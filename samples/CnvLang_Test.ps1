# Windows PowerShell
# �e�X�g���s

Set-StrictMode -Version Latest
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
$dataDir = "$baseDir\TestData"
$resultDir = "$baseDir\TestResult"
$sep = "#" * 70
Write-Verbose "$psName Start"

###
### �又��
###

Write-Output $sep
Invoke-Expression "$basedir\CnvLang.ps1"
Write-Output $sep
$inPath = "$PSHOME\ja-JP\default.help.txt"
$outDir = "$resultDir"
Invoke-Expression "$basedir\CnvLang.ps1 $inPath $outDir"
Write-Output $sep

###
### �㏈��
###
Write-Verbose "$psName End"
