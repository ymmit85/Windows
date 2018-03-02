function New-Logger {
    Param(
        [Parameter(Mandatory=$true)]
        [String]$LogFileName,

        [Parameter(Mandatory=$true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [String]$LogFolderPath,

        [Parameter(Mandatory=$true)]
        [Bool]$LogToFile,

        [Parameter(Mandatory=$true)]
        [Bool]$LogToHost,

        [Parameter()]
        [Hashtable]$LogLevels = @{
            Info = @{
                ForegroundColor = 'Cyan'
            }
            Warning = @{
                BackgroundColor = 'Black'
                ForegroundColor = 'Yellow'
            }
            Error = @{
                BackgroundColor = 'Black'
                ForegroundColor = 'Red'
            }
            Critical = @{
                BackgroundColor = 'DarkRed'
                ForegroundColor = 'Red'
            }
        },

        [Parameter()]
        [String]$DefaultLevel = 'Info'
    )

    # Retrieve the local UTC offset string for appending to the ISO 8601 combined date and time string (Format: HH:mm)
    $LocalUtcOffset = "$([System.TimeZoneInfo]::Local.BaseUtcOffset.Hours.ToString('00')):$([System.TimeZoneInfo]::Local.BaseUtcOffset.Minutes.ToString('00'))"

    # Check whether the local UTC offset in hours is not negative
    if ([System.TimeZoneInfo]::Local.BaseUtcOffset.Hours -ge 0) {
        # Prefix the local UTC offset string with a plus sign (+)
        $LocalUtcOffset = "+$LocalUtcOffset"
    }

    # Retrieve the valid console colour names
    $ConsoleColors = [System.Enum]::GetValues([System.ConsoleColor])

    # Iterate through each specified log-level
    foreach ($Level in $LogLevels.Keys) {
        # Check whether the log level has a background color specified
        if ($LogLevels.$Level.BackgroundColor) {
            # Check whether the specified background color is in the array of valid console colour names
            if ($LogLevels.$Level.BackgroundColor -notin $ConsoleColors) {
                # Throw an exception if the specified background color is not valid
                throw (New-Object -TypeName System.Exception -ArgumentList "Log level [$Level] contains an invalid colour value for [BackgroundColor].")
            }
        }

        # Check whether the log level has a foreground color specified
        if ($LogLevels.$Level.ForegroundColor) {
            # Check whether the specified foreground color is in the array of valid console colour names
            if ($LogLevels.$Level.ForegroundColor -notin $ConsoleColors) {
                # Throw an exception if the specified foreground color is not valid
                throw (New-Object -TypeName System.Exception -ArgumentList "Log level [$Level] contains an invalid colour value for [ForegroundColor].")
            }
        }
    }

    # Check whether the specified default log level is present in the configured log levels
    if ($DefaultLevel -notin $LogLevels.Keys) {
        # Throw an exception if the specified default log level is not valid
        throw (New-Object -TypeName System.Exception -ArgumentList "Specified default log level [$DefaultLevel] is not defined.")
    }

    # Create a new object
    $Logger = New-Object -TypeName System.Object

    # Add the required NoteProperty members to the object
    Add-Member -InputObject $Logger -NotePropertyMembers @{
        Events = @()
        LastEventNumber = 0
        LocalUTCOffset = $LocalUtcOffset
        LogToFile = $LogToFile
        LogToHost = $LogToHost
        LogFileName = $LogFileName
        LogFolderPath = $LogFolderPath
        LogFilePath = (Join-Path -Path $LogFolderPath -ChildPath $LogFileName)
        LogFileInitialised = $false
        LogLevels = $LogLevels
        DefaultLevel = $DefaultLevel
    }

    # Add a script method member to the Logger object for initialising the log file
    Add-Member -InputObject $Logger -MemberType ScriptMethod -Name 'InitialiseLogFile' -Value {
        Param()

        # Check whether the log file has already been initialised
        if (!$this.LogFileInitialised) {
            # Create the log file with the specified name and path
            New-Item -Name $this.LogFileName -Path $this.LogFolderPath -ItemType File -Force | Out-Null

            # Validate log file creation
            if (Test-Path -Path $this.LogFilePath -PathType Leaf) {
                # Write CSV field titles to the log file
                Out-File -InputObject '"Number","DateTime","Level","Message"' -FilePath $this.LogFilePath -Append

                # Set the log file initialisation flag on the object to $true
                $this.LogFileInitialised = $true
            }
        }
    }

    # Add a script method member to the Logger object for writing a log entry
    Add-Member -InputObject $Logger -MemberType ScriptMethod -Name 'WriteLog' -Value {
        Param(
            [Parameter(Mandatory=$true,Position=0)]
            [String]$Message,

            [Parameter(Position=1)]
            [ValidateScript({ $_ -in $this.LogLevels.Keys })]
            [String]$Level = $this.DefaultLevel,

            [Parameter(Position=2)]
            [Bool]$LogToFile = $this.LogToFile,

            [Parameter(Position=3)]
            [Bool]$LogToHost = $this.LogToHost
        )

        # Increment the Logger object last event number
        $this.LastEventNumber++

        # Create a new Event object
        $Event = New-Object -TypeName System.Object

        # Add NoteProperty members to the object Event object containing the event number, date/time, level and message
        Add-Member -InputObject $Event -NotePropertyMembers @{
            Number = $this.LastEventNumber
            DateTime = "$((Get-Date).ToString('s'))$($this.LocalUTCOffset)"
            Level = $Level.ToUpper()
            Message = $Message
        }

        # Append the event to the Logger object
        $this.Events += $Event

        # Check whether file logging is enabled
        if ($LogToFile) {
            # Check whether the log file was successfully initialised
            if (!$this.LogFileInitialised) {
                # Call the method to initialise the log-file
                $this.InitialiseLogFile()

                # Re-check whether the log file was initialised
                if (!$this.LogFileInitialised) {
                    # Throw a custom exception
                    throw (New-Object -TypeName System.Exception -ArgumentList 'Log file was not initialised successfully.')
                }
            }

            # Write an entry to the log-file
            Out-File -InputObject ("`"$($Event.Number)`",`"$($Event.DateTime)`",`"$($Event.Level)`",`"$($Event.Message)`"") -FilePath $this.LogFilePath -Append
        }

        # Check whether host logging is enabled
        if ($LogToHost) {
            # Construct the message to write to the host
            $HostMessage = "$($Event.Number) - $($Event.DateTime) - $($Event.Level) - $($Event.Message)"

            # Select the log level colours
            $LevelColors = $this.LogLevels.$Level

            # Write the message to the host using formatting specific to the log level
            Write-Host -Object $HostMessage @LevelColors
        }
    }

    # Return the Logger object
    return $Logger
}