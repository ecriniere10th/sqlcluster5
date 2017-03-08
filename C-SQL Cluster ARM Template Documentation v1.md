![](media/5d88a03f4d89d7f7c8586a31778571b7.png)

**CleaResult**

March 8, 2017

Overview
========

This document will provide guidance on deploying a SQL AlwaysOn Highly Available
environment. The image below is a reference as to the resources that will be
deployed, and configured. Some values in the image may be incorrect.

Installation
============

Prerequisites
-------------

1.  Azure Subscription

2.  Azure Resource Group

3.  Available cores (16 cores should be available) to deploy Azure VMs

4.  Existing VNET, and subnet

    1.  Document Resource Group Name of the VNet

    2.  Document VNet Name

    3.  Document Subnet name

    4.  Select an available IP address within the range of the subnet selected
        above. You will need one for the witness server, 2 for the sql nodes,
        and one for the load balancer.

5.  Existing Active Directory

6.  Create a domain admin account that will be used to provision and configured
    the resources that will be deployed.

    1.  This account will be a built-in administrator for the vms created
        (password needs to be at least 12 chars, 1 Uppercase, 1 Lowercase, 1
        special char, 1 number)

    2.  This account will be a sysadmin within SQL

    3.  This account needs to have the ability to create/verify computer objects
        (guidance below)

7.  Storage Account that will contain the ARM Templates and DSC resources

    1.  Document the Shared Access Signature (SAS Token)

    2.  Document the Blob URL

    3.  Document Storage Access Key

    4.  Document storage account name

8.  Document File Share Witness server name, and file share name.

9.  Optional : Prestage computers and sql service account. “The user who creates
    the failover cluster must have the Create Computer objects permission to the
    organizational unit (OU) or the container where the servers that will form
    the cluster reside.”

    1.  The link below provides guidance on this topic.

    2.  **Prestage Cluster Computer Objects in Active Directory Domain
        Services**

        <https://technet.microsoft.com/en-us/library/dn466519(v=ws.11).aspx#BKMK_GrantCNOPerms>

Overview
--------

1.  Two ARM Templates, that call out to linked templates, will deploy the
    following:

    1.  Provision one VM, with supporting Azure resources, to be used as a SQL
        Witness.

    2.  Provisions two VMs, with supporting Azure resources and infrastructure,
        to be used as a SQL Cluster.

2.  This Template will deploy the following resource/features:

    1.  **Azure Storage Accounts (premium storage for SQL Vms)**

    2.  **Azure Network Interfaces**

    3.  **Azure Load Balancer**

    4.  **Availability Set**

    5.  **Azure VMs (SQL Nodes (DS13\_v2) and Witness (DS1\_v2))**

    6.  **Automatic Domain Join**

    7.  **Disk Configuration**

    8.  **Failover Cluster configuration**

Deployment Procedure
--------------------

1.  Deploy the **main** ARM template for each workload. Ensure that all required
    parameters are entered correctly. Please refer to the template diagram for
    further assistance.

    1.  DeployWitness.json (Deploys Witness resources)

    2.  DeploySQLCluster.json (Deploys SQL Cluster resources)

2.  Copy the contents from one of the main ARM Templates listed above and paste
    it into the “Template Deployment” feature within the Azure Portal.

