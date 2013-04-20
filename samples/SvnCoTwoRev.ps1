# Windows PowerShell
# テンプレート

param($url, $outDir, $beforeRev, $afterRev, $beforeDir, $afterDir)

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
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
    Write-Output "使い方：$psName SVNのURL 出力ディレクトリ [-BeforeRev 変更前リビジョン] [-AfterRev 変更後リビジョン] [-BeforeDir 変更前ソース出力ディレクトリ] [-AfterDir 変更後ソース出力ディレクトリ]"
}

# 主処理を実行する。
# return - なし
function U-Run-Main() {
    if ($afterRev -eq $null) {
        $afterRev = "HEAD"
    }
    if ($beforeDir -eq $null) {
        $beforeDir = "${outDir}\BeforeSrc"
    }
    if ($afterDir -eq $null) {
        $afterDir = "${outDir}\AfterSrc"
    }

    U-Checkout-Source
    U-Create-DiffList
    
    Write-Output "処理結果"
    Write-Output "変更前ソースディレクトリ=$beforeDir"
    Write-Output "変更後ソースディレクトリ=$afterDir"
    Write-Output "差分リストファイル=$listPath"
}

function U-Checkout-Source() {
    Write-Verbose "チェックアウト開始 ${url}@${afterRev}"
    Invoke-Expression "svn co ${url}@${afterRev} $afterDir"
    
    if ($beforeRev -ne $null) {
        Write-Verbose "チェックアウト開始 ${url}@${beforeRev}"
        Invoke-Expression "svn co ${url}@${beforeRev} $beforeDir"
    }
}

function U-Create-DiffList() {
    Write-Verbose "差分リスト作成開始 ${url}@${beforeRev}:${afterRev}"
    
    if ($beforeRev -eq $null) {
        # 最新ソースのみ指定された場合
        Invoke-Expression "svn list --recursive -r $afterRev $url" |
            Set-Content -Encoding String $listPath
    } else {
        # 変更前/後ソースを指定された場合
        Invoke-Expression "svn diff -r ${beforeRev}:${afterRev} --summarize ${url}" | %{
            if ($_ -match "^(.+) +(.+)$") {
                $encodedUrl = $matches[2]
                $decodedUrl = [System.Uri]::UnescapeDataString($encodedUrl)
                if ($decodedUrl -match "${url}/(.+)$") {
                    Write-Output $matches[1]
                } elseif ($decodedUrl -match "${url}$") {
                    # 出力不要
                } else {
                    Write-Output "# Warning 解析失敗 $_"
                    Write-Warning "Warning 解析失敗 $_"
                }
            } else {
                Write-Output "# Warning 解析失敗 $_"
                Write-Warning "Warning 解析失敗 $_"
            }
        } | Set-Content -Encoding String $listPath
    }
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
$listPath = "${outDir}\DiffList.txt"
Write-Debug "$psName Start"

###
### 主処理
###

if ($outDir -eq $null) {
    U-Write-Usage
} else {
    U-Run-Main
}

###
### 後処理
###

Write-Debug "$psName End"
