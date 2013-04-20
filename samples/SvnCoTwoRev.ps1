# Windows PowerShell
# �e���v���[�g

param($url, $outDir, $beforeRev, $afterRev, $beforeDir, $afterDir)

Set-StrictMode -Version Latest
$PSDefaultParameterValues = @{"ErrorAction"="Stop"}
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"

######################################################################
### �֐���`
######################################################################

# �g�p���@���o�͂���B
# return - �Ȃ�
function U-Write-Usage() {
    Write-Output "�g�����F$psName SVN��URL �o�̓f�B���N�g�� [-BeforeRev �ύX�O���r�W����] [-AfterRev �ύX�ナ�r�W����] [-BeforeDir �ύX�O�\�[�X�o�̓f�B���N�g��] [-AfterDir �ύX��\�[�X�o�̓f�B���N�g��]"
}

# �又�������s����B
# return - �Ȃ�
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
    
    Write-Output "��������"
    Write-Output "�ύX�O�\�[�X�f�B���N�g��=$beforeDir"
    Write-Output "�ύX��\�[�X�f�B���N�g��=$afterDir"
    Write-Output "�������X�g�t�@�C��=$listPath"
}

function U-Checkout-Source() {
    Write-Verbose "�`�F�b�N�A�E�g�J�n ${url}@${afterRev}"
    Invoke-Expression "svn co ${url}@${afterRev} $afterDir"
    
    if ($beforeRev -ne $null) {
        Write-Verbose "�`�F�b�N�A�E�g�J�n ${url}@${beforeRev}"
        Invoke-Expression "svn co ${url}@${beforeRev} $beforeDir"
    }
}

function U-Create-DiffList() {
    Write-Verbose "�������X�g�쐬�J�n ${url}@${beforeRev}:${afterRev}"
    
    if ($beforeRev -eq $null) {
        # �ŐV�\�[�X�̂ݎw�肳�ꂽ�ꍇ
        Invoke-Expression "svn list --recursive -r $afterRev $url" |
            Set-Content -Encoding String $listPath
    } else {
        # �ύX�O/��\�[�X���w�肳�ꂽ�ꍇ
        Invoke-Expression "svn diff -r ${beforeRev}:${afterRev} --summarize ${url}" | %{
            if ($_ -match "^(.+) +(.+)$") {
                $encodedUrl = $matches[2]
                $decodedUrl = [System.Uri]::UnescapeDataString($encodedUrl)
                if ($decodedUrl -match "${url}/(.+)$") {
                    Write-Output $matches[1]
                } elseif ($decodedUrl -match "${url}$") {
                    # �o�͕s�v
                } else {
                    Write-Output "# Warning ��͎��s $_"
                    Write-Warning "Warning ��͎��s $_"
                }
            } else {
                Write-Output "# Warning ��͎��s $_"
                Write-Warning "Warning ��͎��s $_"
            }
        } | Set-Content -Encoding String $listPath
    }
}

######################################################################
### �������s
######################################################################

###
### �O����
###

$baseDir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psName = Split-Path $MyInvocation.InvocationName -Leaf
$psBaseName = $psName -replace "\.ps1$", ""
$listPath = "${outDir}\DiffList.txt"
Write-Debug "$psName Start"

###
### �又��
###

if ($outDir -eq $null) {
    U-Write-Usage
} else {
    U-Run-Main
}

###
### �㏈��
###

Write-Debug "$psName End"
