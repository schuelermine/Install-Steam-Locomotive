param([String]$Profile, [Switch]$Help, [Switch]$Force)

$ErrorMessages = @()

$Payload = "
# <Code inserted by Install-Steam-Locomotive>
function Steam-Locomotive {wsl sl -e}
function Steam-Locomotive-Force {wsl sl}
# </>
"

$HelpText = "This script helps you use the tremendous `"sl`" program in Windows PowerShell.
Simply download the .ps1 file and execute it.
If the script finishes successfully, you can type Steam-Locomotive in PS to start the interruptable `"sl -e`".
Use Steam-Locomotive-Force to prevent interruption (`"sl`").
Example:
PS C:\Users\User\Downloads\> .\Install-Steam-Locomotive.ps1 -Profile $PROFILE
"

if ($Help) {
  Write-Output $HelpText
  exit
}

if (!(Get-Command -Name "wsl" -CommandType "Application" -ErrorAction SilentlyContinue)) {
  $ErrorMessages += @("You don't have WSL installed. Cannot continue.")
}

if (!$Profile) {
  $ErrorMessages += @("Please supply your profile location under -Profile. Cannot continue.")
  if (Get-Content $Profile -ErrorAction SilentlyContinue | Select-String "Steam-Locomotive") {
    $ErrorMessages += @("Your profile seems to already contain something called `"Steam-Locomotive`". Use -Force to continue anyways.")
  }
}

if ((Get-Command -Name "Steam-Locomotive" -ErrorAction SilentlyContinue) -and !$Force) {
  $ErrorMessages += @("It seems a command named `"Steam-Locomotive`" is already installed. Use -Force to continue anyways.")
}

if ($ErrorMessages) {
  Write-Output $ErrorMessages
  exit
}

if (!(wsl command -v sl)) {
  Write-Output "First, install SL."
  wsl sudo apt install sl
}

if (wsl command -v sl) {
  Add-Content $Profile $Payload
  Write-Output "Done!"
}

if (!(wsl command -v sl)) {
  Write-Output "Failed installing wsl."
  exit
}

Write-Output "Success!"
