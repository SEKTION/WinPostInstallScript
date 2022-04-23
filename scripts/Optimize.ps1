function OPTIMIZATION() {

    $SET_ACL = ".\res\Tools\SetACL.exe"

    #CREATE NEW PSDRIVES FOR HKEY_USERS & HKEY_CLASSES_ROOT
    New-PSDrive -Name "HKU" -PSProvider "Registry" -Root "HKEY_USERS"
    New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT"

    function REG_KEY($PATH, $NAME, $VALUE, $TYPE="Dword") {
        New-ItemProperty -Path $PATH -Name $NAME -Value $VALUE -PropertyType $TYPE -Force | Out-Null
    }

    #DISABLE PRIVACY/DATA DIAGNOSTIC/TELEMETRY SETTINGS
    function DISABLE_TELEMETRY() {
        echo "`r`n Disabling Telemetry..."
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0
        REG_KEY "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" "AllowTelemetry" 0
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" "ShowedToastAtLevel" 1
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" "Start" 0
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" "TailoredExperiencesWithDiagnosticDataEnabled" 0
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey" "EnableEventTranscript" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" "AITEnable" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" "DisableInventory" 1
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" "DisableUAR" 1
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "EnableActivityFeed" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "PublishUserActivities" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "UploadUserActivities" 0
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoInstrumentation" 1
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoInstrumentation" 1
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" "CEIPEnable" 0
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" "Start" 0
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" "Start" 0
        
        Sleep -Milliseconds 500

        echo "`r`n Disabling Telemetry in MS Office..."
        REG_KEY "HKCU:\Software\Policies\Microsoft\Office\*\osm" "Enablelogging" 0
        REG_KEY "HKCU:\Software\Policies\Microsoft\Office\*\osm" "EnableUpload" 0
        REG_KEY "HKCU:\Software\Microsoft\Office\Common\ClientTelemetry" "DisableTelemetry" 1

        Sleep -Milliseconds 500

        echo "`r`n Disabling Experimentation..."
        REG_KEY "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\System\AllowExperimentation" "value" 0
        
        #DISABLE BIOMETRICS
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Biometrics" "Enabled" 0

        #DISABLE INK WORKSPACE
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" "AllowWindowsInkWorkspace" 0

        Sleep -Milliseconds 500

        echo "`r`n Disabling Bing & Cortana..."
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCloudSearch" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "ConnectedSearchUseWeb" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "ConnectedSearchUseWebOverMeteredConnections" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "DisableWebSearch" 1

        #DISABLE WEB SEARCH IN TASKBAR
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" 0
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "AllowSearchToUseLocation" 0
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "CortanaConsent" 0
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" "CortanaEnabled" 0

        Sleep -Milliseconds 500

        echo "`r`n Disabling Windows Apps tracking..."
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackProgs" 0

        #ONLINE SPEECH PRIVACY POLICY
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" "HasAccepted" 0

        #INKING & TYPING
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" "AcceptedPrivacyPolicy" 0
        REG_KEY "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitInkCollection" 1
        REG_KEY "HKCU:\SOFTWARE\Microsoft\InputPersonalization" "RestrictImplicitTextCollection" 1     

        Sleep -Milliseconds 500

        echo "`r`n Disabling Feedback, Notifications, Location Access and Diagnostics..."
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" "NumberOfSIUFInPeriod" 0
        Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds"

        #DISABLE NOTIFICATIONS
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" "Value" "Deny" "String"

        #DISABLE LOCATION ACCESS
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" "Value" "Deny" "String"

        #APP DIAGNOSTICS
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" "Value" "Deny" "String"

        #DISABLE ACCOUNT INFO ACCESS
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" "Value" "Deny" "String"

        #DISABLE CLIPBOARD HISTORY
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "AllowClipboardHistory" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" "AllowCrossDeviceClipboard" 0

        #DISABLE FIND MY DEVICE
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Settings\FindMyDevice" "LocationSyncEnabled" 0

        Sleep -Milliseconds 500

        echo "`r`n Disabling Sync Settings..."
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "SyncPolicy" 5
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" "Enabled" 0
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" "Enabled" 0
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" "Enabled" 0
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" "Enabled" 0
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" "Enabled" 0

        #DISABLE DEFENDER AUTOMATIC SAMPLE SUBMISSION
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows Defender\Spynet" "SpynetReporting" 0
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows Defender\Spynet" "SubmitSamplesConsent" 0

        Sleep -Milliseconds 500
        Write-Host "`r`n Telemetry Disabled!`r`n" -ForegroundColor "Green"
        Write-Host " Press any key to continue..." -ForegroundColor "White"
        $HOST.UI.RawUI.ReadKey() | Out-Null
    }

    #DISABLE SEARCHBOX SUGGESTIONS/HISTORY
    function DISABLE_SUGGESTED_CONTENT() {
        echo "`r`n Disabling Windows Suggested Content/Ads..."
        REG_KEY "HKCU:\Software\Policies\Microsoft\Windows\Explorer" "DisableSearchBoxSuggestions" 1

        #DISABLE STARTMENU CONSUMER FEATURES
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" 1

        #DISABLE ONLINE/WINDOWS TIPS
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "AllowOnlineTips" 0
        REG_KEY "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" 1
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" 0

        #DISABLE LOOK FOR APP IN MS STORE
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoUseStoreOpenWith" 1

        Sleep -Milliseconds 500

        echo "`r`n Disabling WindowsApps Silent Installation..."
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SilentInstalledAppsEnabled" 0

        #DISABLE MSSTORE AUTO UPDATES
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" "AutoDownload" 2
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" "DisableOSUpgrade" 1

        #DISABLE LIVE TILES
        REG_KEY "HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" "NoTileApplicationNotification" 1

        #DISABLE ADVERTISING INFO
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0

        Sleep -Milliseconds 500

        echo "`r`n Excluding Drivers from Windows Update..."
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" "SearchOrderConfig" 0
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" "PreventDeviceMetadataFromNetwork" 1
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" "ExcludeWUDriversInQualityUpdate" 1
        REG_KEY "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Update" "ExcludeWUDriversInQualityUpdate" 1
        REG_KEY "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Update" "ExcludeWUDriversInQualityUpdate" 1
        REG_KEY "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" "ExcludeWUDriversInQualityUpdate" 1

        #DISABLE MRT INSTALLATION THROUGH WINUPDATE
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\MRT" "DontOfferThroughWUAU" 1

        #DISABLE DELIVERY OPTIMIZATION P2P UPDATE DOWNLOADS
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" "DODownloadMode" 0

        Sleep -Milliseconds 500
        Write-Host "`r`n Done!`r`n" -ForegroundColor "Green"
        Write-Host " Press any key to continue..." -ForegroundColor "White"
        $HOST.UI.RawUI.ReadKey() | Out-Null
    }

    function OPTIMIZE_BOOT() {
        echo "`r`n Optimizing Windows Timeouts..."
        
        #APP KILL TIMEOUT BEFORE SHUTDOWN
        REG_KEY "HKCU:\Control Panel\Desktop" "WaitToKillAppTimeout" 2000 "String"

        #SERVICE KILL TIMEOUT BEFORE SHUTDOWN
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control" "WaitToKillServiceTimeout" 2000 "String"

        Sleep -Milliseconds 500

        echo "`r`n Disabling Prefetch & Superfetch..."
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnablePrefetcher" 0
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableSuperfetch" 0
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" "EnableBoottrace" 0

        #DISABLE STARTUP APPS DELAY
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "Startupdelayinmsec" 0

        Sleep -Milliseconds 500

        echo "`r`n Disabling Edge Preloading..."
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" "AllowPrelaunch" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" "AllowTabPreloading" 0

        echo "`r`n Optimizing Boot Settings..."

        #DISABLE BOOT DEFRAG
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Dfrg\BootOptimizeFunction" "Enable" "N" "String"

        #ENABLE VERBOSE BOOT/SHUTDOWN
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" "VerboseStatus" 1

        #SET BIOS TIME TO UTC
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" "RealTimeIsUniversal" 1

        #ENABLE NUMLOCK AT BOOT
        REG_KEY "HKU:\.DEFAULT\Control Panel\Keyboard" "InitialKeyboardIndicators" 2147483650 "String"

        #DISABLE STARTUP APPS RUNNING DELAY
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "Startupdelayinmsec" 0

        #BOOT PROGRESS ANIMATION
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\BootControl" "BootProgressAnimation" 1

        #BOOT TIMEOUT
        bcdedit /timeout 10 2>&1>$null

        #DISABLE BOOT SCREEN ANIMATION
        bcdedit /set bootuxdisabled on 2>&1>$null
        bcdedit /set quietboot on 2>&1>$null

        #DISABLE AUTOMATIC RESTART ON CRASH
        bcdedit /set nocrashautoreboot on 2>&1>$null

        #ENABLE F8 ADVANCED BOOT MENU
        #bcdedit /set displaybootmenu yes 2>&1>$null
        #bcdedit /set bootmenupolicy legacy 2>&1>$null
        #bcdedit /set bootmenupolicy standard 2>&1>$null

        #OTHER BCDEDIT SETTINGS
        #bcdedit /set sos on 2>&1>$null #DRIVER LOAD DISPLAY
        #bcdedit /set winpe on 2>&1>$null #BOOT TO WINDOWS PE
        #bcdedit /set onetimeadvancedoptions on 2>&1>$null #BOOT TO ADVANCED OPTIONS ON NEXT BOO

        Sleep -Milliseconds 500

        #DISABLE HIBERNATION BUT KEEP FAST STARTUP
        echo "`r`n Disabling Hibernation..."
        powercfg /h /type reduced 2>&1>$null

        Write-Host "`r`n Done! Restarting Explorer...`r`n" -ForegroundColor "Green"
        Taskkill /F /IM explorer.exe 2>&1 > $null
        Sleep -Milliseconds 500
        Start explorer.exe -NoNewWindow 2>&1 > $null

        Write-Host " Press any key to continue..." -ForegroundColor "White"
        $HOST.UI.RawUI.ReadKey() | Out-Null
        
    }

    function GAMING_PERF_OPTIMIZE() {
        echo "`r`n Optimizing for Gaming..."

        #DISABLE POWER THROTTLING
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" "PowerThrottlingOff" 1

        #INCREASE SYSTEM RESPONSIVENESS (GAMING/MULTIMEDIA)
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" 0xffffffff
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" 0
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NoLazyMode" 1

        Sleep -Milliseconds 500

        echo "`r`n Setting Higher Priority for Games..."
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Affinity" 0
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Clock Rate" 0x2710
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "GPU Priority" 0x12
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Priority" 6
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Scheduling Category" "High" "String"
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "SFIO Priority" "High" "String"
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Latency Sensitive" "True" "String"

        #INCREASE DISPLAY POST PROCESSING PRIORITY
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" "BackgroundPriority" 24
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" "GPU Priority" 18
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" "Priority" 8
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" "Scheduling Category" "High" "String"
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" "SFIO Priority" "High" "String"
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\DisplayPostProcessing" "Latency Sensitive" "True" "String"

        Sleep -Milliseconds 500

        ################################## DISABLE FULL SCREEN OPTIMIZATIONS GLOBALLY #####################################################

        echo "`r`n Disabling Full Screen Optimizations..."
        REG_KEY "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 0
        REG_KEY "HKCU:\System\GameConfigStore" "GameDVR_DSEBehavior" 2
        REG_KEY "HKCU:\System\GameConfigStore" "GameDVR_EFSEFeatureFlags" 0
        REG_KEY "HKCU:\System\GameConfigStore" "GameDVR_FSEBehaviorMode" 2
        REG_KEY "HKCU:\System\GameConfigStore" "GameDVR_FSEBehavior" 2
        REG_KEY "HKCU:\System\GameConfigStore" "GameDVR_HonorUserFSEBehaviorMode" 1
        REG_KEY "HKCU:\System\GameConfigStore" "GameDVR_DXGIHonorFSEWindowsCompatible" 1
        REG_KEY "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR" "value" 0
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"  "AllowGameDVR" 0
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" "AppCaptureEnabled" 0
        Remove-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "Win32_AutoGameModeDefaultProfile" -Force
        Remove-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "Win32_GameModeRelatedProcesses" -Force
        REG_KEY "HKCU:\SOFTWARE\Microsoft\GameBar" "ShowStartupPanel" 0
        REG_KEY "HKCU:\SOFTWARE\Microsoft\GameBar" "GamePanelStartupTipIndex" 3
        REG_KEY "HKCU:\SOFTWARE\Microsoft\GameBar" "AllowAutoGameMode" 1
        REG_KEY "HKCU:\SOFTWARE\Microsoft\GameBar" "AutoGameModeEnabled" 1
        REG_KEY "HKCU:\SOFTWARE\Microsoft\GameBar" "UseNexusForGameBarEnabled" 0 #DISABLE OPEN GAMEBAR WITH CONTROLLER

        #CHECK "DISABLE FULL SCREEN OPTIMIZATIONS" CHECKBOX
        $EXE_PATHS = @(Get-ItemProperty -Path "HKCU:\System\GameConfigStore\Children\*" -Name "MatchedExeFullPath" | select -ExpandProperty "MatchedExeFullPath")
        foreach ($PATH in $EXE_PATHS) {
            if ($PATH.contains('Game')) {
                REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$PATH" "~ RUNASADMIN DISABLEDXMAXIMIZEDWINDOWEDMODE DISABLETHEMES DISABLEDWM" "String"
            }
        }

        #REMOVE GAMES FROM FSO 
        Get-ItemProperty -Path "HKCU:\System\GameConfigStore\Children\*" -Name "MatchedExeFullPath" | select -ExpandProperty PSChildName | % { Remove-Item -Path "HKCU:\System\GameConfigStore\Children\$_" }

        ########################################################################################################################################
        
        Sleep -Milliseconds 500

        echo "`r`n Enabling Hardware Accelerated GPU Scheduling..."
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" "HwSchMode" 2

        #MEMORY TWEAKS
        #REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "LargeSystemCache" 1
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "DisablePagingExecutive" 1
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "DisablePagingCombining" 1

        Sleep -Milliseconds 500

        echo "`r`n Disabling Variable Refresh Rate..."
        REG_KEY "HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences" "DirectXUserGlobalSettings" "VRROptimizeEnable=0;" "String"

        Sleep -Milliseconds 500

        echo "`r`n Disabling Unnecessary Background Apps..."
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" "GlobalUserDisabled" 1
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" "BackgroundAppGlobalToggle" 0

        Sleep -Milliseconds 500

        echo "`r`n Setting up StandbyList Cleaner & Windows Timer Resolution..."
        #INSTALLING ISLC
        & '.\res\Tools\ISLC.exe' -o"$env:ProgramFiles\ISLC" -y
        #STARTING ISLC
        & "$env:ProgramFiles\ISLC\Intelligent standby list cleaner ISLC.exe" #-minimized -polling 500 -listsize 512 -freememory 8000

        Sleep -Milliseconds 500

        echo "`r`n Enabling Ultimate Power Plan..."
        Powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>&1 > $null
        Powercfg -setactive 4ad99b5a-6a83-4d04-89e6-0a971b2a4180 2>&1 > $null
        
        #Delete High Performance & Power Save Power Plans 
        Powercfg -delete  8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>&1 > $null
        Powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a 2>&1 > $null

        #SET EnergyPerformancePreference TO PERFORMANCE MODE
        Powercfg -setacvalueindex scheme_current sub_processor PERFEPP 0 2>&1 > $null
        #Powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 1 # 1: Enabled 2:Aggressive
        Powercfg -setactive scheme_current
        
        Sleep -Milliseconds 500

        echo "`r`n Disabling Core Parking..."
        Powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100 2>&1 > $null
        #DISABLE PROCESSOR FREQUENCY CAP
        Powercfg -setacvalueindex scheme_current sub_processor PROCFREQMAX 0 2>&1 > $null
        #SET MIN/MAX PROCESSOR STATE
        Powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100 2>&1 > $null
        Powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100 2>&1 > $null
        #APPLY SETTINGS
        Powercfg -setactive scheme_current 2>&1>$null

        Sleep -Milliseconds 500

        echo "`r`n Disabling HPET (HIGH PRECISION EVENT TIMER)..." 
        bcdedit /set disabledynamictick yes 2>&1 > $null
        bcdedit /deletevalue useplatformclock 2>&1 > $null
        #bcdedit /set useplatformtick yes 2>&1 > $null

        Sleep -Milliseconds 500

        ########################### DISABLE NVIDIA HDCP & DYNAMIC P-STATES ######################################
        echo "`r`n Disabling Nvidia HDCP and Dynamic P-States..."

        $RESULT = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\*" -Name "DriverDesc" | select DriverDesc, PSChildName
        if ($RESULT | % {$_.DriverDesc -match 'Nvidia GeForce'}) {
            $ID = $RESULT | % {$_.PSChildName}
        }
        if ($ID) {
            REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\$ID" "RMHdcpKeyglobZero" 1 
            REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\$ID" "DisableDynamicPstate" 1 
        }
        
        Sleep -Milliseconds 500

        echo "`r`n Optimizing Mouse/Keyboard Input Latency..."
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" "MouseDataQueueSize" 20
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" "KeyboardDataQueueSize" 20

        Sleep -Milliseconds 500

        echo "`r`n Disabling System Restore..."
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" "DisableSR" 1

        Write-Host "`r`n Done! Restarting Explorer...`r`n" -ForegroundColor "Green"
        Taskkill /F /IM explorer.exe 2>&1 > $null
        Sleep -Milliseconds 500
        Start explorer.exe -NoNewWindow 2>&1 > $null
        
        Write-Host " Press any key to continue..." -ForegroundColor "White"
        $HOST.UI.RawUI.ReadKey() | Out-Null

    }

    function OPTIMIZE_WINDOWS() {
        echo "`r`n Optimizing Windows Timeouts..."
        
        #DECREASE MENU SHOW DELAY
        REG_KEY "HKCU:\Control Panel\Desktop" "MenuShowDelay" 0 "String"
    
        #APP KILL TIMEOUT/AUTO END NON-RESPONSIVE TASKS
        REG_KEY "HKCU:\Control Panel\Desktop" "HungAppTimeout" 3000 "String"
        REG_KEY "HKCU:\Control Panel\Desktop" "AutoEndTasks" 1 "String"
        REG_KEY "HKCU:\Control Panel\Desktop" "LowLevelHooksTimeout" 1000 "String"
        
        Sleep -Milliseconds 500

        echo "`r`n Setting High Priority for Foreground Programs..."
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" 0x26

        Sleep -Milliseconds 500

        ############################## FILE EXPLORER TWEAKS ############################################
        
        echo "`r`n Applying File Explorer Tweaks..."

        #SET EXPLORER TO OPEN THIS PC
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" 1
        
        #DISABLE LOW DISK WARNINGS
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoLowDiskSpaceChecks" 1

        #DO NOT TRACK SHELL SHORTCUTS
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "LinkResolveIgnoreLinkInfo" 1
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoResolveSearch" 1
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoResolveTrack" 1

        #DISABLE NEW APP SUGGESTION
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" "NoNewAppAlert" 1

        #DISABLE INTERNET FILE ASSOCIATION SERVICE
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoInternetOpenWith" 1

        #SHOW HIDDEN FILES AND FILE EXTENSIONS
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Hidden" 1
        #REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSuperHidden" 1
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "HideFileExt" 0
        
        #DISABLE SyncProviderNotifications
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ShowSyncProviderNotifications" 0

        #DISABLE WINDOWS NETWORKING CRAWLING
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "nonetcrawling" 1

        #DISABLE SHOWING LAST USED FILES & FOLDERS
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" -Force
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3936E9E4-D92C-4EEE-A85A-BC16D5EA0819}" -Force

        #ENABLE AUTOCOMPLETE
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete" "Append Completion" "Yes" "String"

        #INCREASE NUMBER OF FOLDER VIEWS TO REMEMBER
        REG_KEY "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell" "BagMRU Size" 20000

        #REMOVE QUICK ACCESS FROM NAVIGATION PANE
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" "HubMode" 1

        #ENABLE LONG PATH NAMES
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" "LongPathsEnabled" 1

        #DISABLE FILE HISTORY
        REG_KEY "HKLM:\SOFTWARE\Policies\Microsoft\Windows\FileHistory" "Disabled" 1

        #DELETE 3D FOLDER
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Force
        Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Force

        #DISABLE DOUBLE DRIVES IN NAVIGATION PANE
        Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" -Force
        Remove-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" -Force

        #SETTING FOLDER VIEWS
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{885A186E-A440-4ADA-812B-DB871B942259}" "Mode" 4
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\Shell\Bags\AllFolders\Shell\{885A186E-A440-4ADA-812B-DB871B942259}" "GroupView" 0
        REG_KEY "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\*\Shell" "SniffedFolderType" "Pictures" "String"
        REG_KEY "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\*\Shell\Inherit" "FolderType" "Pictures" "String"
        
        ################################################################################################
        
        Sleep -Milliseconds 500

        echo "`r`n Optimizing Desktop..."
        
        #SPEED UP START MENU SEARCH
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_SearchFiles" 0

        #100% WALLPAPER QUALITY
        REG_KEY "HKCU:\Control Panel\Desktop" "JPEGImportQuality" 100

        #FIX DPI SCALING & BLURRYNESS
        REG_KEY "HKCU:\Control Panel\Desktop" "Win8DpiScaling" 0
        REG_KEY "HKCU:\Control Panel\Desktop" "DpicalingVer" 0x1000
        REG_KEY "HKCU:\Control Panel\Desktop" "LogPixels" 96
        
        #HIDE PEOPLE ICON
        REG_KEY "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" "PeopleBand" 0

        #DISABLE AERO SHAKE
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "DisallowShaking" 1

        #DISABLE JUMP LISTS
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "Start_TrackDocs" 0

        #DISABLE PEOPLE BAR
        REG_KEY "HKCU:\Software\Policies\Microsoft\Windows\Explorer" "HidePeopleBar" 1

        Sleep -Milliseconds 500

        echo "`r`n Disabling Keyboard Shortcuts for Sticky, Toggle and Filter keys..."
        REG_KEY "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" 506 "String"
        REG_KEY "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" 34 "String"
        REG_KEY "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" 2 "String"

        Sleep -Milliseconds 500

        echo "`r`n Disabling Remote Assistance..."
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" "fAllowFullControl" 0
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" "fAllowToGetHelp" 0

        Sleep -Milliseconds 500

        echo "`r`n Increasing SVCHOST Split Threshold..."
        $RAM_SIZE = (Get-CimInstance -ClassName 'Cim_PhysicalMemory' | Measure-Object -Property Capacity -Sum).Sum /1GB
        if ($RAM_SIZE -like '[1-4]') {
            REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control" "SvcHostSplitThresholdInKB" 68764420
        } elseif ($RAM_SIZE -like '[5-8]') {
            REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control" "SvcHostSplitThresholdInKB" 137922056
        } elseif ($RAM_SIZE -like '[9-16]') {
            REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control" "SvcHostSplitThresholdInKB" 376926742
        } else {
            REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control" "SvcHostSplitThresholdInKB" 861226034
        }

        Sleep -Milliseconds 500

        echo "`r`n Disabling Mouse Acceleration/Precision..."
        REG_KEY "HKCU:\Control Panel\Mouse" "MouseSensitivity" 10 "String"
        REG_KEY "HKCU:\Control Panel\Mouse" "SmoothMouseXCurve" ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xC0,0xCC,0x0C,0x00,0x00,0x00,0x00,0x00,0x80,0x99,0x19,0x00,0x00,0x00,0x00,0x00,0x40,0x66,0x26,0x00,0x00,0x00,0x00,0x00,0x00,0x33,0x33,0x00,0x00,0x00,0x00,0x00)) "Binary"
        REG_KEY "HKCU:\Control Panel\Mouse" "SmoothMouseYCurve" ([byte[]](0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x38,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x70,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xA8,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xE0,0x00,0x00,0x00,0x00,0x00)) "Binary"
        REG_KEY "HKU:\.DEFAULT\Control Panel\Mouse" "MouseSpeed" 0 "String"
        REG_KEY "HKU:\.DEFAULT\Control Panel\Mouse" "MouseThreshold1" 0 "String"
        REG_KEY "HKU:\.DEFAULT\Control Panel\Mouse" "MouseThreshold2" 0 "String"

        Sleep -Milliseconds 500

        echo "`r`n Disabling '-Shortcut' Suffix from Shortcuts..."
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" "link" ([byte[]](0x00,0x00,0x00,0x00)) "Binary"
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" -Name "ShortcutNameTemplate"

        Sleep -Milliseconds 500

        echo "`r`n Removing Shortcut Arrows..."
        copy -Force ".\res\empty.ico" "$env:ProgramData"
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" "29" "$env:ProgramData\empty.ico" "String"

        Sleep -Milliseconds 500

        echo "`r`n Disabling Error Reporting..."
        REG_KEY "HKCU:\Software\Microsoft\Windows\Windows Error Reporting" "Disabled" 1

        Sleep -Milliseconds 500

        echo "`r`n Enabling Dark Theme..."
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "AppsUseLightTheme" 0
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "EnableTransparency" 1
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "SystemUsesLightTheme" 0

        Sleep -Milliseconds 500

        echo "`r`n Disabling Auto Maintenance..."
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" "MaintenanceDisabled" 1

        Sleep -Milliseconds 500

        echo "`r`n Disabling Ease of Access Features..."
        REG_KEY "HKCU:\Control Panel\Accessibility\MouseKeys" "Flags" 0 "String"
        REG_KEY "HKCU:\Control Panel\Accessibility\StickyKeys" "Flags" 0 "String"
        REG_KEY "HKCU:\Control Panel\Accessibility\Keyboard Response" "Flags" 0 "String"
        REG_KEY "HKCU:\Control Panel\Accessibility\ToggleKeys" "Flags" 0 "String"

        Sleep -Milliseconds 500

        #DISABLE HIBERNATION
        #echo "`r`n Disabling Hibernation..."
        #REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\Power" "HibernateEnabled" 0
        #Sleep -Milliseconds 500

        echo "`r`n Setting All Connections Metered..."
        &$SET_ACL -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" -ot reg -actn setowner -ownr "n:Administrators" 2>&1 > $null
        &$SET_ACL -on "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" -ot reg -actn ace -ace "n:Administrators;p:full" 2>&1 > $null
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" "Default" 2
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" "Ethernet" 2
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\DefaultMediaCost" "WiFi" 2

        Sleep -Milliseconds 500

        echo "`r`n Enabling SSD Trim..."
        fsutil behavior set DisableDeleteNotify 0 2>&1 > $null

        Sleep -Milliseconds 500

        echo "`r`n Disabling NTFS Last Access Time..."
        fsutil behavior set disableLastAccess 1 2>&1 > $null

        Sleep -Milliseconds 500

        echo "`r`n Disabling Creation of 8.3 Names.."
        fsutil behavior set disable8dot3 1 2>&1 > $null

        Sleep -Milliseconds 500

        echo "`r`n Disabling Visual Effects..."
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" 3
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewShadow" 0
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "TaskbarAnimations" 0
        REG_KEY "HKCU:\Software\Microsoft\Windows\DWM" "EnableAeroPeek" 0
        REG_KEY "HKCU:\Control Panel\Desktop\WindowMetrics" "MinAnimate" 0 "String"
        REG_KEY "HKCU:\Control Panel\Desktop" "UserPreferencesMask" ([byte[]](0x90,0x12,0x03,0x90,0x10)) "Binary"

        Sleep -Milliseconds 500

        echo "`r`n Adding 'Clear Clipboard' to Desktop Context Menu.."
        REG ADD "HKCR\DesktopBackground\Shell\Clear Clipboard\command" /d "cmd /c echo off | clip" /f 2>&1>$null

        Sleep -Milliseconds 500

        echo "`r`n Adding 'Classic System Properties' to Desktop Context Menu..."
        REG_KEY "HKCR:\DesktopBackground\Shell\System Properties" "Icon" "sysdm.cpl" "String"
        REG_KEY "HKCR:\DesktopBackground\Shell\System Properties" "Position" "Bottom" "String"
        REG ADD "HKCR\DesktopBackground\Shell\System Properties\command" /d "explorer shell:::{BB06C0E4-D293-4f75-8A90-CB05B6477EEE}" /f 2>&1>$null

        Sleep -Milliseconds 500

        echo "`r`n Applying Some Misc Optimizations..."
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" "CrashDumpEnabled" 0

        #DISABLE SHARE ACROSS DEVICES
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP" "CdpSessionUserAuthzPolicy" 0
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP" "NearShareChannelUserAuthzPolicy" 0
        REG_KEY "HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP" "RomeSdkChannelUserAuthzPolicy" 0

        #DISABLE WMP AUTO CODEC DOWNLOAD
        REG_KEY "HKCU:\Software\Policies\Microsoft\WindowsMediaPlayer" "PreventCodecDownload" 1

        #SHOW BSOD DETAILS INSTEAD OF :(
        REG_KEY "HKLM:\System\CurrentControlSet\Control\CrashControl" "DisplayParameters" 1
        
        #DISABLE TOUCH FEEDBACK
        REG_KEY "HKCU:\Control Panel\Cursors" "ContactVisualization" 0
        REG_KEY "HKCU:\Control Panel\Cursors" "GestureVisualization" 0

        #DISABLE RSC(Receive Segment Coalescing) FOR ALL ADAPTERS
        Disable-NetAdapterRsc -Name * 2>&1>$null

        #DISABLE AUDIO AUTOLEVELLING
        REG_KEY "HKCU:\Software\Microsoft\Multimedia\Audio" "UserDuckingPreference" 3

        #DISABLE WIFI SENSE
        REG_KEY "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" "AutoConnectAllowedOEM" 0

        #DISABLE BLOCKING OF DOWNLOADED FILES
        REG_KEY "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" "SaveZoneInformation" 1

        #IMPROVE NETWORK SPEED BY INCREASING IRPSTACKSIZE
        REG_KEY "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" "IRPStackSize" 32

        Sleep -Milliseconds 500

        echo "`r`n Disabling Windows Optional Features..."
        Disable-WindowsOptionalFeature -Online -FeatureName "WorkFolders-Client" -NoRestart *>&1>$null
        Disable-WindowsOptionalFeature -Online -FeatureName "Printing-XPSServices-Features" -NoRestart *>&1>$null
        Disable-WindowsOptionalFeature -Online -FeatureName "Printing-Foundation-Features" -NoRestart *>&1>$null
        Disable-WindowsOptionalFeature -Online -FeatureName "MediaPlayback" -NoRestart *>&1>$null
        Disable-WindowsOptionalFeature -Online -FeatureName "WindowsMediaPlayer" -NoRestart *>&1>$null
        Disable-WindowsOptionalFeature -Online -FeatureName "Internet-Explorer-Optional-amd64" -NoRestart *>&1>$null

        ENABLE DIRECTPLAY
        Enable-WindowsOptionalFeature -Online -All -FeatureName DirectPlay -NoRestart

        Sleep 1

        Write-Host "`r`n All Done! Restarting Explorer..." -ForegroundColor "Green"

        #RESTART EXPLORER
        Taskkill /F /IM explorer.exe 2>&1 > $null
        Sleep -Milliseconds 500
        Start explorer.exe -NoNewWindow 2>&1 > $null
        Sleep 1

        #RESTART WINDOWS
        Write-Host "`r`n Some Optimizations require a restart to take effect" -ForegroundColor "DarkYellow"
        $CHOICE = Read-Host " Do you want to Restart Computer?(Y/N)"
        if ($CHOICE.trim() -eq "y") {
            Restart-Computer -Force
            Exit
        }

    }

    $OPTIMIZATION_MENU = {
        CENTER_TEXT "WINDOWS OPTIMIZATION`r`n" 10 1
        CENTER_TEXT "____________________" 10 2
        echo "`r`n"
        echo " 1: Disable Telemetry"
        echo " 2: Disable Online/Suggested Content"
        echo " 3: Optimize Boot & Shutdown"
        echo " 4: Optimize Gaming Performance"
        echo " 5: Optimize Windows"
        echo " 0: Back"
    }

    function OPTI_MENU_LOOP() {
        Clear
        do {
            &$OPTIMIZATION_MENU
            $CHOICE = Read-Host ">"
            Clear
        } while ($CHOICE.trim() -notlike '[0-5]')

        if ($CHOICE.trim() -eq 1) { DISABLE_TELEMETRY; OPTI_MENU_LOOP } 
        elseif ($CHOICE.trim() -eq 2) { DISABLE_SUGGESTED_CONTENT; OPTI_MENU_LOOP } 
        elseif ($CHOICE.trim() -eq 3) { OPTIMIZE_BOOT; OPTI_MENU_LOOP } 
        elseif ($CHOICE.trim() -eq 4) { GAMING_PERF_OPTIMIZE; OPTI_MENU_LOOP } 
        elseif ($CHOICE.trim() -eq 5) { OPTIMIZE_WINDOWS; OPTI_MENU_LOOP } 
        elseif ($CHOICE.trim() -eq 0) { Return }
    }

    OPTI_MENU_LOOP

}