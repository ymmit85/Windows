<#
.SYNOPSIS  
    Get MD5 hash of file.
.DESCRIPTION
    Gets MD5 hash of file to validate no changes have been made if scripts are not stored on Github.
    Output can be used in comment block of script.
    
.NOTES
    Version: 1.0
    Author: Tim Williams
    MD5: 3CF27BC9083C03127C3B7BF93E32BCE9

.PARAMETER SourceFile
    File to get MD5 hash of.

.EXAMPLE
    .\File_MD5_Hash.ps1 -SourceFile .\File_MD5_Hash.ps1
#>

param (
    $SourceFile
)
$date = $((Get-Date).ToString('yyyy-MM-dd-hh-mm'))

$hash = Get-FileHash -Algorithm MD5 -Path $SourceFile

write-host "MD5:"$hash.hash
write-host "Filename: $SourceFile"
write-host "Date: $date"