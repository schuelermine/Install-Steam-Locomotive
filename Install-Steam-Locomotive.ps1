[CmdletBinding(
    SupportsShouldProcess
)]

param(
    [Parameter(
        Mandatory
    )]
    [String]
    $Profile,

    [Switch]
    $Help,

    [Switch]
    $Force,

    [Switch]
    $NoWSLCheck,
    
    [Switch]
    $NoProfileCheck,

    [Switch]
    $NoCommandCheck
)

$CannotContinue = $false

$Payload =
"
# <Code inserted by Install-Steam-Locomotive>
function Steam-Locomotive {wsl sl -e}
function Steam-Locomotive-Force {wsl sl}
# </>
"

$HelpText =
"This script helps you use the tremendous `"sl`" program in Windows PowerShell.
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

if (-not $NoWSLCheck.IsPresent) {
    if (-not (Get-Command -Name "wsl" -CommandType "Application" -ErrorAction SilentlyContinue) -and -not $Force.IsPresent) {
        $ErrorMessage = @{
            Message = "You don't have WSL installed. Use -Force to continue anyway."
            Category = "NotInstalled"
        }

        Write-Error @ErrorMessage
        $CannotContinue = $true
    }
}

if (-not $NoProfileCheck.IsPresent) {
    if ((Get-Content $Profile -ErrorAction SilentlyContinue | Select-String "Steam-Locomotive") -and -not $Force) {
        $ErrorMessage = @{
            Message = "Your profile seems to already contain something called `"Steam-Locomotive`". Use -Force to continue anyways."
            Category = "ResourceExists"
        }

        Write-Error @ErrorMessage
        $CannotContinue = $true
    }
}

if (-not $NoCommandCheck.IsPresent) {
    if ((Get-Command -Name "Steam-Locomotive" -ErrorAction SilentlyContinue) -and -not $Force) {
        $ErrorMessage = @{
            Message = "It seems a command named `"Steam-Locomotive`" is already installed. Use -Force to continue anyways."
            Category = "ResourceExists"
        }

        Write-Error @ErrorMessage
        $CannotContinue = $true
    }
}

if ($CannotContinue) {
    exit 1
}

if (-not (wsl command -v sl)) {
    Write-Output "First, install SL."
    wsl sudo apt install sl
}

if (wsl command -v sl) {
    Add-Content $Profile $Payload
    Write-Output "Done!"
}

if (-not (wsl command -v sl)) {
    Write-Output "Failed installing wsl."
    exit
}

Write-Output "Success!"
