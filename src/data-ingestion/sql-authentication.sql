-- Step 1: Drop existing user and login if they exist
USE [vib-data];
IF EXISTS (SELECT name FROM sys.database_principals WHERE name = 'adf_user')
    DROP USER adf_user;

USE [master];
IF EXISTS (SELECT name FROM sys.server_principals WHERE name = 'adf_user')
    DROP LOGIN adf_user;

-- Step 2: Create server login
CREATE LOGIN adf_user 
WITH PASSWORD = 'Admin123@',
CHECK_POLICY = OFF,
CHECK_EXPIRATION = OFF;

-- Step 3: Enable the login
ALTER LOGIN adf_user ENABLE;

-- Step 4: Create user in vib-data database
USE [vib-data];
CREATE USER adf_user FOR LOGIN adf_user;

-- Step 5: Grant permissions
ALTER ROLE db_datareader ADD MEMBER adf_user;
ALTER ROLE db_datawriter ADD MEMBER adf_user;