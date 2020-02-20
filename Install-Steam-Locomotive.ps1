param([String]$Profile, [Switch]$Help)

$HelpText = "This script helps you use the tremendous sl program in Windows PowerShell.
Simply download the .ps1 file and execute it.

If the script finishes successfully, you can type Steam-Locomotive in PS to start the interruptable sl -e. Use Steam-Locomotive-Force to prevent interruption (sl).

Example:

PS C:\Users\User\Downloads\> .\Install-Steam-Locomotive.ps1 -Profile $PROFILE -SkipReload
Done!
Success!
PS C:\Users\User\Downloads\> exit
"

if ($Help) {
  Write-Output $HelpText
  exit
}

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

Write-Output "Success!"
