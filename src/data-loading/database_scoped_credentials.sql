USE creditrisk_gold;

-- Drop external data source if exists
IF EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'creditrisk_gold_storage')
    DROP EXTERNAL DATA SOURCE creditrisk_gold_storage;

-- Drop existing credentials if exists
IF EXISTS (SELECT * FROM sys.database_scoped_credentials WHERE name = 'DataLakeManagedIdentity')
    DROP DATABASE SCOPED CREDENTIAL DataLakeManagedIdentity;

IF EXISTS (SELECT * FROM sys.database_scoped_credentials WHERE name = 'https://creditrisk.dfs.core.windows.net')
    DROP DATABASE SCOPED CREDENTIAL [https://creditrisk.dfs.core.windows.net];

IF EXISTS (SELECT * FROM sys.database_scoped_credentials WHERE name = 'https://creditrisk.dfs.core.windows.net/creditrisk-data/gold')
    DROP DATABASE SCOPED CREDENTIAL [https://creditrisk.dfs.core.windows.net/creditrisk-data/gold];

-- Drop master key if exists
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
    DROP MASTER KEY;

-- Create master key
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MasterKey@Admin2026!';

-- Create credential using Managed Identity
CREATE DATABASE SCOPED CREDENTIAL DataLakeManagedIdentity
WITH IDENTITY = 'Managed Identity';

-- Create external data source
CREATE EXTERNAL DATA SOURCE creditrisk_gold_storage
WITH (
    LOCATION = 'https://creditrisk.dfs.core.windows.net/creditrisk-data/gold',
    CREDENTIAL = DataLakeManagedIdentity
);