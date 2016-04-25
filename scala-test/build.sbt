name := "HBase Scala Test"

version := "1.0"

scalaVersion := "2.11.1"

libraryDependencies ++= Seq(
    "org.apache.hadoop" % "hadoop-client" % "2.7.1",
    "org.apache.hbase" % "hbase-common" % "1.1.4",
    "org.apache.hbase" % "hbase-client" % "1.1.4"

)