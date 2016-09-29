-- Steps to Backup Databases to a private Azure storage account

-- Run lines 7-10 First
-- Select credentials
-- Update the IDENTITY and SECRET parameters to reflect the storage account name and storage key for the account that will be used.

IF NOT EXISTS (SELECT * FROM master.sys.credentials WHERE credential_identity = 'AzureBackup')
       BEGIN
              CREATE CREDENTIAL AzureBackup WITH IDENTITY = 'bbscrips', SECRET = 'rNfO30hmE9gjm+b22oa3t2sHVpESHq5g12RO8Nc5SUr3ibUV6DguJxaXFVtvX51zN+xZvdYNnkX8/OZE/m1DCw=='
       END


-- Run Line 16 to execute the backup process
-- Backup Database to a private Azure storage account with the name backup.bak
   
BACKUP DATABASE master TO URL='https://bbscrips.blob.core.windows.net/backupdb/backup.bak' WITH CREDENTIAL='AzureBackup', COMPRESSION 
