function INSTALL_APPS() {
    
    function CHECK_CONNECTION() {
        if ( $(Get-NetAdapter | ? {$_.Name -eq "WiFi"} ).Status -eq "Disconnected" ) { 
            Write-Host "  Check Your Internet Connection and Try Again..." -ForegroundColor "Red"
            exit 
        } else {
            if ($(Test-Connection -Count 1 www.google.com -Quiet) -eq $false) {
                echo "Check Your Internet Connection and Try Again..."
                exit
            }
        }
    }

    $REG_PATH = @('HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
        'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*', 
        'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*')

    $INSTALLED = (Get-itemproperty -Path $REG_PATH).DisplayName | sort

    $COUNT = 0

    $RAR_KEY = "RAR registration data`r`nSEKTION`r`nUnlimited Company License`r`nUID=b8ecdb2e55d9ba48a249`r`n6412212250a24972f855bed69079b5ff75451ef6e808bf3853c16b`r`nfd6364209fe0f44cb41c60fce6cb5ffde62890079861be57638717`r`n7131ced835ed65cc743d9777f2ea71a8e32c7e593cf66794343565`r`nb41bcf56929486b8bcdac33d50ecf773996090e72c8eb00502e6af`r`nd45fd1090c84fa0b92cc4a827bcdb6a2426035fd2629965395541e`r`n1f3e43e76f7c1bdd0c7366645811f9c55f4c51832d6239426042fc`r`ne6b9e4c8ce0cd44ae16dd3569fefe527dc451d2104dd1677683626"

    function INSTALL($APP_NAME, $PACKAGE_NAME) {
        if (!$($INSTALLED -like "*$APP_NAME*")) {
            echo " Installing $APP_NAME..."
            try {
                choco install $PACKAGE_NAME --ignore-checksums > $null
            }
            catch {
                Write-Host " Error installing $APP_NAME!`r`n" -ForegroundColor "Red"
                Return
            }
            echo " Done!`r`n"
            $COUNT += 1
        } else {
            echo " $APP_NAME is already installed! Moving on...`r`n"
        }
            
    }

    
    function CORE_INSTALLATION() {
        Clear
        Write-Host "`r`n Core Software Installation running...Please Wait...`r`n" -ForegroundColor "Green"

        Write-Host " Installing Browsers...`r`n" -ForegroundColor "DarkYellow"
    
        INSTALL "Google Chrome" "googlechrome"
    
        #INSTALL "Mozilla Firefox" "firefox"

        INSTALL "Opera GX" "opera-gx"


        Write-Host " Installing Media Players...`r`n" -ForegroundColor "DarkYellow"
    
        INSTALL "VLC media player" "vlc"

        INSTALL "AIMP" "aimp"


        Write-Host " Installing Compression Tools...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "7-Zip" "7zip"

        INSTALL "WinRAR" "winrar"
        Set-Content -Path "C:\Program Files\WinRAR\rarreg.key" -Value $RAR_KEY


        Write-Host " Installing Redistributables...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "dotNet 3.5" "dotnet3.5"

        INSTALL "Microsoft .NET Framework" "dotnetfx"

        INSTALL "DirectX" "directx"

        INSTALL "VC++ Redist" "vcredist-all"

        INSTALL "XNA Framework Redistributable" "xna"

        INSTALL "OpenAL" "openal"

        INSTALL "OpenCL Runtime" "opencl-intel-cpu-runtime"


        Write-Host " Installing Downloaders...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "Internet Download Manager" "internet-download-manager"


        Write-Host " Installing Audio/Video Tools...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "K-Lite Codec Pack Full" "k-litecodecpackfull"

        INSTALL "Format Factory" "formatfactory"

        INSTALL "FFmpeg" "ffmpeg"


        Write-Host " Installing Tuning Utilities...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "MSI Afterburner" "msiafterburner"
        copy ".\res\Profiles\Afterburner Profile\*" "${env:ProgramFiles(x86)}\MSI Afterburner\Profiles\" -Recurse -Force


        Write-Host " Installing Developer Tools...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "Notepad++" "notepadplusplus"

        INSTALL "Visual Studio Code" "vscode"


        Write-Host " Installing HDD Tools...`r`n" -ForegroundColor "DarkYellow"
    
        INSTALL "Defraggler" "defraggler"

        INSTALL "MiniTool Partition Wizard" "partitionwizard"


        Write-Host " Installing Drivers...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "Nvidia Display Driver" "nvidia-display-driver"

        INSTALL "Nvidia Profile Inspector" "nvidia-profile-inspector"

        INSTALL "GeForce Experience" "geforce-experience"

        INSTALL "Display Driver Uninstaller" "ddu"

        #INSTALL "Driver Booster" "driverbooster"

        #INSTALL "Intel Driver Support Assistant" "intel-dsa"


        Write-Host " Installing File Sharing Tools...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "WinSCP" "winscp"

        INSTALL "qBittorrent" "qbittorrent"


        Write-Host " Done Installing $COUNT Softwares! Have Fun!!`r`n" -ForegroundColor "Green"
        Pause
        $COUNT = 0

    }
        

    function ADDITIONAL_INSTALLTION() {
        Clear
        Write-Host "`r`n Additional Software Installation running...Please Wait...`r`n" -ForegroundColor "Green"
        
        Write-Host " Installing Browsers...`r`n" -ForegroundColor "DarkYellow"

        #INSTALL "Brave Browser" "brave"

        INSTALL "LibreWolf Browser" "brave"

        #INSTALL "Tor Browser" "tor-browser"


        Write-Host " Installing Media Players...`r`n" -ForegroundColor "DarkYellow"
    
        INSTALL "Spotify" "spotify"
    
        INSTALL "Dopamine" "dopamine"


        Write-Host " Installing Developer Tools...`r`n" -ForegroundColor "DarkYellow"

        #INSTALL "Visual Studio Code" "vscode"

        INSTALL "VSCode Python Extension" "vscode-python"

        INSTALL "VSCode Prettier Extension" "vscode-prettier"

        INSTALL "VSCode Powershell Extension" "vscode-powershell"
    
        INSTALL "VSCode C# Extension" "vscode-csharp"

        INSTALL "VSCode Intellicode Extension" "vscode-intellicode"

        INSTALL "VSCode Beautify Extension" "vscode-beautify"

        INSTALL "VSCode Chrome Debug Extension" "vscode-chrome-debug"

        INSTALL "VSCode Icons Extension" "vscode-icons"

        INSTALL "VSCode Chocolatey Extension" "chocolatey-vscode"

        INSTALL "Git" "git"

        #INSTALL "WAMP Server" "wamp-server"

        INSTALL "Python 3" "python3"

        #INSTALL "PHP" "php"

        #INSTALL "PHP Composer" "composer"

        #INSTALL "NodeJS" "nodejs"
  
        #INSTALL "JAVA Runtime Environment" "jre8"

        #INSTALL "MinGW" "mingw"

        #INSTALL "GNU Nano" "nano"

        #INSTALL "HxD" "hxd"

        #INSTALL "Android Debug Bridge" "adb"

        #INSTALL "Blender" "blender"


        Write-Host " Installing Downloaders...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "Youtube-dl" "youtube-dl"

        INSTALL "Mega Downloader" "megadownloader"

        #INSTALL "4K Video Downloader" "4k-video-downloader"

        #INSTALL "4K YT to MP4" "4k-youtube-to-mp3"


        #Write-Host " Installing File Sharing Tools...`r`n" -ForegroundColor "DarkYellow"

        #INSTALL "FileZilla" "filezilla"

        #INSTALL "AnyDesk" "anydesk"


        #Write-Host " Installing Antimalware Tools...`r`n" -ForegroundColor "DarkYellow"

        #INSTALL "Malwarebytes" "malwarebytes"

        #INSTALL "ESET NOD32 ANTIVIRUS" "eset-nod32-antivirus"
        #Copy ".\res\license.lf" "ESET LOCATION" -Force


        #Write-Host " Installing Audio/Video Tools...`r`n" -ForegroundColor "DarkYellow"

        #INSTALL "Audacity" "audacity"

        #INSTALL "Audacity Lame" "audacity-lame"

        #INSTALL "kdenlive" "kdenlive"
    
        #INSTALL "MKVToolNix" "mkvtoolnix"


        Write-Host " Installing Networking Tools...`r`n" -ForegroundColor "DarkYellow"

        #INSTALL "Win32 OpenSSH" "openssh"   
    
        #INSTALL "Putty" "putty"

        #INSTALL "cURL" "curl"

        #INSTALL "Speedtest" "speedtest"

        #INSTALL "OpenVPN" "openvpn"

        INSTALL "Psiphon" "psiphon"

        #INSTALL "ProtonVPN" "protonvpn"

        #INSTALL "Unbound" "unbound"
        

        Write-Host " Installing Tuning Utilities...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "Intel Extreme Tuning Utility" "intel-xtu"


        Write-Host " Installing System Info/Monitoring Tools...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "CPU-Z" "cpu-z"

        INSTALL "GPU-Z" "gpu-z"

        INSTALL "SpeedFan" "speedfan"

        #INSTALL "HWiNFO" "hwinfo"

        #INSTALL "HWMonitor" "hwmonitor"

        #INSTALL "Speccy" "speccy"

        #INSTALL "CrystalDiskInfo" "crystaldiskinfo"  


        Write-Host " Installing Windows Utilities...`r`n" -ForegroundColor "DarkYellow"

        INSTALL "SysInternals" "sysinternals"

        INSTALL "KeePass" "keepass"

        #INSTALL "VMWare Tools" "vmware-tools"

        INSTALL "Everything" "everything"

        INSTALL "PowerToys" "powertoys"

        INSTALL "Rufus" "rufus"
    
        INSTALL "Process Hacker" "processhacker"

        INSTALL "Process Lasso" "plasso"
    
        INSTALL "f.lux" "f.lux"

        #INSTALL "BleachBit" "bleachbit"

        INSTALL "File Assassin" "fileassassin"

        INSTALL "File Converter" "file-converter"

        INSTALL "Revo Uninstaller" "revo-uninstaller"


        Write-Host " Installing Benchmarking Tools...`r`n" -ForegroundColor "DarkYellow"

        #INSTALL "Furmark" "furmark"

        #INSTALL "AIDA64 Extreme" "aida64-extreme"

        INSTALL "Cinebench" "cinebench"

        INSTALL "HD Tune" "hdtune"

        #INSTALL "AS SSD" "as-ssd"

        #INSTALL "3DMark" "3dmark"

        #INSTALL "PassMark PerformanceTest" "performancetest"


        #Write-Host " Installing Console Utilities...`r`n" -ForegroundColor "DarkYellow"
    
        #INSTALL "ConEmu" "conemu"

        #INSTALL "GNU sed" "sed"

        #INSTALL "GNU grep" "grep"

        #INSTALL "TimeIt" "timeit"


        Write-Host " Done Installing $COUNT Softwares! Have Fun!!`r`n" -ForegroundColor "Green"
        Pause
        $COUNT = 0
    }

    do {
        CENTER_TEXT "INSTALL SOFTWARES`r`n" 10 1
        CENTER_TEXT "_________________" 10 2
        echo "`r`n"
        echo " 1: Install Core Softwares"
        echo " 2: Install Additional Softwares"
        echo " 0: Back"
        $CHOICE = Read-Host ">"
        clear
    } while ($CHOICE.trim() -notlike '[0-2]')
     
    if ($CHOICE.trim() -eq 1) {
        CHECK_CONNECTION 
        CORE_INSTALLATION
    } 
    elseif ($CHOICE.trim() -eq 2) {
        CHECK_CONNECTION
        ADDITIONAL_INSTALLTION
    }
    elseif ($CHOICE.trim() -eq 0) { Return }

}
