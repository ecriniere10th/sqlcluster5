
# Execute this script in the PowerShell ISE

# Prerequisite Steps

# Run this script after you have added the Client Access Point resource to the AG cluster role object in the failover cluster.

# Update the cluster resource name to reflect the IP address of the AG Listener to "IP Address 10.7.4.10".

# Update the network name in the network node in the failover cluster to "SQL_Subnet" 

# The AG Listener IP was created with an ARM Template, which created the intnernal Azure Load Balancer associated to the listener IP.

# Set Cluster Resource Parameter 

##############################################################################################3

# Define variables
$ClusterNetworkName = "SQL_Subnet" # the cluster network name
$IPResourceName = "IP Address 10.7.4.10" # the IP Address resource name
$ILBIP = “10.7.4.10” # the IP Address of the Internal Load Balancer (ILB)

Import-Module FailoverClusters

Get-ClusterResource $IPResourceName | Set-ClusterParameter -Multiple @{"Address"="$ILBIP";"ProbePort"="59999";"SubnetMask"="255.255.255.255";"Network"="$ClusterNetworkName";"EnableDhcp"=0}


##############################################################################################
