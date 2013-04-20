# Windows PowerShell
# FTPで、ファイルを取得するサンプルです。

param($srcUrl, $destPath)

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
    Write-Output "使い方：$psname 取得元URL 保存先パス"
    Write-Output "取得元URL - 例：ftp://～/aaa/xxx.zip"
    Write-Output "保存先パス - 保存先ファイルの絶対パス表記"
}

# 主処理を実行する。
# return - なし
function U-Run-Main() {
    $webClient = New-Object System.Net.WebClient
    #$webClient.Credentials = New-Object System.Net.NetworkCredential("username", "password")
    $webClient.DownloadFile($srcUrl, $destPath)
    $webClient.Dispose()
    
    Get-ChildItem $destPath
    Write-Output ""
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

if ($srcUrl -eq $null) {
    U-Write-Usage
} else {
    U-Run-Main
}

###
### 後処理
###

Write-Verbose "$psName End"
