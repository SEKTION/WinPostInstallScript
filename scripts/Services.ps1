$TELEMETRY_SERVICES = @(
    "DiagTrack",
    "diagsvc",
    "DPS",
    "diagnosticshub.standardcollector.service",
    "dmwappushservice",
    "WdiServiceHost",
    "WdiSystemHost"
)

$APPS_SERVICES = @(
    "AdobeARMservice",
    "AGSService",
    "edgeupdatem",
    "edgeupdate",
    "EpicOnlineServices",
    "GoogleChromeElevationService",
    "gupdate",
    "gupdatem",
    "gusvc",
    "MicrosoftEdgeElevationService",
    "MozillaMaintenance",
    "Origin Web Helper Service"
)

$OTHER_SERVICES = @(
    "AxInstSV",
    "ALG",
    "AJRouter",
    "autotimesvc",
    "BTAGService",
    "BluetoothUserService",
    "BthAvctpSvc",
    "bthserv",
    "CaptureService",
    "cbdhsvc",
    "CDPUserSvc",
    "CertPropSvc",
    "CscService",
    "DoSvc",
    "Fax",
    "fhsvc",
    "FontCache",
    "FontCache3.0.0.0",
    "FrameServer",
    "gcs",
    "GraphicsPerfSvc",
    "HvHost",
    "icssvc",
    "iphlpsvc",
    "IpxlatCfgSvc",
    "lfsvc",
    "lltdsvc",
    "MapsBroker",
    "MSiSCSI",
    "NaturalAuthentication",
    "Netlogon",
    "NcdAutoSetup",
    "Ndu",
    "OneSyncSvc",
    "PcaSvc",
    "PeerDistSvc",
    "perceptionsimulation",
    "PhoneSvc",
    "PimIndexMaintenanceSvc",
    "pla",
    "PrintWorkflowUserSvc",
    "PrintNotify",
    "RetailDemo",
    "RpcLocator",
    "SDRSVC",
    "SEMgrSvc",
    "SensorDataService",
    "SensorService",
    "SensrSvc",
    "SharedAccess",
    "SmsRouter",
    "SSDPSRV",
    "stisvc",
    "Spooler",
    "SysMain",
    "SCardSvr",
    "ScDeviceEnum",
    "SCPolicySvc",
    "SharedRealitySvc",
    "spectrum",
    "TapiSrv",
    "TimeBrokerSvc",
    "VacSvc",
    "vmickvpexchange",
    "vmicguestinterface",
    "vmicshutdown",
    "vmicheartbeat",
    "vmicvmsession",
    "vmicrdv",
    "vmictimesync",
    "vmicvss",
    "VSS",
    "WalletService",
    "WbioSrvc",
    "wcncsvc",
    "Wecsvc",
    "WerSvc",
    "wercplsupport",
    "WiaRpc",
    "WFDSConMgrSvc",    
    "wisvc",    
    "WMPNetworkSvc",
    "WpcMonSvc",
    "WSearch",
    "WwanSvc",
    "XboxGipSvc",
    "XblAuthManager",
    "XblGameSave",
    "XboxNetApiSvc"
)

$MANUAL_SERVICES = @(
    "DevicePickerUserSvc",
    "p2pimsvc",
    "p2psvc",
    "PNRPsvc",
    "QWAVE",
    "RasAuto",
    "RasMan",
    "SessionEnv",
    "ssh-agent",
    "TermService",
    "UmRdpService",
    "UnistoreSvc",
    "UserDataSvc",
    "WinRM",
    "WpnService",
    "WpnUserService"
)

function DISABLE_SVC($SERVICENAME) {
    $DISPLAY_NAME = (Get-Service -Name $SERVICENAME | select DisplayName).DisplayName
    if (!$DISPLAY_NAME.trim() -eq "") {
        $STATUS = (Get-Service -Name $SERVICENAME).StartType
        if ($STATUS -eq "Disabled") {
            echo " `"$DISPLAY_NAME`" is already Disabled...`r`n"
            Return
        } elseif ($STATUS -eq "Manual") {
            echo " `"$DISPLAY_NAME`" is set to Manual, Leaving it as is...`r`n"
            Return
        } elseif ($STATUS -eq "Automatic") {
            echo " `"$DISPLAY_NAME`" is Enabled, Disabling the Service..."
        }
        Stop-Service -Name $SERVICENAME -Force -NoWait 2> $null
        sleep -Milliseconds 500
        Set-Service -Name $SERVICENAME -Status Stopped -StartupType Disabled 2> $null
        echo " Done!`r`n"
    }
}

function DISABLE_SERVICES() {

    Write-Host "`r`n Disabling Services...Please wait...`r`n" -ForegroundColor "Red"

    sleep -Milliseconds 500

    Write-Host " DISABLING TELEMETRY & DIAGNOSTICS SERVICES...`r`n" -ForegroundColor "Yellow"
    foreach ($SVC in $TELEMETRY_SERVICES) {
        DISABLE_SVC $SVC
        sleep -Milliseconds 500
    }

    sleep 1

    Write-Host " DISABLING SERVICES RELATED TO BROWSERS & 3RD PARTY APPS...`r`n" -ForegroundColor "Yellow"
    foreach ($SVC in $APPS_SERVICES) {
        DISABLE_SVC $SVC
        sleep -Milliseconds 500
    }

    sleep 1

    Write-Host " DISABLING OTHER UNNECESSARY SERVICES...`r`n" -ForegroundColor "Yellow"
    foreach ($SVC in $OTHER_SERVICES) {
        DISABLE_SVC $SVC
        sleep -Milliseconds 500
    }
      
    sleep 1

    Write-Host "`r`n Setting some Services to Manual Mode so they can be started when needed...`r`n" -ForegroundColor "Yellow"
    foreach ($SVC in $MANUAL_SERVICES) {
        $DISPLAY_NAME = (Get-Service -Name $SVC | select DisplayName).DisplayName
        if (!$DISPLAY_NAME.trim() -eq "") {
            echo " Setting $DISPLAY_NAME to Manual mode..."
            Stop-Service -Name $SVC -Force -NoWait 2> $null
            sleep -Milliseconds 500
            Set-Service -Name $SVC -Status Stopped -StartupType Manual 2> $null
            echo " Done!`r`n"
        }
        sleep -Milliseconds 500
    }

    Write-Host "`r`n Services Disabled Successfully!`r`n" -ForegroundColor "Green"
    Write-Host " Press any key to continue..." -ForegroundColor "White"
    $HOST.UI.RawUI.ReadKey() | Out-Null

}