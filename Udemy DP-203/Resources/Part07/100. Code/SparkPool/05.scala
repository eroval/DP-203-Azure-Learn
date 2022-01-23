//SCALA

import com.microsoft.spark.sqlanalytics.utils.Constants
import org.apache.spark.sql.SqlAnalyticsConnector._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._

val dataSchema = StructType(Array(
    StructField("Id", IntegerType, true),
    StructField("Correlationid", StringType, true),
    StructField("Operationname", StringType, true),
    StructField("Status", StringType, true),
    StructField("Eventcategory", StringType, true),
    StructField("Level", StringType, true),
    StructField("Time", TimestampType, true),
    StructField("Subscription", StringType, true),
    StructField("Eventinitiatedby", StringType, true),
    StructField("Resourcetype", StringType, true),
    StructField("Resourcegroup", StringType, true)))


val df = spark.read.format("csv").option("header","true").schema(dataSchema).load("abfss://data@h24pgen2.dfs.core.windows.net/raw/Log.csv")

df.printSchema()

import com.microsoft.spark.sqlanalytics.utils.Constants
import org.apache.spark.sql.SqlAnalyticsConnector._
df.write.
sqlanalytics("mydedicatedpool.dbo.logdata", Constants.INTERNAL)