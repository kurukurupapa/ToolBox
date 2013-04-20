# Windows PowerShell
# テキストファイルの文字コードを変換するサンプルです。

param($inPath, $outDir)

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$DebugPreference = "Continue"

######################################################################
### 関数定義
######################################################################

# 使用方法を出力する。
# return - なし
function U-Write-Usage() {
    Write-Output "使い方：$psname 入力ファイル 出力ディレクトリ"
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

Write-Verbose "$psName Start"

###
### 主処理
###

if ($inPath -eq $null) {
    U-Write-Usage
} else {
    Get-Content $inpath | Set-Content "$outDir\CnvLang.SJIS.txt" -Encoding String
    Get-Content $inpath | Set-Content "$outDir\CnvLang.UTF8.txt" -Encoding UTF8
}

###
### 後処理
###

Write-Verbose "$psName End"
