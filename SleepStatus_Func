<#
.SYNOPSIS
Function to set countdown timer with message.

.DESCRIPTION
Show a progress window for custom length of time and message.

.EXAMPLE
SleepStatus 5 "Message goes here"

#>

#Usage:
Function SleepStatus{
Param ($timeSec, $Message)
    for ($a=$timeSec; $a -gt 1; $a--) {
      Write-Progress -Activity $Message -SecondsRemaining $a
      Start-Sleep 1
    }
}
