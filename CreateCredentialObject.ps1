<#
.SYNOPSIS
Import secure string from file and create credential variable

.DESCRIPTION
Import secure string from file and create credential variable.

.EXAMPLE
Run script, when prompted enter in file to import.
Enter 32char string to used to encode text in file.

$User variable and $Pass is used to make new $CredentialObject

.NOTES
$User Variable must be provided for $CredentialObject to be created

#>

$Content = read-host "Enter filename to import secure string from (eg: c:\temp\secureFile.txt)."

#Enter password to open credentials
$Encoding = [System.Text.Encoding]::UTF8
Do {$string = read-host "Enter Password (32chars).."}
until ($string.Length -eq 32)
$ByteArray = $Encoding.GetBytes($string)
$key =$ByteArray

#Prepare Credentials
Write-Host "Content retrieved from $Content"
$Pass = Get-Content $Content | ConvertTo-SecureString -Key $key
$User = "xxx"
$CredentialObject = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User,$Pass
