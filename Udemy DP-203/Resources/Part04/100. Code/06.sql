-- Lab - Loading data using PolyBase

-- If you want to see existing database scoped credentials
SELECT * FROM sys.database_scoped_credentials

-- If you want to see the external data sources
SELECT * FROM sys.external_data_sources 

-- If you want to see the external file formats
SELECT * FROM sys.external_file_formats

CREATE EXTERNAL TABLE [logdata_external]
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

-- Now create a normal table by selecting all of the data from the external table

CREATE TABLE [logdata_loaded_from_parquet]
WITH
(
DISTRIBUTION = ROUND_ROBIN,
CLUSTERED INDEX (id)   
)
AS
SELECT  *
FROM  [logdata_external];


SELECT * FROM logdata_loaded_from_parquet





