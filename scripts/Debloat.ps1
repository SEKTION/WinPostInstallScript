$APPS_LIST = @(
    "*3dbuilder*",
    "*3dviewer*",
    "*Advertising.Xaml*",
    "*CloudExperienceHost*",
    "*ContentDeliveryManager*",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.BioEnrollment",
    "*bing*",
    "*onenote*",
    "*windowsalarms*",
    "*windowscamera*",
    "*Microsoft.Appconnector*"
    "*Microsoft.549981C3F5F10*",
    #"*Cortana*",
    "*CandyCrushSodaSaga*",
    "*Microsoft.DrawboardPDF*",
    "*Facebook*",
    "*windowscommunicationsapps*",
    "*Microsoft.WindowsFeedbackHub*",
    "*Microsoft.GetHelp*",
    "*Microsoft.Getstarted*",
    "*Microsoft.ZuneMusic*",
    "*Microsoft.WindowsMaps*",
    "*Microsoft.Messaging*",
    "*Todos*",
    "*Microsoft.Whiteboard*",
    "*ConnectivityStore*",
    "*MinecraftUWP*",
    "*Microsoft.MixedReality.Portal*",
    "*Microsoft.OneConnect*",
    "*Microsoft.ZuneVideo*",
    "*Netflix*",
    "*ParentalControls*",
    "*Microsoft.People*",
    "*CommsPhone*",
    "*windowsphone*",
    "*ContactSupport*",
    "*Microsoft.Print3D*",
    "*WindowsScan*",
    "*SecondaryTileExperience*",
    "*Microsoft.SkypeApp*",
    "*Microsoft.ScreenSketch*",
    "*solitairecollection*",
    "*Microsoft.MicrosoftStickyNotes*",
    "*Office.Sway*",
    "*Twitter*",
    "*Microsoft.WindowsSoundRecorder*",
    "*XboxApp*",
    "*Xbox.TCUI*",
    "*XboxOneSmartGlass*",
    "*XboxIdentityProvider*",
    "*Microsoft.XboxSpeechToTextOverlay*",
    "*Microsoft.YourPhone*"
)

$SUGGESTED_CONTENT=@(
    "ContentDeliveryAllowed",
    "FeatureManagementEnabled",
    "OemPreInstalledAppsEnabled",
    "PreInstalledAppsEnabled",
    "PreInstalledAppsEverEnabled",
    "RotatingLockScreenOverlayEnabled",
    "SilentInstalledAppsEnabled",
    "SystemPaneSuggestionsEnabled",
    "SubscribedContentEnabled",
    "SubscribedContent-310093Enabled",
    "SubscribedContent-314559Enabled",
    "SubscribedContent-314563Enabled",
    "SubscribedContent-338387Enabled",
    "SubscribedContent-338388Enabled",
    "SubscribedContent-338389Enabled",
    "SubscribedContent-338393Enabled",
    "SubscribedContent-353694Enabled",
    "SubscribedContent-353696Enabled",
    "SubscribedContent-353698Enabled"
)

function UNINSTALL_WIN_APPS() {
    foreach ($APP in $APPS_LIST) {
        $APPS = Get-AppxPackage $APP | select -ExpandProperty Name
        foreach ($APP_NAME in $APPS) {
            echo "`r`n Uninstalling $APP_NAME..."
            Get-AppxPackage -Name $APP_NAME -AllUsers | Remove-AppxPackage 2>&1 > $null
            sleep -Milliseconds 500
            echo " Removing Provisioned Appx Package..." 
            Get-AppxProvisionedPackage -Online | ? {$_.DisplayName -like $APP_NAME} | Remove-AppxProvisionedPackage -Online 2>&1 > $null
            echo " Done!`r`n"
        }
        sleep -Milliseconds 500
    }

    #DISABLE WINAPPS AUTO REINSTALLATION AND SUGGESTED CONTENT
    echo " Disabling WinApps Auto Reinstallation. Please Wait..."
    foreach ($Item in $SUGGESTED_CONTENT) {
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" $Item 0
    }
    echo " Done!`r`n"

    #UNINSTALL ONE DRIVE
    echo " Uninstalling OneDrive. Please Wait..."
    Stop-Process -Name "OneDrive*" -Force
    if (Test-Path "$env:windir\SysWOW64\OneDriveSetup.exe") {
        Start-Process "$env:windir\SysWOW64\OneDriveSetup.exe" "/uninstall" -NoNewWindow -Wait
    } else {
        Start-Process "$env:windir\System32\OneDriveSetup.exe" "/uninstall" -NoNewWindow -Wait
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1
    echo " Done!`r`n"

    taskkill /F /IM explorer.exe 2>&1>$null
    sleep -Milliseconds 500
    echo " Removing Leftover Files..."
    Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse
	Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
	Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse
    Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse
    Remove-Item "$env:userprofile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -Force
    echo " Done!`r`n"
    echo " Removing Leftover Registry Keys..."
    REG DELETE "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f 2>&1>$null
    REG DELETE "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f 2>&1>$null
    echo " Done!`r`n"
    Start explorer.exe -NoNewWindow 2>&1>$null
    Write-Host " Press any key to continue..." -ForegroundColor "White"
    $HOST.UI.RawUI.ReadKey() | Out-Null
}
 

