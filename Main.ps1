####################### Script Setup ##################################

$ErrorActionPreference="SilentlyContinue"

. .\scripts\Cleanup.ps1
. .\scripts\InstallApps.ps1
. .\scripts\Optimize.ps1
. .\scripts\OEM.ps1
. .\scripts\Services.ps1
. .\scripts\WinUpdate.ps1
. .\scripts\ScheduledTasks.ps1
. .\scripts\Debloat.ps1

$MAS = ".\scripts\MAS_1.4_AIO.cmd"


####################### Check Admin ###################################

net session 2>&1> $null
$IS_ADMIN = $?

if (-not $IS_ADMIN) {
    #Start-Process powershell.exe -Args "-NoNewWindow -NoProfile -File ""$PSCommandPath""" -windowstyle hidden -Verb RunAs
    Write-Host "This script needs to be run as Administrator"  -ForegroundColor Red
    exit
}


##################### Console Window Setup ############################

$NEW_WINDOW_SIZE = $HOST.UI.RawUI.WindowSize
$NEW_WINDOW_SIZE.Width = 98
$NEW_WINDOW_SIZE.Height = 30
$HOST.UI.RawUI.WindowSize = $NEW_WINDOW_SIZE

$NEW_BUFFER_SIZE = $HOST.UI.RawUI.BufferSize
$NEW_BUFFER_SIZE.Width = 98
$NEW_BUFFER_SIZE.Height = 3000
$HOST.UI.RawUI.BufferSize = $NEW_BUFFER_SIZE

$HOST.UI.RawUI.ForegroundColor = "Blue"
$HOST.UI.RawUI.BackgroundColor = "Black"

###################### Install Chocolatey ###############################

if(-Not $(Test-Path $env:ChocolateyInstall)) {
    echo "Setting up for first use...Please wait...`r`n"
    echo "Installing Chocolatey..."
    try {
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    catch {
        Write-Host "Error installing Chocolatey! Please check your internet connection`r`n"
        Exit
    }
    Sleep 1
    echo "Configuring Chocolatey..."
    choco feature enable -n allowGlobalConfirmation > $null
    choco install gsudo > $null
    copy -Force ".\res\Profiles\Profile.ps1" "$env:USERPROFILE\Documents\WindowsPowershell\"
    echo "All Done!`r`n"
}

######################### Main-Menu Loop #################################

function CENTER_TEXT([string]$text, [int]$minusx, [int]$y) {
    $x = $Host.UI.RawUI.MaxWindowSize.Width /2  
	$Host.UI.RawUI.CursorPosition = @{ X = ($x - $minusx); Y = $y }
	#$Host.UI.Write($text)
	Write-Host $text -ForegroundColor "Red"
}


$MENU = {
    CENTER_TEXT "WINDOWS POST INSTALLTION SETUP SCRIPT`r`n" 20 1
    CENTER_TEXT "           Author: SEKTION`r`n" 20 2
    CENTER_TEXT "            Version: 1.0" 20 3
    echo "`r`n"
    echo " 1: Install Software"
    echo " 2: Disable Unnecessary Windows Services"
    echo " 3: Delete Unnecessary Scheduled Tasks"
    echo " 4: Uninstall Bloatware"
    echo " 5: Windows Update"
    echo " 6: Windows Optimization"
    echo " 7: Windows Activation"
    echo " 8: Change OEM Info"
    echo " 9: Cleanup"
    echo " 0: Exit"

}

function MENU_LOOP() {
    Clear-Host
    do {
        &$MENU
        $CHOICE = Read-Host ">"
        Clear-Host
    } while ($CHOICE.trim() -notlike '[0-9]')

    if ($CHOICE.trim() -eq 1) { INSTALL_APPS; MENU_LOOP }
    elseif ($CHOICE.trim() -eq 2) { DISABLE_SERVICES; MENU_LOOP }
    elseif ($CHOICE.trim() -eq 3) { DELETE_TASKS; MENU_LOOP }
    elseif ($CHOICE.trim() -eq 4) { UNINSTALL_WIN_APPS; MENU_LOOP }
    elseif ($CHOICE.trim() -eq 5) { WINUPDATE; MENU_LOOP }
    elseif ($CHOICE.trim() -eq 6) { OPTIMIZATION; MENU_LOOP }
    elseif ($CHOICE.trim() -eq 7) { &$MAS ; $Host.UI.RawUI.ForegroundColor="Blue"; MENU_LOOP }
    elseif ($CHOICE.trim() -eq 8) { OEM_INFO; MENU_LOOP }
    elseif ($CHOICE.trim() -eq 9) { CLEANUP; MENU_LOOP }
    elseif ($CHOICE.trim() -eq 0) { Exit }

}

MENU_LOOP

##############################################################################