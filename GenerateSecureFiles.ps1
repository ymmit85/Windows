<#
.SYNOPSIS
Encode text from user (eg: credentials) and output to directory.

.DESCRIPTION
Will allow a password or other text to be entered then will be encoded with 32char string.
This text file can be imported later into alternate strings eg: for authentication.

.EXAMPLE
Run script, when prompted enter in output directory.
Enter filename to output.
Enter 32char string to use to encode string. this should be record in secure location.
Enter text to encode.

#>

#Get directory to output txt file to. Eg; c:\temp\
$outputdir = read-host "Enter output directory."
$fileName = read-host "Enter filename to output secure string to."

$Encoding = [System.Text.Encoding]::UTF8
Do {$string = read-host "Enter Password (32chars eg: AAAAA0C76B67BC2ZZZZZ2697CADXXXXX).."}
until ($string.Length -eq 32)
$ByteArray = $Encoding.GetBytes($string)
$key =$ByteArray

#Get name of file to create, appends .txt to end of filename
Read-Host "Enter contents for $fileName..." -AsSecureString | ConvertFrom-SecureString -key $key  | Out-File "$outputdir\$fileName.txt"
