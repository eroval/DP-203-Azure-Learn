// Getting data from Azure Data Lake

// We can now set the configuration and access the key from the key vault
val storage = "h24pgen2"
spark.conf.set(
    "fs.azure.account.key." + storage + ".dfs.core.windows.net",
    dbutils.secrets.get(scope="myjkey",key="h24pgen2"))

val df = spark.read.format("csv").option("header","true").load("abfss://databricks@"+storage+".dfs.core.windows.net/Log.csv")

display(df)