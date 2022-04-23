$TASKS = @(
    "Adobe Acrobat Update Task",
    "aitagent",
    "AnalyzeSystem",
    "Appraiser",
    "MapsToastTask",
    "MapsUpdateTask",
    "UpdateLibrary",
    "GoogleUpdateTaskMachineCore",
    "GoogleUpdateTaskMachineUA",
    "AD RMS Rights Policy Template Management (Automated)",
    "Microsoft Compatibility Appraiser",
    "ProgramDataUpdater",
    "Proxy",
    "Consolidator",
    "KernelCeipTask",
    "Uploader",
    "UsbCeip",
    "DmClient",
    "DmClientOnScenarioDownload",
    "RegisterDeviceLocationRightsChange",
    "RegisterDevicePeriodic24",
    "Microsoft-Windows-DiskDiagnosticDataCollector",
    "Microsoft-Windows-DiskDiagnosticResolver",
    "Diagnostics",
    "File History (maintenance mode)",
    "WinSAT",
    "GatherNetworkInfo",
    "Background Synchronization",
    "Logon Synchronization",
    "MicrosoftEdgeUpdateTaskMachineUA",
    "MiniToolPartitionWizard",
    "AnalyzeSystem",
    "LoginCheck",
    "FamilySafetyMonitor",
    "FamilySafetyRefresh",
    "FamilySafetyUpload",
    "GatherNetworkInfo",
    "LicenseAcquisition",
    "HybridDriveCachePrepopulate",
    "HybridDriveCacheRebalance",
    "ResPriStaticDbSync",
    "WsSwapAssessmentTask",
    "SR",
    "StartupAppTask",
    "Sqm-Tasks",
    "ForceSynchronizeTime",
    "RegIdleBackup",
    "VerifyWinRE",
    "RunUpdateNotificationMgr",
    "Schedule Maintenance Work",
    "Schedule Wake To Work",
    "Schedule Work",
    "HiveUploadTask",
    "QueueReporting",
    "Automatic-Device-Join",
    "Device-Sync",
    "Recovery-Check",
    "XblGameSaveTask",
    "Firefox Default Browser Agent 308046B0AF4A39CB"
)

function DELETE_TASK($TASKNAME) {
    $STATE = (Get-ScheduledTask $TASKNAME).State 2>$null
    if ($STATE -eq $null) {
        Write-Host "`r`n Scheduled Task `"$TASKNAME`" not found!" -ForegroundColor "Red"
        Return    
    }
    Write-Host "`r`n Scheduled Task `"$TASKNAME`" is $STATE" -ForegroundColor "Cyan"
    Write-Host " Deleting $TASKNAME" -ForegroundColor "Yellow"
    Unregister-ScheduledTask -TaskName $TASKNAME -Confirm:$false 2>&1 > $null
    sleep -Milliseconds 500
    echo " Done!"
}

# function DISABLE_TASK($TASKNAME) {
#     echo "Disabling $TASKNAME"
#     Stop-ScheduledTask -TaskName $TASKNAME 2>&1 > $null
#     sleep -Milliseconds 500
#     Disable-ScheduledTask -TaskName $TASKNAME 2>&1 > $null
#     sleep -Milliseconds 500
#     echo "Done!`r`n"
# }

function DELETE_TASKS() {
    Write-Host "`r`n Deleting Unnecessary Scheduled Tasks...`r`n" -ForegroundColor "White"
    foreach($TASK in $TASKS) {
        DELETE_TASK $TASK
        sleep -Milliseconds 500
    }
    Write-Host "`r`n Scheduled Tasks Deleted Successfully!`r`n" -ForegroundColor "Green"
    Write-Host " Press any key to continue..." -ForegroundColor "White"
    $HOST.UI.RawUI.ReadKey() | Out-Null
}