3.  Add the “Template Deployment” feature from the **Azure Marketplace**

    1.  Pin the Marketplace blade (the blade will be located on the margin, on
        the far left side.

        ![](media/501ceb3167830526eb48e58a24655838.png)

    2.  Open the Marketplace and select “Template Deployment” (Helpful Hint :
        Pin to Azure dashboard for easy access)

        ![](media/2b9fe5f8158a44b1c6944b54eed21ce0.png)

    3.  Select “Create”

        ![](media/bad0e0da7d3a9b05743daeb1b95df473.png)

    4.  Select the “Edit Template” section and paste in the contents from one of
        the main templates listed above in the editor, and select “Save”.

        **NOTE**: Delete any text/code that comes default when editing the
        template and paste in code from one of the main ARM Template listed
        above.

        ![](media/24a7012d8943610ea1d73718bd3ed6ab.png)

    5.  Once the template’s contents are saved, select the “Edit parameters”
        section and fill in the parameters as noted in the section below.

        ![](media/226a9cd8a51ffaa446a5fb0cc1290e1e.png)

    6.  Finalize the deployment with selecting, or creating, the Resource Group
        that will hold the deployed resources, select the resource group
        location (if creating one), acknowledge the legal terms, and select
        “Create” to deploy the template.

        ![](media/14b26aae60fdaddc8dadb5364633a5a6.png)

SQL Witness ARM Template Parameters
===================================

| Parameter Name              | Type         | Default Value (example)                                       | Description                                                                                                                                                                         |
|-----------------------------|--------------|---------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| VirtualNetworkResourceGroup | String       | cinfradrgp001                                                 | Resource Group VNET is deployed in                                                                                                                                                  |
| VirtualNetworkName          | String       | cinfradvnt00110.232.0.0\_16                                   | This is the name of the Virtual Network                                                                                                                                             |
| ExistingSubnetName          | String       | cinfradsub00610.232.10.0\_23                                  | Existing subnet that contains the domain controller"                                                                                                                                |
| CompIDNamePrefix            | String       | c                                                             | Company ID Naming prefix. 1-char max, lowercase alphanumeric                                                                                                                        |
| RGIDNamePrefix              | String       | 00006                                                         | Resource Group ID Naming prefix. 5-char max, lowercase alphanumeric                                                                                                                 |
| EnvNamePrefix               | String       | d                                                             | Environment Naming prefix. 1-char max, lowercase alphanumeric                                                                                                                       |
| storageAccountType          | String       | Standard\_LRS                                                 | Type of Storage Account to be created to store VM OS, data, and log disks.                                                                                                          |
| sqlWitnessVMSize            | String       | Standard\_DS1\_v2                                             | Size of the Witness VM to be created                                                                                                                                                |
| windowsImageOffer           | String       | WindowsServer                                                 | Image used to create witness node                                                                                                                                                   |
| windowsImageVersion         | String       | latest                                                        | Image version (2012 R2 Datacenter)                                                                                                                                                  |
| existingDomainName          | String       | clearesult.com                                                | Active Directory domain to join                                                                                                                                                     |
| adminUsername               | String       | sql.install.ea                                                | Active Directory administrator                                                                                                                                                      |
| adminPassword               | SecureString | \<password\>                                                  | Active Directory admin password                                                                                                                                                     |
| vmAdminUsername             | String       | cLAdministrator                                               | Local VM Administrator                                                                                                                                                              |
| vmAdminPassword             | SecureString | \<password\>                                                  | Local VM Administrator password                                                                                                                                                     |
| existingAdPDCVMName         | String       | cmaddspadc01                                                  | Computer name of the existing Primary AD domain controller & DNS server                                                                                                             |
| sqlWitnessIPAddress         | String       | 10.232.10.XX                                                  | IP address of the File Share Witness Server (the “XX” should be replaced by an available address)                                                                                   |
| assetLocation               | String       | https://\<StorageAccountName.blob.core.windows.net/sqlcluster | Location of resources that the template/script is dependent on such as linked templates and DSC modules. Replace StorageAccountName with the storage account name that will be used |
| sasToken                    | SecureString | \<SAS token\>                                                 | SAS token for the storage account in which the DSC script for the servers resides                                                                                                   |

SQL Cluster ARM Template Parameters
===================================

| Parameter Name                  | Type         | Default Value (example)                                       | Description                                                                                                                                                                                                                                                                                                                                                      |
|---------------------------------|--------------|---------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| VirtualNetworkResourceGroup     | String       | cinfradrgp001                                                 | Resource Group VNET is deployed in                                                                                                                                                                                                                                                                                                                               |
| VirtualNetworkName              | String       | cinfradvnt00110.232.0.0\_16                                   | This is the name of the Virtual Network                                                                                                                                                                                                                                                                                                                          |
| ExistingSubnetName              | String       | cinfradsub00610.232.10.0\_23                                  | Existing subnet that contains the domain controller"                                                                                                                                                                                                                                                                                                             |
| CompIDNamePrefix                | String       | c                                                             | Company ID Naming prefix. 1-char max, lowercase alphanumeric                                                                                                                                                                                                                                                                                                     |
| RGIDNamePrefix                  | String       | 00006                                                         | Resource Group ID Naming prefix. 5-char max, lowercase alphanumeric                                                                                                                                                                                                                                                                                              |
| EnvNamePrefix                   | String       | d                                                             | Environment Naming prefix. 1-char max, lowercase alphanumeric                                                                                                                                                                                                                                                                                                    |
| storageAccountType              | String       | Premium\_LRS                                                  | Type of Storage Accounts to be created to store VM OS, data, and log disks.                                                                                                                                                                                                                                                                                      |
| sqlVMSize                       | String       | Standard\_DS13\_v2                                            | Size of the SQL VMs to be created                                                                                                                                                                                                                                                                                                                                |
| windowsImageOffer               | String       | SQL2014SP2-WS2012R2                                           | Image used to create sql nodes                                                                                                                                                                                                                                                                                                                                   |
| windowsImageVersion             | String       | latest                                                        | Image version                                                                                                                                                                                                                                                                                                                                                    |
| existingDomainName              | String       | clearesult.com                                                | Active Directory domain to join                                                                                                                                                                                                                                                                                                                                  |
| adminUsername                   | String       | sql.install.ea                                                | Active Directory administrator Create a domain account that will be used to prepare the vms for the SQL Always On configuration.                                                                                                                                                                                                                                 |
| adminPassword                   | SecureString | \<sql install account password\>                              | Active Directory admin password                                                                                                                                                                                                                                                                                                                                  |
| sqlServerServiceAccountUserName | String       | cdsqlsvc                                                      | SQL server service account name                                                                                                                                                                                                                                                                                                                                  |
| sqlServerServiceAccountPassword | SecureString | \<sql svc account password\>                                  | Existing SQL server service account password                                                                                                                                                                                                                                                                                                                     |
| existingAdPDCVMName             | String       | cmaddspadc01                                                  | Computer name of the existing Primary AD domain controller & DNS server                                                                                                                                                                                                                                                                                          |
| sqlLBIPAddress                  | String       | 10.232.10.XX                                                  | IP address of ILB for the SQL Server AlwaysOn listener to be created                                                                                                                                                                                                                                                                                             |
| sqlVMIPAddress                  | String       | 10.232.10.                                                    | Provide the starting 3 octets for the IP address space of the SQL Cluster Nodes                                                                                                                                                                                                                                                                                  |
| sqlVMStartingIPAddress          | String       | 10                                                            | The starting IP address for the SQL Cluster Nodes. (Note: This value must be updated within the NIC resource located in the “deploy-sql-cluster.json” template. The property is called “**privateIPAddress**”, and the value that should be updated will be located within the copyindex(\<starting IP\>) function. Refer to the section below for more details. |
| sqlWitnessServerName            | String       | c00006tfil001                                                 | Name of the File Share Witness Server                                                                                                                                                                                                                                                                                                                            |
| sqlFileSharePathName            | String       | c00006tfs01                                                   | Name of the file share path name                                                                                                                                                                                                                                                                                                                                 |
| assetLocation                   | String       | https://\<StorageAccountName.blob.core.windows.net/sqlcluster | Location of resources that the template/script is dependent on such as linked templates and DSC modules                                                                                                                                                                                                                                                          |
| sasToken                        | SecureString | \<SAS Token\>                                                 | SAS token for the storage account in which the DSC script for the servers resides                                                                                                                                                                                                                                                                                |
| storageAccountKey               | SecureString | \<storage key\>                                               | Access Key for the Storage account in which the deployment scripts are held                                                                                                                                                                                                                                                                                      |
| customScriptStorageAccountName  | String       | StorageAccountName                                            | Name of the storage account in which the deployment scripts are held                                                                                                                                                                                                                                                                                             |
|                                 |              |                                                               |                                                                                                                                                                                                                                                                                                                                                                  |
|                                 |              |                                                               |                                                                                                                                                                                                                                                                                                                                                                  |
|                                 |              |                                                               |                                                                                                                                                                                                                                                                                                                                                                  |

Deployment Notes
----------------

### IP Address for SQL Nodes

When deploying the SQL Cluster template, the **sqlVMStartingIPAddress**
parameter is useless, and the template will need to be manually updated to
reflect the starting IP address for the sql nodes being deployed. The steps
below outline the procedure to update the template:

-   Open the “**deploy-sql-cluster.json**” template in a text editor, or Visual
    Studio.

-   Navigate to the **resources** section and select the NIC resource. (Image
    below)

-   Update the property called “**privateIPAddress**”

    -   Select the value within the copyindex function, and enter the starting
        IP address within that field.

-   Save and upload the template to the storage account. This is the storage
    account that currently holds all of the ARM Templates and DSC resources.

![](media/ac472db01704e13cacedde9805e4884f.png)
