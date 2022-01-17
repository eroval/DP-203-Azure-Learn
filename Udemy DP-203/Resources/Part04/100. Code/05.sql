-- Lab - Loading data into a table - COPY Command - Parquet


-- Recreate the table
-- Here again I am using the data type with MAX because that is how I generated the parquet files when it came to the data type
-- Here we need to specify the clustered index based on a column , because indexes can't be created on varchar(MAX)

CREATE TABLE [logdata_parquet_copy]
(
    [Id] [int],
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

COPY INTO [logdata_parquet_copy] FROM 'https://h24pgen2.blob.core.windows.net/data/raw/parquet/*.parquet'
WITH
(
FILE_TYPE='PARQUET',
CREDENTIAL=(IDENTITY= 'Shared Access Signature', SECRET='sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupx&se=2022-01-17T23:27:27Z&st=2022-01-17T15:27:27Z&spr=https&sig=DDvOc65xuDbh%2BFsc94pmPJWw5e3KbqkLpq8hGy5huDw%3D')
)

SELECT * FROM [logdata_parquet_copy]