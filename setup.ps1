$DATE = Get-Date -UFormat '%Y%m%d_%H%M%S'
$URL_BASE = 'https://raw.githubusercontent.com/andylytical/powershell/main'

function Backup-File {
  param(
    [Parameter(Mandatory = $true)]
    [string]$filepath
  )

  if ( Test-Path -Path $filepath -PathType Leaf ) {
    get-item $filepath | rename-item -newname { $_.Name + $DATE }
  }
}

function Install-FileFromURL {
  param(
    [Parameter(Mandatory = $true)]
    [string]$url,

    [Parameter(Mandatory = $true)]
    [string]$target_dir,

    [Parameter()]
    [string]$target_filename = ''
  )

  if ( $target_filename.Length -lt 1 ) {
    $target_filename = $url.split('/')[-1]
  }

  $outfile = [IO.Path]::Combine( $target_dir, $target_filename )
  Backup-File $outfile
  Invoke-WebRequest -OutFile $outfile $url
}

# Dictionary of filename -> target install dir
$files = @{
  'custom_startup.ps1' = [IO.Path]::Combine( $env:OneDrive, 'Startup' )
  'Microsoft.PowerShell_profile.ps1' = [IO.Path]::Combine( $env:USERPROFILE, 'Documents', 'WindowsPowerShell' )
}

$files.GetEnumerator() | ForEach-Object {
  $fn = $_.Key
  $target_dir = $_.Value
  Install-FileFromURL `
    -url "${URL_BASE}/${fn}" `
    -target_dir $target_dir
}

# # custom_startup
# $fn = 'custom_startup.ps1'
# Install-FileFromURL `
#   -url "${URL_BASE}/${fn}" `
#   -target_dir ( [IO.Path]::Combine( $env:OneDrive, 'Startup' ) )

# # Powershell profile
# $fn = (get-item $profile).Name
# Install-FileFromURL `
#   -url "${URL_BASE}/${fn}" `
#   -target_dir (get-item $profile).Directory.FullName

