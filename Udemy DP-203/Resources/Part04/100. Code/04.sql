-- Lab - Loading data into a table - COPY Command - CSV

-- Never use the admin account for load operations.
-- Create a seperate user for load operations

-- in systemdatabases/master.db
CREATE LOGIN user_load WITH PASSWORD = '$SuperLooper98';

CREATE USER user_load FOR LOGIN user_load;
GRANT ADMINISTER DATABASE BULK OPERATIONS TO user_load;
GRANT CREATE TABLE TO user_load;
GRANT ALTER ON SCHEMA::dbo TO user_load;

CREATE WORKLOAD GROUP DataLoads
WITH ( 
    MIN_PERCENTAGE_RESOURCE = 100
    ,CAP_PERCENTAGE_RESOURCE = 100
    ,REQUEST_MIN_RESOURCE_GRANT_PERCENT = 100
    );

CREATE WORKLOAD CLASSIFIER [ELTLogin]
WITH (
        WORKLOAD_GROUP = 'DataLoads'
    ,MEMBERNAME = 'user_load'
);

-- Create a normal table
-- Login as the new user and create the table
-- Here I have added more constraints when it comes to the width of the data type

CREATE TABLE [logdata_user_test]
(
    [Id] [int] NULL,
	[Correlationid] [varchar](200) NULL,
	[Operationname] [varchar](200) NULL,
	[Status] [varchar](100) NULL,
	[Eventcategory] [varchar](100) NULL,
	[Level] [varchar](100) NULL,
	[Time] [datetime] NULL,
	[Subscription] [varchar](200) NULL,
	[Eventinitiatedby] [varchar](1000) NULL,
	[Resourcetype] [varchar](1000) NULL,
	[Resourcegroup] [varchar](1000) NULL
)

-- Grant the required privileges to the new user

GRANT INSERT ON logdata TO user_load;
GRANT SELECT ON logdata TO user_load;

-- Now log in as the new user
-- The FIRSTROW option helps to ensure the first header row is not part of the COPY implementation
-- https://docs.microsoft.com/en-us/sql/t-sql/statements/copy-into-transact-sql?view=azure-sqldw-latest&preserve-view=true


-- COPY FROM EXTERNAL TABLE
INSERT INTO [logdata_user_test]
SELECT * FROM [logdata];
-- OR
COPY INTO logdata_user_test FROM 'https://h24pgen2.blob.core.windows.net/data/raw/Log.csv'
WITH (FIRSTROW=2);




SELECT * FROM [logdata_user_test];