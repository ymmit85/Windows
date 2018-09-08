<#
.SYNOPSIS
    Encrypt text (eg: password to be used in scripts) to specific file.

.DESCRIPTION
    Text can only be decrypted by the user account on the computer that encrypted the text.
    
    To decrypt text below text can be used.

    $spass = ConvertTo-SecureString(Get-Content .\password2pass)

.NOTES
    Version:    1.0
    Author:     Tim Williams
    Github:     github.com/ymmit85

.LINK
    github.com/ymmit85

.PARAMETER InputText
    Specifies the text to be encrypted
    This parameter is mandatory.

.PARAMETER OutputPath
    Specifies the path to save file

.PARAMETER Filename
    Specifies the filename to save encrypted text.
    This parameter is mandatory.

.EXAMPLE
    .\Encrypt_Password.ps1 -Password P@ssword1 -OutputPath c:\temp -Filename Password.pass
    .\Encrypt_Password.ps1 -Password P@ssword1 -Filename Password.pass

#>
Param (
    [Parameter(Mandatory=$true)]
    [string]
    $InputText,
    [ValidateScript({Test-Path $_})] 
    [string]
    [AllowNull()]
    $OutputPath,
    [Parameter(Mandatory=$true)]
    $Filename
)

#Check for \ at end of path, add it if not there.
if ($OutputPath -notmatch '.+?\\$')
{
    $OutputPath += '\'
}
#Create ouput file with encrypted string.
$InputText | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File $OutputPath$Filename