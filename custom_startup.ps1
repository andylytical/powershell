###
# SCRIPT VARIABLES
###

$STARTUP_DIR = [IO.Path]::Combine($env:OneDrive, 'Startup' )
$DATETIME_STR = Get-Date -UFormat '%Y%m%d_%H%M%S_%Z'
$LOGFILE = "${DATETIME_STR}_${env:COMPUTERNAME}.txt"
$LOGPATH = [IO.Path]::Combine($STARTUP_DIR, 'logs', $LOGFILE)
$INDENT_INCREMENT = 2
$SH = New-Object -ComObject WScript.Shell # shell object needed for evaluating lnk target
$PAUSE = 5
New-Variable -Scope global -Name INDENT -Value '' #globally writeable

# RUNTIME OPTIONS
$VERBOSE = $true
$DRYRUN = $false
#$DRYRUN = $true


###
# FUNCTIONS
###

function Log {
  param(
    [Parameter(Mandatory = $true)]
    [string]$msg,

    [Parameter()]
    [string]$logfile = $LOGPATH
  )

  Add-Content -Path $logfile -Value $msg
}


function Info {
  param(
    [Parameter(Mandatory = $true)]
    [string]$msg
  )

  $newmsg = "[INFO] ${INDENT}${msg}"

  Log $newmsg

  if ($VERBOSE) {
    Write-Host $newmsg
  }
}


function Log-F-Enter {
  $fname = (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name
  Info "> ${fname}"
  $global:INDENT += ' ' * $INDENT_INCREMENT
}

function Log-F-Exit {
  $global:INDENT = $INDENT.Substring(0, $INDENT.Length - $INDENT_INCREMENT)
  $fname = (Get-Variable MyInvocation -Scope 1).Value.MyCommand.Name
  Info "< ${fname}"
}


function Invoke-ShortcutIfExists {
  param (
    $lnk_path
  )

  Log-F-Enter
  Info "lnk_path: '${lnk_path}'"
  $shortcut = $SH.CreateShortcut($lnk_path)
  $tgt = $shortcut.TargetPath
  Info "target: $tgt"
  $exists = Test-Path -Path $tgt
  Info "target exists? $exists"
  if ( $exists ) { 
    if ( $DRYRUN ) {
      Info "DRYRUN enabled, skipping '${lnk_path}'"
    }
    else {
      invoke-item $lnk_path
      Start-sleep -s $PAUSE
    }
  }
  Log-F-Exit
}


function IsBusinessHours {
  Log-F-Enter
  $now = Get-Date
  $dayOfWeek = $now.DayOfWeek
  $hourOfDay = $now.Hour
  Info "DayOfWeek: '$dayOfWeek'"
  Info "HourOfDay: '$hourOfDay'"
  $rv = $true

  if ($dayOfWeek.ToString().StartsWith('S')) {
    $rv = $false
  }
  elseif ($hourOfDay -lt 7 -or $hourOfDay -ge 17) {
    $rv = $false
  }

  Info "Return: ${rv}"
  Log-F-Exit
  return $rv
}


function Run-ShortcutsInDir {
  param(
    [Parameter(Mandatory = $true)]
    [string]$path
  )

  Log-F-Enter
  Info "path = '${path}'"

  # must have a "\*" at the end of path when using -Exclude with gci
  $search_path = ( [IO.Path]::Combine( $path, '*' ) )
  gci $search_path -File -Filter *.lnk -Exclude 00* | foreach-object {
    Invoke-ShortcutIfExists $_
  }

  Log-F-Exit
}


###
# MAIN WORK SECTION
###

# Ensure log dir exists
New-Item -ItemType Directory -Force -Path $(Split-Path -Path $LOGPATH -Parent)

# Create a hash of "directories" and "tests"
# Test should return a boolean; directory is included if "test" returns $true, otherwise it's skipped
# Passing code reference via scriptblock, see: https://stackoverflow.com/a/53147390/21010651
$dir_list = @{
  Always = { $true }         # curly braces make a scriptblock
  Work = { IsBusinessHours } # this function will be called when the scriptblock is invoked
}

$dir_list.GetEnumerator() | ForEach-Object {
  $dir = ( [IO.Path]::Combine( $STARTUP_DIR, $_.Key ) )
  # Use this search path only if the scriptblock returns True
  if ( $_.Value.InvokeReturnAsIs() ) {
    Run-ShortcutsInDir $dir
  }
  else {
    Info "Negative test result: skipping directory ${dir}"
  }
}
