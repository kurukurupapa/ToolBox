# Windows PowerShell
# ディレクトリを削除するスクリプトです。

param($dir)

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
    Write-Output "使い方：$psName 削除ディレクトリ"
}

# 主処理を実行する。
# return - なし
function U-Run-Main() {
    if (Test-Path -PathType Container $dir) {
        Remove-Item -Force -Recurse $dir
    }
    
    Write-Verbose "削除ディレクトリ=$dir"
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

if ($dir -eq $null) {
    U-Write-Usage
} else {
    U-Run-Main
}

###
### 後処理
###

Write-Verbose "$psName End"
