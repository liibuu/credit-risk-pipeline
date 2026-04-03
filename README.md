# End-to-end credit risk pipeline

![Pipeline](docs/credit-risk-pipeline.png)

# Setup
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

# Data ingestion
## Microsoft Integration Runtime (IR)
- **ADF side**: Open ADF Studio and create Integration Runtime
- **On-prem side**: Download and install integration runtime
