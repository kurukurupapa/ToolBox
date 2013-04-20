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
$dataDir = Join-Path $baseDir "TestData"
$resultDir = Join-Path $baseDir "TestResult"
$sep = "#" * 70

Write-Debug "$psName Start"

###
### �又��
###

Write-Output $sep
Invoke-Expression "$basedir\SvnCoTwoRev.ps1"

Write-Output $sep
Write-Output "�ŐV�\�[�X�t�@�C���݂̂�ΏۂƂ���e�X�g"
$url = "http://svn.sourceforge.jp/svnroot/ksandbox/PowerShell/ToolBox/samples/TestData"
$outDir = "$resultDir\SvnCoTwoRev\Test01"
Invoke-Expression "$basedir\SvnCoTwoRev.ps1 $url $outDir"

Write-Output $sep
Write-Output "�ύX�O/��\�[�X�t�@�C����ΏۂƂ���e�X�g"
$url = "http://svn.sourceforge.jp/svnroot/ksandbox/PowerShell/ToolBox"
$beforeRev = "172"
$afterRev = "HEAD"
$outDir = "$resultDir\SvnCoTwoRev\Test02"
Invoke-Expression "$basedir\SvnCoTwoRev.ps1 -Url $url -BeforeRev $beforeRev -AfterRev $afterRev -OutDir $outDir"

Write-Output $sep
Write-Output "svn diff�Ȃǂ�URL���o�͂����URL�G���R�[�h�����B���X�N���v�g�Ńf�R�[�h���Ă��邱�Ƃ��m�F����B"
$url = "http://svn.sourceforge.jp/svnroot/ksandbox/PowerShell/ToolBox/samples/TestData/SvnDiffEx/���{��t�H���_"
$beforeRev = "206"
$afterRev = "HEAD"
$outDir = "$resultDir\SvnCoTwoRev\Test03"
Invoke-Expression "$basedir\SvnCoTwoRev.ps1 $url $outDir -BeforeRev $beforeRev -AfterRev $afterRev -BeforeDir $outDir\src1 -AfterDir $outDir\src2"

Write-Output $sep

###
### �㏈��
###
Write-Debug "$psName End"