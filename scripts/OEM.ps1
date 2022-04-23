function OEM_INFO() {

    function CHANGE_PC_NAME() {
        $NAME = Read-Host "`r`nEnter New Name"
        $DESCRIPTION = Read-Host "Enter New Description"
        Rename-Computer -NewName $NAME -Force *>&1>$null
        New-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Services\LanmanServer\Parameters" -Name "srvcomment" -Value $DESCRIPTION -PropertyType "String" -Force *>&1>$null
        echo "`r`nChanges Updated Successfully! Restart Computer for these to take effect`r`n"
        Pause
    }

    function REGISTERED_OWNER() {
        Write-Host "`r`nCurrent Registered Owner: $((Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name 'RegisteredOwner').RegisteredOwner)`r`n" -ForegroundColor "DarkYellow"
        $OWNER = Read-Host "Enter New Name"
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "RegisteredOwner" -Value $OWNER -Force | Out-Null
        echo "`r`nSUCCESS! New Registered Owner is $OWNER`r`n"
        Pause
    }

    function MISC() {
        $MANUFACTURER = Read-Host "`r`nEnter Manufacturer Name"
        $MODEL = Read-Host "Enter Model Name"
        $LOGO = Read-Host "Enter Logo Image Path"
        New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Manufacturer" -Value $MANUFACTURER -PropertyType "String" -Force | Out-Null
        New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Model" -Value $MODEL -PropertyType "String" -Force | Out-Null
        New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Logo" -Value $LOGO -PropertyType "String" -Force | Out-Null
        echo "`r`nOEM Info Updated Successfully!`r`n"
        Pause
    }

    $OEM_MENU = {
        CENTER_TEXT "CHANGE OEM INFO`r`n" 10 1
        CENTER_TEXT "_______________" 10 2
        echo "`r`n"
        echo " 1: Change Computer Name/Description"
        echo " 2: Change Registered Owner"
        echo " 3: Change Other OEM Info"
        echo " 0: Back"
    }

    function OEM_MENU_LOOP() {
        Clear
        do {
            &$OEM_MENU
            $CHOICE = Read-Host ">"
            Clear
        } while ($CHOICE.trim() -notlike '[0-3]')
    
    if ($CHOICE.trim() -eq 1) { CHANGE_PC_NAME; OEM_MENU_LOOP }
    elseif ($CHOICE.trim() -eq 2) { REGISTERED_OWNER; OEM_MENU_LOOP }
    elseif ($CHOICE.trim() -eq 3) { MISC; OEM_MENU_LOOP }
    elseif ($CHOICE.trim() -eq 0) { Return }
    }

    OEM_MENU_LOOP

}
