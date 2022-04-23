function move-the-cursor([int]$x, [int]$y) 
{
	$Host.UI.RawUI.CursorPosition = @{ X = $x; Y = $y }
	$Host.UI.Write('Welcome! SEKTION') 
}
$width = $Host.UI.RawUI.MaxWindowSize.Width

clear
#move-the-cursor (($width / 2) - 10) 0


#gsudo cache on *> $null

function reboot { restart-computer }

function poweroff { stop-computer }

function Home { cd "$env:HOMEPATH" }

function Desktop { cd "$env:HOMEPATH\Desktop" }

function which($cmd) { (Get-Command $cmd).Definition }

function prompt { (write-host -ForegroundColor Red -BackgroundColor Black -NoNewLine $env:COMPUTERNAME); (write-host -ForegroundColor Gray -BackgroundColor Black -NoNewLine "@"); (write-host -ForegroundColor Cyan -BackgroundColor Black (Get-Location)) }

function pshell { start powershell -Verb runas | out-null }

function choco { gsudo cache on 2>&1>$null; gsudo choco @args }

function hash { (Get-FileHash @args -Algorithm MD5).Hash }

function myip($value) {
	if ($value -eq "public") {
		#echo "`tPublic IP Address`t:`t$(wget -UseBasicParsing https://ifconfig.me/ip)"
		echo "`tPublic IP Address`t:`t$(Invoke-RestMethod -Uri https://ipinfo.io/ip)"
	}
	elseif ($value -eq $null) {
		echo "`tWireless LAN  $(ipconfig | sls -Pattern 'Wireless LAN adapter WiFi' -Context 0,4 | foreach { $_.Context.PostContext[-1] })"
		echo "`tVMWare VMNet1 $(ipconfig | sls -Pattern 'VMnet1' -Context 0,4 | foreach { $_.Context.PostContext[-1] })"
		echo "`tVMWare VMNet8 $(ipconfig | sls -Pattern 'VMnet8' -Context 0,4 | foreach { $_.Context.PostContext[-1] })"
	}
	else {
		echo "Invalid Argument!"
	}
}

set-alias -Name "npp" -Value "C:\Program Files\Notepad++\notepad++.exe"

# Chocolatey profile
#$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
#if (Test-Path($ChocolateyProfile)) {
#  Import-Module "$ChocolateyProfile"
#}

$env:FLASK_ENV='development'
