       <#
              .SYNOPSIS
                    Sets output directory for PowerShell sctipt.
					 
					 
              .DESCRIPTION
                     Can be used within script to allow entry of a path for output, if this in not specified then the current working directory is used for output.
                     If the parameter -Path is not specified then the current working directory is used, variable $output will contain directory.
      

       #>

Param
(
	[CmdletBinding()]
	[Parameter(Mandatory=$false)]
	[string]$path
)

if ($path) {
    $output = $path
    } else { 
    $output = $PWD
    }

    Write-Host $output
