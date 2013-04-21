# Windows PowerShell
# �֗��֐��Q���W�߂��X�N���v�g�ł��B

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
#$VerbosePreference = "Continue"
#$DebugPreference = "Continue"

######################################################################
### �֐���`
######################################################################

function U-Remove-Dir() {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)][string[]]$dirs
    )
    process {
        $dirs | %{
            if (Test-Path -PathType Container $_) {
                Remove-Item -Force -Recurse $_
            }
            Write-Verbose "�폜�f�B���N�g��=$_"
        }
    }
}
