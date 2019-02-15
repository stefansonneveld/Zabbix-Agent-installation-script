#start logging to log file
Start-Transcript -Path "C:\WINDOWS\TEMP\Zabbix-$Env:COMPUTERNAME.log" -Append -NoClobber -IncludeInvocationHeader

#Location for endpoint where the agent will be installed and unc path where installion files are located and desired version check
$zabbixInstallPath = "C:\ZabbixAgent"
$zabbixUncPath = "\\Servername\ZabbixAgent\*"
$DesiredVersion= "4.0.0.85308"

#create agent directory if it doesn't exists and copy Zabbix agent to server
if (!(Test-Path -Path $zabbixInstallPath))
{
    New-Item $zabbixInstallPath -ItemType Directory
    Copy-Item $zabbixUncPath $zabbixInstallPath -Recurse

    #Checks for 32-bit or 64-bit windows and then installs the proper agent as a service and starts it.
if ([System.IntPtr]::Size -eq 4)
{
    Start-Process -FilePath "$zabbixInstallPath\bin\win32\zabbix_agentd.exe" -ArgumentList "-c $zabbixInstallPath\conf\zabbix_agentd.win.conf -i" -NoNewWindow
    Start-Sleep -Seconds 2
    Start-Process -FilePath "$zabbixInstallPath\bin\win32\zabbix_agentd.exe" -ArgumentList "-c $zabbixInstallPath\conf\zabbix_agentd.win.conf -s" -NoNewWindow
}
else
 {
    Start-Process -FilePath "$zabbixInstallPath\bin\win64\zabbix_agentd.exe" -ArgumentList "-c $zabbixInstallPath\conf\zabbix_agentd.win.conf -i" -NoNewWindow
    Start-Sleep -Seconds 2
    Start-Process -FilePath "$zabbixInstallPath\bin\win64\zabbix_agentd.exe" -ArgumentList "-c $zabbixInstallPath\conf\zabbix_agentd.win.conf -s" -NoNewWindow
 }
}

#check if there is a new Zabbix Agent to install
elseif ("$DesiredVersion" -gt [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$zabbixInstallPath\bin\win64\zabbix_agentd.exe").FileVersion)
{
    Write-Host "New Version Found Starting Update"

    #Stop and Remove Zabbix agent Service
    Start-Process -FilePath "$zabbixInstallPath\bin\win64\zabbix_agentd.exe" -ArgumentList "-c $zabbixInstallPath\conf\zabbix_agentd.win.conf -x" -NoNewWindow
    Start-Sleep -Seconds 2
    Start-Process -FilePath "$zabbixInstallPath\bin\win64\zabbix_agentd.exe" -ArgumentList "-c $zabbixInstallPath\conf\zabbix_agentd.win.conf -d" -NoNewWindow
    Start-Sleep -Seconds 2

    Copy-Item $zabbixUncPath $zabbixInstallPath -Recurse -Force

    Start-Process -FilePath "$zabbixInstallPath\bin\win64\zabbix_agentd.exe" -ArgumentList "-c $zabbixInstallPath\conf\zabbix_agentd.win.conf -i" -NoNewWindow
    Start-Sleep -Seconds 2
    Start-Process -FilePath "$zabbixInstallPath\bin\win64\zabbix_agentd.exe" -ArgumentList "-c $zabbixInstallPath\conf\zabbix_agentd.win.conf -s" -NoNewWindow
}

else
{Write-Host "Zabbix Agent already installed and up to date"}
Stop-Transcript
#[Environment]::Exit(0)