# Windows PowerShell
# ソースファイルのステップ数を計測するスクリプトです。
param($beforeDir, $afterDir, $outDir)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

######################################################################
### 関数定義
######################################################################

# 使用方法を出力する。
# return - なし
function U-Write-Usage() {
    Write-Output "使い方：$psName 変更前ソースディレクトリ 変更後ソースディレクトリ 出力ディレクトリ"
}

# ステップ数を計測する。
# $beforeDir - 変更前ソースのディレクトリ
# $afterDir - 変更後ソースのディレクトリ
# return - なし
function U-Count-Step() {
    New-Item -Force -ItemType Directory $outDir | Out-Null
    
    # 全体カウント
    #Write-Verbose "変更後ソースカウント（テキスト形式）"
    #java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true "-output=${outDir}\AfterStep.txt"
    #Get-Content "${outDir}\AfterStep.txt" | Write-Debug
    Write-Verbose "変更後ソースカウント（CSV形式）"
    java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true -format=csv "-output=${outDir}\AfterStep.csv"
    Write-Verbose "変更後ソースカウント（Excel形式）"
    java -cp $jarPath jp.sf.amateras.stepcounter.Main $afterDir -showDirectory=true -format=excel "-output=${outDir}\AfterStep.xls"

    # 差分カウント
    Write-Verbose "差分ソースカウント（CSV形式）"
    java -cp $jarPath jp.sf.amateras.stepcounter.diffcount.Main $afterDir $beforeDir -format=csv "-output=${outDir}\DiffStep.csv"
    Write-Verbose "差分ソースカウント（Excel形式）"
    java -cp $jarPath jp.sf.amateras.stepcounter.diffcount.Main $afterDir $beforeDir -format=excel "-output=${outDir}\DiffStep.xls"

    Write-Output "処理結果"
    Write-Output "出力ディレクトリ=$outDir"
}

######################################################################
### 処理実行
######################################################################

###
### 前処理
###

$baseDir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psName = Split-Path $MyInvocation.InvocationName -Leaf
$psBaseName = $psName -replace "\.ps1$", ""
$jarPath = "$baseDir\..\stepcounter-3.0.1\eclipse-plugin\jp.sf.amateras.stepcounter\lib\stepcounter-3.0.1-jar-with-dependencies.jar"

Write-Verbose "$psName Start"

###
### 主処理
###

if ($($beforeDir -eq $null) -or $($afterDir -eq $null)) {
    U-Write-Usage
} else {
	U-Count-Step
}

###
### 後処理
###
Write-Verbose "$psName End"
