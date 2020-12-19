# Description: Boxstarter Script
# Author: Rich Turner <rich@bitcrazed.com>
# Last Updated: 2019-07-08
#
# Run this Boxstarter by calling the following from an **ELEVATED PowerShell instance**:
#     `set-executionpolicy Unrestricted`
#     `. { iwr -useb https://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force`
#     `Install-BoxstarterPackage -DisableReboots -PackageName <URL-TO-RAW-GIST>`

#---- TEMPORARY ---
  Disable-UAC
  
#--- Used to uninstall unwanted default apps ---
function Remove-App 
{	
    Param ([string]$appName)
    
    Write-Output "Trying to remove $appName"
    
    Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
    
    Get-AppXProvisionedPackage -Online | Where DisplayNam -like $appName | Remove-AppxProvisionedPackage -Online
}
        
#--- Uninstall unwanted default apps ---
$applicationList = @(	
    "Microsoft.3DBuilder"
    "Microsoft.CommsPhone"
    "Microsoft.Getstarted"
    "*MarchofEmpires*"
    "Microsoft.GetHelp"
    "Microsoft.Messaging"
    "*Minecraft*"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.WindowsPhone"
    "*Solitaire*"
    "Microsoft.MicrosoftStickyNotes"
    "Microsoft.Office.Sway"
    "Microsoft.XboxApp"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.Print3D"

    #Non-Microsoft
    "*Autodesk*"
    "*BubbleWitch*"
    "king.com.CandyCrush*"
    "*Dell*"
    "*Dropbox*"
    "*Facebook*"
    "*Keeper*"
    "*Plex*"
    "*.Duolingo-LearnLanguagesforFree"
    "*.EclipseManager"
    "ActiproSoftwareLLC.562882FEEB491" # Code Writer
    "*.AdobePhotoshopExpress");

foreach ($app in $applicationList) {
    Remove-App $app
}

#--- Windows Features ---
    Set-WindowsExplorerOptions -EnableShowFileExtensions ### -EnableShowHiddenFilesFoldersDrives -EnableShowProtectedOSFiles
    Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

    Enable-RemoteDesktop

#--- PowerShell utilities
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module DirColors
    Install-Module posh-git

#--- Install Windows features
    #choco install -y Microsoft-Hyper-V-All -source windowsFeatures
    #choco install -y Microsoft-Windows-Subsystem-Linux -source WindowsFeatures 
  
#--- Install Git ---
  choco install -y git -params '"/GitAndUnixToolsOnPath /WindowsTerminal"'
  RefreshEnv # Refresh env due to Git install

#--- Install Applications & Tools ---
  choco install -y 7Zip
  choco install -y adobereader
  choco install -y googlechrome
  choco install -y firefox
  choco install -y adobeair
  choco install -y silverlight
  choco install -y dotnet3.5
  choco install -y javaruntime
  choco install -y jre8
  choco install -y ccleaner
  choco install -y teamviewer
  choco install -y greenshot
  choco install -y choco-cleaner
#--- Install Dev Tools ---
  #choco install -y ruby
  #choco install -y python
  #choco install -y nodejs
  #choco install -y visualstudiocode
  
#--- Install Visual Studio 2019 ---
  # See this for install args: https://chocolatey.org/packages/VisualStudio2019Community  
  #choco install -y visualstudio2019enterprise
  #choco install -y visualstudio2019-workload-manageddesktop
  #choco install -y visualstudio2019-workload-nativedesktop
  #choco install -y visualstudio2019-workload-universal
  #choco install -y visualstudio2019-workload-nativecrossplat
  #choco install -y visualstudio2019-workload-netcoretools
  #choco install -y visualstudio2019-workload-azure

#--- Misc Tools ---
  choco install -y Vlc
  
#--- Restore Temporary Settings ---
    Enable-UAC
    Enable-MicrosoftUpdate
    Install-WindowsUpdate -acceptEula

$email = Read-Host "Enter your email address" 
ssh-keygen -t rsa -b 4096 -C "$email"

if (Test-Path d:) { $drive = 'd' }
else { $drive = 'c' }

if (!@(Test-Path ${drive}:\dev\)) { mkdir ${drive}:\dev\ }
cd ${drive}:\dev

if (!@(Test-Path ${drive}:\dev\powerrazzle)) {
  git clone git@github.com:bitcrazed/powerrazzle
}
