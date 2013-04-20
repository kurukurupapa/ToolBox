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
$sep = "#" * 70
Write-Verbose "$psName Start"

###
### �又��
###

Write-Output $sep
Invoke-Expression "$basedir\CopyWithList.ps1"

Write-Output $sep
$listPath = "$baseDir\TestData\CopyWithList\list.txt"
$inDir = "$baseDir\TestData\CopyWithList"
$outDir = "$baseDir\TestResult\CopyWithList\Test01"
Invoke-Expression "$basedir\CopyWithList.ps1 $listPath $inDir $outDir"

Write-Output $sep
Write-Output "�I�v�V����-Include�̃e�X�g"
$listPath = "$baseDir\TestData\CopyWithList\list.txt"
$inDir = "$baseDir\TestData\CopyWithList"
$outDir = "$baseDir\TestResult\CopyWithList\Test02"
Invoke-Expression "$basedir\CopyWithList.ps1 $listPath $inDir $outDir -Include ""\w{3}2"""

Write-Output $sep
Write-Output "�I�v�V����-Exclude�̃e�X�g"
$listPath = "$baseDir\TestData\CopyWithList\list.txt"
$inDir = "$baseDir\TestData\CopyWithList"
$outDir = "$baseDir\TestResult\CopyWithList\Test03"
Invoke-Expression "$basedir\CopyWithList.ps1 $listPath $inDir $outDir -Exclude ""[^\w]c[^\w]"""

Write-Output $sep

###
### �㏈��
###
Write-Verbose "$psName End"
