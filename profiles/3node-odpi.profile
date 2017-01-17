{
  "domain": "example.com",
  "realm": "EXAMPLE.COM",
  "security": false,
  "vm_mem": 2048,
  "server_mem": 300,
  "client_mem": 200,
  "clients" : [ "hdfs", "yarn", "zk", "hive", "tez" ],
  "nodes": [
    { "hostname": "nn", "ip": "240.0.0.11",
      "roles": [ "hive-db", "hive-meta", "nn", "yarn", "zk", "client" ] },
    { "hostname": "slave1", "ip": "240.0.0.12", "roles": [ "slave", "client", "hive-hs2" ] },
    { "hostname": "slave2", "ip": "240.0.0.13", "roles": [ "slave" ] },
    { "hostname": "slave3", "ip": "240.0.0.14", "roles": [ "slave", "client", "dev" ] }
  ]
}
