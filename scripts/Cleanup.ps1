function CLEANUP() {
    $SYS_DRIVE = $env:SystemDrive.Replace(':','')
    $FREESPACE_BEFORE = Get-PSDrive $SYS_DRIVE | Select -ExpandProperty Free
    $FREESPACE_BEFORE = [Math]::Round($FREESPACE_BEFORE / 1GB, 2)

    $LOCATIONS = @(
        "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations",
        "$env:windir\Logs",
        "$env:windir\System32\LogFiles",
        "$env:SystemDrive\Logs",
        "$env:TEMP",
        "$env:SystemDrive\Temp",
        "$env:windir\Temp",
        "$env:windir\Prefetch",
        "$env:windir\SoftwareDistribution",
        "$env:ProgramData\Microsoft\Windows Defender\Scans\History",
        "$env:ProgramData\Microsoft\Windows Defender\LocalCopy",
        "$env:ProgramData\Microsoft\Windows Defender\Definition Updates\Backup",
        "$env:ProgramData\Microsoft\Windows Defender\Support",
        "$env:ProgramData\Microsoft\Windows Defender\Quarantine",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Code Cache",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Cache",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Cookies",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Extension Cookies",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\File System",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\GPUCache",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\IndexedDB",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Local Storage",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Service Worker",
        "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\ShaderCache",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Cache",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Code Cache",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\File System",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\GPUCache",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\IndexedDB",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Jump List Icons",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Local Storage",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Service Worker",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Session Storage",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\ShaderCache",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Favicons",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\History",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Shortcuts",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Visited Links",
        "$env:USERPROFILE\AppData\Roaming\Opera Software\Opera GX Stable\Web Data",
        "$env:USERPROFILE\AppData\Local\Spotify\Data",
        "${env:ProgramFiles(x86)}\Steam\logs",
        "${env:ProgramFiles(x86)}\Steam\dumps",
        "$env:LOCALAPPDATA\CrashDumps",
        "$env:LOCALAPPDATA\D3DSCache",
        "$env:LOCALAPPDATA\Microsoft\Internet Explorer\Recovery",
        "$env:USERPROFILE\Local Settings\Temporary Internet Files",
        "$env:LOCALAPPDATA\Microsoft\Windows\Caches",
        "$env:LOCALAPPDATA\Microsoft\Windows\WebCache",
        "$env:ProgramData\Microsoft\Diagnosis\EventTranscript",
        "$env:ProgramData\Microsoft\Windows\WER",
        "$env:windir\Panther",
        "$env:windir\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Logs"
        "$env:windir\ServiceProfiles\NetworkService\AppData\Local\PeerDistRepub",
        "$env:windir\ServiceProfiles\NetworkService\AppData\Local\Temp"
    )

    function take_own($file) {
        takeown /f $file /r /d y 2>&1 > $null
        icacls $file /grant Users:F /t /c /q 2>&1 > $null
    }

    function RUN_CLEANMGR() {
        Write-Host "`r`n Running Disk Cleanup... Please wait...`r`n" -ForegroundColor "Green"
            
        #start cleanmgr -Args "/sagerun:1" -WindowStyle Hidden -Wait
        #start cleanmgr -Args "/verlowdisk" -WindowStyle Hidden -Wait
        start cleanmgr -Args "/autoclean" -Wait

        echo " Disk Cleanup Finished Cleaning!`r`n"
    }

    function CLEAN() {
        foreach ($LOCATION in $LOCATIONS) {
            Write-Host "`r`n System Cleaning is running... Please wait, this could take a while...`r`n" -ForegroundColor "Green"
            echo " Removing Temp/Junk Files..."
            echo " Removing files from `"$LOCATION`"`r`n"
            take_own $LOCATION
            Sleep -Milliseconds 500
            ls $LOCATION -Recurse -Force | rm -Force -Recurse 2>&1 > $null
            Clear
        }

        #$DRIVES = @(gdr -PSProvider 'FileSystem' | select -ExpandProperty Root)
        #foreach ($DRIVE in $DRIVES) {
        echo " Searching and removing other junk files..."
        @("*.log", "*.tmp", "*.gid", "*.chk", "*.old", "*.dmp", "*.wci") | % { ls "$env:SystemDrive\" -Filter "$_" -Recurse | rm -Force -Recurse 2>&1 > $null }

        echo " Done!`r`n"

        echo " Removing thumbnails cache... "
        ls "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\*.db" -Force | rm -Force -Recurse 2>&1 > $null
        rm "HKCU:\SOFTWARE\Classes\Local Settings\Muicache" -Force -Recurse
        Sleep -Milliseconds 500
        echo " Done!`r`n"

        #REMOVE LEFTOVER INSTALLATION FILES
        echo " Removing Leftover Installation Files..."
        foreach ($item in @('NVIDIA','ATI','AMD','Dell','Intel','HP')) {
            if (Test-Path $item) {
                rm "$env:SystemDrive\$item" -Force -Recurse 2>&1 > $null
            }
        }
        Sleep -Milliseconds 500
        echo " Done!`r`n"
    
        #REMOVE OLD WINDOWS FILES
        echo " Removing Old Windows & Update Files..."
        foreach ($item in @('Windows.old', '`$Windows.~BT', '`$Windows.~WS', '`$Windows.~LS', '`$Windows.~Q')) {
            if (Test-Path $item) {
                take_own "$env:SystemDrive\$item"
                rm "$env:SystemDrive\$item" -Force -Recurse 2>&1 > $null
            }
        }
        Sleep -Milliseconds 500
        echo " Done!`r`n"

        echo " Emptying Recycle Bin..."
        Clear-RecycleBin -Force
        Sleep -Milliseconds 500
        echo " Done!`r`n"

        echo " Cleaning Done!"

        Write-Host "`r`n Free Disk Space Before ($SYS_DRIVE): $FREESPACE_BEFORE GB" -ForegroundColor "DarkYellow"
        $FREESPACE_AFTER = Get-PSDrive C | Select -ExpandProperty Free
        $FREESPACE_AFTER = [Math]::Round($FREESPACE_AFTER / 1GB, 2)
        Write-Host " Free Disk Space After ($SYS_DRIVE): $FREESPACE_AFTER GB" -ForegroundColor "DarkYellow"
        Write-Host " Cleaned up $([Math]::Round(($FREESPACE_AFTER-$FREESPACE_BEFORE), 2)) GB of Junk!`r`n" -ForegroundColor "DarkYellow"
    }

    function SCAN() {
        #RUN KVRT (KASPERSKY VIRUS REMOVAL TOOL)
        echo "Running Kaspersky Virus Removal Tool... Please wait...`r`n"
        Start ".\res\Tools\Antimalware\KVRT.exe" -Args "-d '.' -accepteula -adinsilent -silent -processlevel 2 -dontencrypt -details -noads -allvolumes" -Wait
        echo "KVRT Finished Scanning!`r`n"
        rm "$env:SystemDrive\KVRT*" -Force -Recurse
        #RUN ADWCLEANER
        echo "Running AdwCleaner... Please wait...`r`n"
        Start ".\res\Tools\Antimalware\AdwCleaner.exe" -Args "/eula /scan" -Wait #/clean
        echo "AdwCleaner Finished Scanning!`r`n"
        rm "$env:SystemDrive\AdwCleaner" -Force -Recurse

        #CHECK FOR BACKDOORS
        echo "Checking For Backdoor(s)... Please wait...`r`n"
        rm "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" -Force -Recurse 2>&1>$null
        if ($? -eq $false) {
            echo "No Backdoor(s) found!`r`n"
        } else {
            echo "Backdoor(s) found and removed!...`r`n"
        }
    }


    $CLEANUP_MENU = {
        CENTER_TEXT "WINDOWS CLEANUP`r`n" 10 1
        CENTER_TEXT "_______________" 10 2
        echo "`r`n"
        echo " 1: System Cleanup"
        echo " 2: System Scan"
        echo " 0: Back"
    }

    function CLEANUP_MENU_LOOP() {
        Clear
        do {
            &$CLEANUP_MENU
            $CHOICE = Read-Host ">"
            Clear
        } while ($CHOICE.trim() -notlike '[0-2]')

        if ($CHOICE.trim() -eq 1) {
            Taskkill /F /IM explorer.exe 2>&1 > $null
            #RUN_CLEANMGR
            CLEAN
            Start explorer.exe
            Pause
            CLEANUP_MENU_LOOP
        }
        elseif ($CHOICE.trim() -eq 2) {
            SCAN
            CLEANUP_MENU_LOOP
        }
        elseif ($CHOICE.trim() -eq 0) {
            Return
        }
    }
    
    CLEANUP_MENU_LOOP
    
}