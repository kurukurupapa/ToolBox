# Windows PowerShell
# ログファイルを操作するサンプルです。

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
$baseDir = Convert-Path $(Split-Path -Path $MyInvocation.InvocationName -Parent)

###
### 関数定義
###

# ログ行が日付範囲に含まれるか判定する。
# $line - ログ行
# $startTimestamp - 開始日時（"yyyy/MM/dd HH:mm:ss"）
# $endTimestamp - 終了日時（"yyyy/MM/dd HH:mm:ss"）
# return - $true, $false, $null
function U-Compare-Timestamp($line, $startTimestamp, $endTimestamp) {
    # ログ行から日付を抜き出す
    $timestamp = $null
    if ($line -match "[^\d](\d{4}/\d{2}/\d{2}):(\d{2}:\d{2}:\d{2})[^\d]") {
        $timestamp = $($matches[1] + " " + $matches[2])
    }
    elseif ($line -match "[^\d](\d{4}/\d{2}/\d{2} \d{2}:\d{2}:\d{2})[^\d]") {
        $timestamp = $matches[1]
    }
    elseif ($line -match "[^\d](\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})[^\d]") {
        $timestamp = $matches[1] -replace "-", "/"
    }
    
    # 日付範囲に含まれているか判定する
    if ($timestamp -eq $null) {
        return $null
    } else {
        if ($timestamp -ge $startTimestamp) {
            if ($timestamp -le $endTimestamp) {
                return $true
            }
        }
    }
    return $false
}

# ログファイルの指定日時範囲をのみを出力する。
# $path - ログファイルのパス
# $startTimestamp - 開始日時（"yyyy/MM/dd HH:mm:ss"）
# $endTimestamp - 終了日時（"yyyy/MM/dd HH:mm:ss"）
# return - $true, $false, $null
function U-Select-Log($path, $startTimestamp, $endTimestamp) {
    $outFlag = $false
    Get-Content $path | %{
        # 行から日付を抜き出せたら、行の出力を判定する。
        # 日付を抜き出せなかったら、前の行に従って、出力する。
        $compare = U-Compare-Timestamp $_ $startTimestamp $endTimestamp
        if ($compare -ne $null) {
            $outFlag = $compare
        }
        # 行を出力する
        if ($outFlag) {
            $_
        }
    }
}

###
### 処理実行
###

# Apacheアクセスログ
$infile = Join-Path $basedir "testdata\ApacheAccess.log"
$startTimestamp = "2000/10/10 13:55:37"
$endTimestamp   = "2000/10/10 14:55:36"
Write-Output $infile
U-Select-Log $infile $startTimestamp $endTimestamp

echo $("*" * 70)

# Apacheエラーログ
$infile = Join-Path $basedir "testdata\ApacheError.log"
$startTimestamp = "2000/10/11 14:32:53"
$endTimestamp   = "2000/10/11 15:32:52"
Write-Output $infile
U-Select-Log $infile $startTimestamp $endTimestamp
