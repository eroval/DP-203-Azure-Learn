-- Lab - SQL Pool - External Tables - CSV

CREATE MASTER KEY ENCRYPTION BY PASSWORD = '$LooperDude98';

-- Here we are using the Storage account key for authorization

CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
  IDENTITY = 'h24pgen2',
  SECRET = 'bJRdiiB+rwuSaJn+Fy4XYdBMyHpRXe9JMHqG4AH8xxGuSrifF8IJlM65hUrPBHtU/dtuGJIg3GpIpij9Ccu6vA==';

-- In the SQL pool, we can use Hadoop drivers to mention the source

DROP EXTERNAL DATA SOURCE log_data

CREATE EXTERNAL DATA SOURCE log_data
WITH (    LOCATION   = 'abfss://cleaned@h24pgen2.dfs.core.windows.net',
          CREDENTIAL = AzureStorageCredential,
          TYPE = HADOOP
)

CREATE EXTERNAL FILE FORMAT TextFileFormat WITH (  
      FORMAT_TYPE = DELIMITEDTEXT,  
    FORMAT_OPTIONS (  
        FIELD_TERMINATOR = ',',
        FIRST_ROW = 2))

DROP EXTERNAL TABLE [logdata]

CREATE EXTERNAL TABLE [logdata]
(
    [Id] [int] NULL,
	[Correlationid] [varchar](200),
	[Operationname] [varchar](200),
	[Status] [varchar](100),
	[Eventcategory] [varchar](100),
	[Level] [varchar](100),
	[Time] [datetime],
	[Subscription] [varchar](200),
	[Eventinitiatedby] [varchar](1000),
	[Resourcetype] [varchar](1000),
	[Resourcegroup] [varchar](1000)
)
WITH (
 LOCATION = '/Log3.csv',
    DATA_SOURCE = log_data,  
    FILE_FORMAT = TextFileFormat
)



SELECT * FROM logdata


SELECT [Operation name] , COUNT([Operation name]) as [Operation Count]
FROM logdata
GROUP BY [Operation name]
ORDER BY [Operation Count]