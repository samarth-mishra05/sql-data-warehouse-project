/*
================================================================
Create Database and Schemas
================================================================
Script Purpose: 
    This script creates a new database named 'DataWarehouse'.
    Additionally, the script sets up three schemas within the database: 'bronze', 'silver', and 'gold'.
*/

--- Create Database 'DataWarehouse'

CREATE DATABASE DataWarehouse
GO

---Create Schemas

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO


