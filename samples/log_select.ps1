# Windows PowerShell
# ���O�t�@�C���𑀍삷��T���v���ł��B

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
$baseDir = Convert-Path $(Split-Path -Path $MyInvocation.InvocationName -Parent)

###
### �֐���`
###

# ���O�s�����t�͈͂Ɋ܂܂�邩���肷��B
# $line - ���O�s
# $startTimestamp - �J�n�����i"yyyy/MM/dd HH:mm:ss"�j
# $endTimestamp - �I�������i"yyyy/MM/dd HH:mm:ss"�j
# return - $true, $false, $null
function U-Compare-Timestamp($line, $startTimestamp, $endTimestamp) {
    # ���O�s������t�𔲂��o��
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
    
    # ���t�͈͂Ɋ܂܂�Ă��邩���肷��
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

# ���O�t�@�C���̎w������͈͂��݂̂��o�͂���B
# $path - ���O�t�@�C���̃p�X
# $startTimestamp - �J�n�����i"yyyy/MM/dd HH:mm:ss"�j
# $endTimestamp - �I�������i"yyyy/MM/dd HH:mm:ss"�j
# return - $true, $false, $null
function U-Select-Log($path, $startTimestamp, $endTimestamp) {
    $outFlag = $false
    Get-Content $path | %{
        # �s������t�𔲂��o������A�s�̏o�͂𔻒肷��B
        # ���t�𔲂��o���Ȃ�������A�O�̍s�ɏ]���āA�o�͂���B
        $compare = U-Compare-Timestamp $_ $startTimestamp $endTimestamp
        if ($compare -ne $null) {
            $outFlag = $compare
        }
        # �s���o�͂���
        if ($outFlag) {
            $_
        }
    }
}

###
### �������s
###

# Apache�A�N�Z�X���O
$infile = Join-Path $basedir "testdata\ApacheAccess.log"
$startTimestamp = "2000/10/10 13:55:37"
$endTimestamp   = "2000/10/10 14:55:36"
Write-Output $infile
U-Select-Log $infile $startTimestamp $endTimestamp

echo $("*" * 70)

# Apache�G���[���O
$infile = Join-Path $basedir "testdata\ApacheError.log"
$startTimestamp = "2000/10/11 14:32:53"
$endTimestamp   = "2000/10/11 15:32:52"
Write-Output $infile
U-Select-Log $infile $startTimestamp $endTimestamp
