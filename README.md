# End-to-end credit risk pipeline

![Pipeline](docs/credit-risk-pipeline.png)

# 0. Setup
Here are just the summary for setup phase. For details see [Detailed setup](docs/setup.md)

## On-premises
1. SQL Server 2025 Developer - Enterprise Developer edition
2. SQL Server Management Studio 22

## Azure
Create these resources **in order**:
1. Resource Group — a container that holds all project resources
2. Azure Data Lake Storage Gen2 (ADLS Gen2) — Bronze/Silver/Gold storage
3. Azure Data Factory (ADF) — for the pipelines
4. Azure Databricks — for transformations
5. Azure Synapse Analytics — for querying
6. Azure Key Vault — for storing secrets/credentials
7. Microsoft Entra ID — already exists, just need to configure (create SP, assign SP roles and SP indenties)

# 1. Data ingestion
## Microsoft Integration Runtime (IR)
- **ADF side**: Open ADF Studio and create Integration Runtime
- **On-prem side**: Download and install integration runtime

## Copy Pipeline
In **Azure Data Factory Studio**:
- Create linked service **(called ls_sql)** for on-prem SQL Server with SQL authentication.
    ```sql
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
    ```
- Create linked service **(called ls_adls)** for ADLS Gen2
- Create **Copy All Data Pipeline** (dynamically loop all tables) 
    - Lookup
        ```sql
        SELECT TABLE_NAME 
        FROM INFORMATION_SCHEMA.TABLES 
        WHERE TABLE_TYPE = 'BASE TABLE'
        ```
    - ForEach:
    ``` @activity('lookup-all-tables').output.value ```
    - Copy data (insisde ForEach): **source** using ls_adls and **sink** using ls_adls. Dynamic query: ``` @concat('SELECT * FROM ', item().TABLE_NAME) ```


