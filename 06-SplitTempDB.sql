--- Split TempDB
--- Execute on all replicas

ALTER DATABASE [tempdb] MODIFY FILE (NAME=tempdev, FILENAME='D:\tempdev.mdf', FILEGROWTH = 1 GB)
ALTER DATABASE [tempdb] MODIFY FILE (NAME=templog, FILENAME='D:\templog.ldf', FILEGROWTH = 1 GB)
ALTER DATABASE [tempdb] MODIFY FILE (NAME=tempdev, SIZE = 1 GB)
ALTER DATABASE [tempdb] MODIFY FILE (NAME=templog, SIZE = 5 GB)
ALTER DATABASE [tempdb] ADD FILE (NAME=tempdev3, FILENAME='D:\tempdev3.ndf', SIZE=1 GB, FILEGROWTH = 1 GB)
ALTER DATABASE [tempdb] ADD FILE (NAME=tempdev2, FILENAME='D:\tempdev2.ndf', SIZE=1 GB, FILEGROWTH = 1 GB)
ALTER DATABASE [tempdb] ADD FILE (NAME=tempdev1, FILENAME='D:\tempdev1.ndf', SIZE=1 GB, FILEGROWTH = 1 GB)

--- Verification
select physical_name FROM master.sys.master_files WHERE DB_Name(database_id)='tempdb'