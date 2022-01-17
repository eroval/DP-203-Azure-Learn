CREATE DATABASE SCOPED CREDENTIAL AzureStorageCredential
WITH
  IDENTITY = 'h24pgen2',
  SECRET = 'bJRdiiB+rwuSaJn+Fy4XYdBMyHpRXe9JMHqG4AH8xxGuSrifF8IJlM65hUrPBHtU/dtuGJIg3GpIpij9Ccu6vA==';

CREATE EXTERNAL FILE FORMAT parquetfile  
WITH (  
    FORMAT_TYPE = PARQUET,  
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'  
);

CREATE EXTERNAL DATA SOURCE log_data_parquet
WITH (    LOCATION   = 'abfss://data@h24pgen2.dfs.core.windows.net',
          CREDENTIAL = AzureStorageCredential,
          TYPE = HADOOP
)

CREATE EXTERNAL TABLE [logdata_parquet]
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
WITH (
 LOCATION = 'raw/parquet/',
    DATA_SOURCE = log_data_parquet,  
    FILE_FORMAT = parquetfile
)

SELECT * FROM [logdata_parquet];