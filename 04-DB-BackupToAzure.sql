-- Steps to Backup Databases to a private Azure storage account

-- Run lines 7-10 First
-- Select credentials
-- Update the IDENTITY and SECRET parameters to reflect the storage account name and storage key for the account that will be used.

IF NOT EXISTS (SELECT * FROM master.sys.credentials WHERE credential_identity = 'AzureBackup')
       BEGIN
              CREATE CREDENTIAL AzureBackup WITH IDENTITY = '<name of storage account>', SECRET = '<storage account key>'
       END


-- Run Line 16 to execute the backup process
-- Backup Database to a private Azure storage account with the name backup.bak
   
BACKUP DATABASE master TO URL='<Storage account URL>' WITH CREDENTIAL='AzureBackup', COMPRESSION 
