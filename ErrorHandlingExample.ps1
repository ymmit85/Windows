Try {
    # Insert command here to run, add -ErrorAction so Catch works.
    Get-Service -Name AdobeARMservice -ErrorAction stop
}
Catch {
    #Error message to be displayed when above command fails. Break will end script
    $msg=”Failed to find service"
    Write-Warning $msg
    Write-Warning $error[0].Exception.Message
    Break
}

#If all good script runs as normal
Write-Host "Command OK"

Try {
    # Insert command here to run, add -ErrorAction so Catch works. This one uses Inquire, will prompt user with question on if script should continue or halt.
    Get-Service -Name sss -ErrorAction Inquire
    }
Catch {
    #Error message to be displayed when above command fails. Break will end script
    $msg=”Failed to find service"
    Write-Warning $msg
    Write-Warning $error[0].Exception.Message
    Break
}

#If all good script runs as normal
Write-Host "Command OK"

Try {
    # Insert command here to run, add -ErrorAction so Catch works.
    Get-Service -Name sss -ErrorAction Stop
}
Catch {
    #Error message to be displayed when above command fails. Break will end script
    $msg=”Failed to find service"
    Write-Warning $msg
    Write-Warning $error[0].Exception.Message
    Break
}

#If all good script runs as normal
Write-Host "Command OK"
