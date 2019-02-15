# Zabbix Agent installation script

automate installing Windows zabbix agent

this script is made to work with the precompiled zabbix agent for windows.

basic function:

copies files from a network path to the endpoint

Installs and starts the zabbix service
concecutive runs of the script will check if you placed newer agent binaries on the unc path and copies them if you change the $desiredVersion variable to the new version

zabbixInstallpath =  the location you want the agent files to be copied to
zabbixUncPath = the network location you have the zabbix agent files located
DesiredVersion = compares the zabbix_agentd.exe version on the unc path with that of the endpoint and if the version on the uncpath is newer it will uninstall the old agent and copy over the new files and install again