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
$dataDir = Join-Path $baseDir "TestData"
$resultDir = Join-Path $baseDir "TestResult"
$sep = "#" * 70
Write-Debug "$psName Start"

###
### 主処理
###

Write-Output $sep
Invoke-Expression "$basedir\DevSvnJava.ps1"

Write-Output $sep
Write-Output "最新ソースファイルのみを対象とするテスト"
$url = "http://svn.sourceforge.jp/svnroot/ksandbox/PowerShell/ToolBox/samples/TestData"
$outDir = "$resultDir\SvnDiffEx\Test01"
Invoke-Expression "$basedir\DevSvnJava.ps1 $url $outDir"

Write-Output $sep
Write-Output "変更前/後ソースファイルを対象とするテスト"
$url = "http://svn.sourceforge.jp/svnroot/ksandbox/PowerShell/ToolBox"
$beforeRev = "172"
$afterRev = "HEAD"
$envPattern = "(http|ToolBox)"
$outDir = "$resultDir\SvnDiffEx\Test02"
Invoke-Expression "$basedir\DevSvnJava.ps1 -Url $url -BeforeRev $beforeRev -AfterRev $afterRev -EnvPattern ""$envPattern"" -OutDir $outDir"

Write-Output $sep
Write-Output "svn diffなどでURLを出力するとURLエンコードされる。当スクリプトでデコードしていることを確認する。"
$url = "http://svn.sourceforge.jp/svnroot/ksandbox/PowerShell/ToolBox/samples/TestData/SvnDiffEx/日本語フォルダ"
$beforeRev = "206"
$afterRev = "HEAD"
$outDir = "$resultDir\SvnDiffEx\Test03"
Invoke-Expression "$basedir\DevSvnJava.ps1 $url $outDir -BeforeRev $beforeRev -AfterRev $afterRev"

Write-Output $sep

###
### 後処理
###
Write-Debug "$psName End"
