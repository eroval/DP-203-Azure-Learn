import org.apache.spark.sql.functions._

val storage = "h24pgen2"
spark.conf.set(
    "fs.azure.account.key." + storage + ".dfs.core.windows.net",
    dbutils.secrets.get(scope="myjkey",key="h24pgen2"))

val df = spark.read.format("csv")
.options(Map("inferSchema"->"true","header"->"true"))
.load("abfss://databricks@" + storage + ".dfs.core.windows.net/Log.csv")


val dfcorrect=df.select(col("Id"),
                        col("Correlation id").as("Correlationid"),
                        col("Operation name").as("Operationname"),
                        col("Status"),
                        col("Event category").as("Eventcategory"),
                        col("Level"),
                        col("Time"),
                        col("Subscription"),
                        col("Event initiated by").as("Eventinitiatedby"),
                        col("Resource type").as("Resourcetype"),
                        col("Resource group").as("Resourcegroup"))


display(dfcorrect)


val tablename="logdata"
val tmpdir="abfss://tmpdir@" + storage + ".dfs.core.windows.net/log"

// This is the connection to our Azure Synapse dedicated SQL pool
val connection = "jdbc:sqlserver://synapsebro.sql.azuresynapse.net:1433;database=mydedicatedpool;user=sqladminuser;password=asdgdsg;encrypt=true;trustServerCertificate=false;"

// We can use the write function to write to an external data store
dfcorrect.write
  .mode("append") // Here we are saying to append to the table
  .format("com.databricks.spark.sqldw")
  .option("url", connection)
  .option("tempDir", tmpdir) // For transfering to Azure Synapse, we need temporary storage for the staging data
  .option("forwardSparkAzureStorageCredentials", "true")
  .option("dbTable", tablename)
  .save()
