$STARTUP_DIR = "$env:USERPROFILE\Onedrive\Startup"
$PAUSE = 5
$DRYRUN = $false
#$DRYRUN = $true

$sh = New-Object -ComObject WScript.Shell

function Invoke-ShortcutIfExists {
  param (
    $raw_path
  )

  write-host "-----"
  write-host "Invoke-ShortcutIfExists"
  write-host $raw_path
  $shortcut = $sh.CreateShortcut($raw_path)
  $tgt = $shortcut.TargetPath
  write-host $tgt
  $exists = Test-Path -Path $tgt
  write-host "'$raw_path' -> '$tgt' ... exists? '$exists'"
  if ( $exists -And -Not $DRYRUN ) { 
    invoke-item "$raw_path"
    Start-sleep -s $PAUSE
  }
}

function IsBusinessHours {
  $now = Get-Date
  $dayOfWeek = $now.DayOfWeek
  $hourOfDay = $now.Hour
  write-host "DayOfWeek='$dayOfWeek'"
  write-host "HourOfDay='$hourOfDay'"

  if ($dayOfWeek.ToString().StartsWith("S")) {
    return $false
  }

  if ($hourOfDay -lt 7 -or $hourOfDay -ge 17) {
    return $false
  }

  write-host "IsBusinessHours = True"
  return $true
}

# Run all architecture agnostic progs
gci "$STARTUP_DIR\*" -Filter *.lnk -Exclude 00* | foreach-object {
  Invoke-ShortcutIfExists $_
}

# Run architecture specific progs
# ...
# see also (Get-WmiObject Win32_OperatingSystem).OSArchitecture
# Returns: String ( "32-bit" OR "64-bit" )
# https://blogs.msdn.microsoft.com/koteshb/2010/02/12/powershell-how-to-find-details-of-operating-system/
$arch = (Get-WmiObject Win32_OperatingSystem).OSArchitecture.Substring(0,2)
$archdir = "$STARTUP_DIR\$arch"
gci "$archdir" -Filter *.lnk | foreach { 
  Invoke-ShortcutIfExists $archdir\$_
}

# Run work specific progs
if ( IsBusinessHours ) {
  write-host "Looking for work shortcuts"
  gci "$STARTUP_DIR\Work\*" -Filter *.lnk -Exclude 00* | foreach-object {
    Invoke-ShortcutIfExists $_
  }
}
