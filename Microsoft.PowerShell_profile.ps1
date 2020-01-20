remove-item alias:curl
remove-item alias:wget
set-alias gh Get-Help
set-alias which gcm
set-alias aliases get-alias

# Source files from subdir
#$psub_dir = Join-Path -Path (get-item $profile).Directory.FullName -ChildPath 'PS1.d'
#Get-ChildItem -Path $psub_dir -Filter *.ps1 -File | Sort-Object Name | ForEach-Object { echo $_.FullName }
