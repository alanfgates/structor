#  Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

class postgres {
  $path = "/bin:/usr/bin"

  package { 'postgresql-server':
    ensure => installed,
  }
  ->
  exec { "initialize-postgres":
    command => "initdb -D /var/lib/pgsql/data/",
    user => "postgres",
    path => "${path}",
    creates => "/var/lib/pgsql/data/PG_VERSION", # only run this the first time
  }
  ->
  file { "postgres-log":
    path => "/var/log/postgres",
    ensure => "directory",
    mode => "0755",
    owner => "postgres",
  }
  ->
  exec { "start-postgres":
    command => "pg_ctl start -l /var/log/postgres/logfile -D /var/lib/pgsql/data",
    user => "postgres",
    path => "${path}",
    creates => "/var/lib/pgsql/data/postmaster.pid",
  }
  ->
  exec { "createuser-hive":
    command => "createuser -D -R -S hive",
    user => "postgres",
    path => "${path}",
    tries => 3, # It can take a few seconds for the database to get up and going, which can cause this command to fail
    try_sleep => 15,
  }
  ->
  exec { "createdb-hive":
    command => "createdb -O hive hive",
    user => "postgres",
    path => "${path}",
  }
}
