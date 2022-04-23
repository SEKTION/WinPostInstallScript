function WINUPDATE() {

    function CHECK_STATUS() {
        $SERV1 = (Get-Service -Name UsoSvc).StartType
        $SERV2 = (Get-Service -Name wuauserv).StartType
        $SERV3 = (Get-Service -Name WaaSMedicSvc).StartType


        if ($SERV1 -eq "Disabled" -and $SERV2 -eq "Disabled" -and $SERV1 -eq "Disabled") {
            Write-Host "`r`n Windows Update is Disabled!`r`n" -ForegroundColor "Yellow"
        } else {
            Write-Host "`r`n Windows Update is Enabled!`r`n" -ForegroundColor "Yellow"
        }
    }

    function DISABLE_WINUPDATE() {
        echo "`r`n Disabling Windows Update..."

        echo "`r`n Stopping $((Get-Service -Name UsoSvc | select DisplayName).DisplayName)"
        Stop-Service -Name UsoSvc -Force -NoWait 2>&1> $null
        sleep -Milliseconds 500
        Set-Service -Name UsoSvc -StartupType Disabled 2>&1> $null
        echo " Done!`r`n"

        echo "`r`n Stopping $((Get-Service -Name wuauserv | select DisplayName).DisplayName)"
        Stop-Service -Name wuauserv -Force -NoWait 2>&1 > $null
        sleep -Milliseconds 500
        Set-Service -Name wuauserv -StartupType Disabled 2>&1 > $null
        echo " Done!`r`n"

        echo "`r`n Stopping $((Get-Service -Name WaaSMedicSvc | select DisplayName).DisplayName)"
        Stop-Service -Name WaaSMedicSvc -Force -NoWait 2>&1 > $null
        sleep -Milliseconds 500
        Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" -Name Start -Value 4
        echo " Done!`r`n"

        echo "`r`n Deleting Update Tasks from Task Scheduler"
        Unregister-ScheduledTask -TaskName "Scheduled Start" -Confirm:$false 2>&1 > $null
        Unregister-ScheduledTask -TaskName "PerformRemediation" -Confirm:$false 2>&1 > $null
        Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" -ErrorActionPreference SilentlyContinue | Unregister-ScheduledTask -Confirm:$false 2>&1 > $null
        sleep -Milliseconds 500
        echo " Done!`r`n"

        echo "`r`n Disabling WU Settings in Registry..."
        New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Value 2 -Force 2>&1 > $null
        New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" -Name "AUOptions" -Value 2 -Force 2>&1 > $null
        New-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\OSUpgrade" -Name "AllowOSUpgrade" -Value 0 -Force 2>&1 > $null
        New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Value 1 -Force 2>&1 > $null
        New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers" -Value 1 -Force 2>&1 > $null
        New-ItemProperty "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Name "DisableWindowsUpdateAccess" -Value 1 -Force 2>&1 > $null
        sleep -Milliseconds 500
        echo " Done!`r`n"

        Write-Host "`r`n Windows Update Disabled Successfully!`r`n" -ForegroundColor "Green"
        Write-Host " Press any key to continue..." -ForegroundColor "White"
        $HOST.UI.RawUI.ReadKey() | Out-Null
    }

    function ENABLE_WINUPDATE() {
        echo "`r`n Enabling Windows Update..."

        echo "`r`n Starting $((Get-Service -Name UsoSvc | select DisplayName).DisplayName)"
        Set-Service -Name UsoSvc -StartupType Manual 2>&1 > $null
        sleep -Milliseconds 500
        Start-Service -Name UsoSvc 2>&1 > $null
        echo " Done!`r`n"

        echo "`r`n Starting $((Get-Service -Name wuauserv | select DisplayName).DisplayName)"
        Set-Service -Name wuauserv -StartupType Manual 2>&1 > $null
        sleep -Milliseconds 500        
        Start-Service -Name wuauserv 2>&1 > $null
        echo " Done!`r`n"

        echo "`r`n Starting $((Get-Service -Name WaaSMedicSvc | select DisplayName).DisplayName)"
        Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" -Name Start -Value 3 2>&1 > $null
        sleep -Milliseconds 500        
        Start-Service -Name WaaSMedicSvc 2>&1 > $null
        echo " Done!`r`n"

        echo "`r`n Resetting WU Registry Settings..."
        Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Recurse -Force 2>&1 > $null
        Remove-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate" -Name "DisableWindowsUpdateAccess" -Force 2>&1 > $null
        sleep -Milliseconds 500
        echo " Done!`r`n"

        Write-Host "`r`n Windows Update Enabled Successfully!`r`n" -ForegroundColor "Green"
        Write-Host " Press any key to continue..." -ForegroundColor "White"
        $HOST.UI.RawUI.ReadKey() | Out-Null
    }

    $UPDATE_MENU = {
        CENTER_TEXT "WINDOWS UPDATE`r`n" 10 1
        CENTER_TEXT "______________" 10 2
        echo "`r`n"
        echo " 1: Check Windows Update Status"
        echo " 2: Disable Windows Update"
        echo " 3: Enable Windows Update"
        echo " 0: Back"
    }

    function UPDATE_MENU_LOOP {
        Clear
        do {
            &$UPDATE_MENU
            $CHOICE = Read-Host ">"
            Clear
        } while ($CHOICE.trim() -notlike '[0-3]')
        
        if ($CHOICE.trim() -eq 1) {
            CHECK_STATUS
            Write-Host " Press any key to continue..." -ForegroundColor "White"
            $HOST.UI.RawUI.ReadKey() | Out-Null
            UPDATE_MENU_LOOP           
        }
        elseif ($CHOICE.trim() -eq 2) {
            DISABLE_WINUPDATE
            UPDATE_MENU_LOOP
        } 
        elseif ($CHOICE.trim() -eq 3) {
            ENABLE_WINUPDATE
            UPDATE_MENU_LOOP
        }
        elseif ($CHOICE.trim() -eq 0) { Return }
    }
    
    UPDATE_MENU_LOOP

}