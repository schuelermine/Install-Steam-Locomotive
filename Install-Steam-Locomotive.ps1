param([String]$Profile, [Switch]$Skip-Reload)

if (!$Profile) {
  Write-Output "Please supply your profile location under -Profile. Cannot continue."
  exit
}

if (!(Get-Command -Name "wsl" -CommandType "Application")) {
  Write-Output "You don't have WSL installed. Cannot continue."
  exit
}

if (!(wsl command -v sl)) {
  Write-Output "First, install SL."
  wsl sudo apt install sl
}

if (wsl command -v sl) {
  Add-Content $Profile "`n`n# Code inserted by Install-Steam-Locomotive`n"
  Add-Content $Profile "function Steam-Locomotive {wsl sl -e}`n"
  Add-Content $Profile "function Steam-Locomotive-Force {wsl sl}`n"
  Add-Content $Profile "`n# </>`n"
  Write-Output "Done!"
}

if (!(wsl command -v sl)) {
  Write-Output "Failed installing wsl."
  exit
}

if (!$Skip-Reload) {
  . $Profile
}

Write-Output "Success!"
