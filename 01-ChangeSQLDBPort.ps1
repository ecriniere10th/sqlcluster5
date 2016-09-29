# Execute this script in the PowerShell ISE

# Change the computer name for the "ManagedComputer" variable to the node are running it on 
# Run script on each sql node

import-module sqlps
$smo = 'Microsoft.SqlServer.Management.Smo.'
$wmi = new-object ($smo + 'Wmi.ManagedComputer')
$uri = "ManagedComputer[@Name='AAZ-SQL-1']/ ServerInstance[@Name='MSSQLSERVER']/ServerProtocol[@Name='Tcp']"
$Tcp = $wmi.GetSmoObject($uri)
$wmi.GetSmoObject($uri + "/IPAddress[@Name='IPAll']").IPAddressProperties
$wmi.GetSmoObject($uri + "/IPAddress[@Name='IPAll']").IPAddressProperties[1].Value="9032"
$Tcp.Alter()
Restart-Service MSSQLServer
