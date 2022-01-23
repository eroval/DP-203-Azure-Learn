
// Spark Pool - Creating tables
// Here we are creating a tables in the metastore of the Spark pool

%%spark
val df = spark.read.sqlanalytics("mydedicatedpool.dbo.logdata") 
df.write.mode("overwrite").saveAsTable("logdatainternal")

//data 
%%sql

SELECT * FROM logdatainternal