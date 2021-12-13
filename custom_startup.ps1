
# SEE ALSO
# (Get-WmiObject Win32_OperatingSystem).OSArchitecture
# Returns: String ( "32-bit" OR "64-bit" )
# Reference: https://blogs.msdn.microsoft.com/koteshb/2010/02/12/powershell-how-to-find-details-of-operating-system/

$STARTUP_DIR = "$env:USERPROFILE\Onedrive\Startup"
$PAUSE = 5

#start-sleep -s $PAUSE

$sh = New-Object -ComObject WScript.Shell

function Invoke-ShortcutIfExists {
    param (
        $raw_path
    )

    write-host ""
    write-host "Invoke-ShortcutIfExists"
    write-host $raw_path
    $shortcut = $sh.CreateShortcut($raw_path)
    $tgt = $shortcut.TargetPath
    write-host $tgt
    $exists = Test-Path -Path $tgt
    write-host "'$raw_path' -> '$tgt' ... exists? '$exists'"
    if ( $exists ) { 
        invoke-item "$raw_path"
        Start-sleep -s $PAUSE
    }
}

# Run all architecture agnostic progs
gci "$STARTUP_DIR/*" -Filter *.lnk -Exclude 00* | foreach-object {
    Invoke-ShortcutIfExists $_
}

# Run architecture specific progs
$arch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture.Substring(0,2)
$archdir = "$STARTUP_DIR\$arch"
gci "$archdir" -Filter *.lnk | foreach { 
    write-host "RAW: $_"
    write-host "WITHDIR: $archdir\$_"
    Invoke-ShortcutIfExists $archdir\$_
    #invoke-item "$archdir\$_"
    #Start-sleep -s $PAUSE
}
