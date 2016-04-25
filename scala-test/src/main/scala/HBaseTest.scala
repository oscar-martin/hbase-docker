import java.util.UUID

import org.apache.hadoop.hbase.{HColumnDescriptor, HTableDescriptor, HBaseConfiguration}
import org.apache.hadoop.hbase.client.{Put, HTable, HBaseAdmin}
import org.apache.hadoop.hbase.util.Bytes

object HBaseTest extends App {


    def createTable(name: String) {
        val config = HBaseConfiguration.create()
        config.set("hbase.zookeeper.quorum", "hbase-docker")
        config.set("hbase.zookeeper.property.clientPort", "2181")

        val tableName = name
        val hbaseAdmin = new HBaseAdmin(config)
        val family = Bytes.toBytes("f1")

        if (!hbaseAdmin.tableExists(tableName)) {
            val desc = new HTableDescriptor(tableName)
            desc.addFamily(new HColumnDescriptor(family))
            hbaseAdmin.createTable(desc)
            println("table created: " + tableName)
        }

        val table = new HTable(config, tableName)

        val qualifier = Bytes.toBytes("column")

        val value = 365

        val put = new Put(Bytes.toBytes(UUID.randomUUID().toString))
        put.add(family, qualifier, Bytes.toBytes(value.toString()))
        table.put(put)
        table.close()
    }

    createTable("mytable")

}
