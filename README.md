HBase in Docker
===============

This configuration builds a docker container to run HBase (with
embedded Zookeeper) running on the files inside the container.

NOTE
----

This is a fork from https://github.com/dajobe/hbase-docker which adds docker-machine and docker-compose tools to the recipe.

Create local VM where to run HBASE on
-------------------------------------

    $ docker-machine create -d virtualbox --virtualbox-memory 4096 --virtualbox-boot2docker-url=https://github.com/boot2docker/boot2docker/releases/download/v1.9.0/boot2docker.iso dm-test

I am using 1.9.0 image due to a bug found with the 1.9.1 image (https://github.com/docker/docker/issues/18180).
You can use the VM name that you like. I used `dm-test`. If you changed it, you need to change it also in the next commands in this guide. Once the VM is created, setup the environment variables to connect your current command line session to the docker engine running in the new VM:

    $ eval `docker-machine env dm-test`


Run HBASE
----------

    $ docker-compose up -d

Find HBASE status
-----------------

As we are running the HBASE container with "host" networking, you should access the IP of the VM you created previously:

    $ dm ip dm-test

Master status:

    http://<dm-test-ip>:16010/master-status

Region server status:

    http://<dm-test-ip>:16030/rs-status

Thrift UI:

    http://<dm-test-ip>:9095/thrift.jsp


See HBASE Logs
--------------

To see all the logs since the HBase server started, use:

    $ docker-compose logs


To see the individual log files without using `docker`, look into
the data volume dir eg $PWD/data/logs if invoked as above.


Connect to the HBASE shell
--------------------------

As the console is setup to access the docker engine in the VM, you need to know the container name:

    $ docker-compose ps

Sample output:

    Name                Command        State   Ports
    -------------------------------------------------------
    hbasedocker_hbase_1   /opt/hbase-server   Up


Get the container name and use it in the next command to execute the HBASE shell:

    $ docker exec -it hbasedocker_hbase_1 /opt/hbase/bin/hbase shell


Test HBase is working via python over Thrift
--------------------------------------------

Here I am connecting to a docker container with the name 'dm-test'. The port 9090 is the
Thrift API port because [Happybase][1] [2] uses Thrift to talk to HBase.

    $ ipython
    Python 2.7.9 (default, Mar  1 2015, 12:57:24)
    Type "copyright", "credits" or "license" for more information.

    IPython 2.3.0 -- An enhanced Interactive Python.
    ?         -> Introduction and overview of IPython's features.
    %quickref -> Quick reference.
    help      -> Python's own help system.
    object?   -> Details about 'object', use 'object??' for extra details.

    In [1]: import happybase

    In [2]: connection = happybase.Connection('dm-test', 9090)

    In [3]: connection.create_table('table-name', { 'family': dict() } )

    In [4]: connection.tables()
    Out[4]: ['table-name']

    In [5]: table = connection.table('table-name')

    In [6]: table.put('row-key', {'family:qual1': 'value1', 'family:qual2': 'value2'})

    In [7]: for k, data in table.scan():
       ...:     print k, data
       ...:
    row-key {'family:qual1': 'value1', 'family:qual2': 'value2'}

    In [8]:
    Do you really want to exit ([y]/n)? y
    $

(Simple install for happybase: `sudo pip install happybase` although I
use `pip install --user happybase` to get it just for me)

Notes
-----

[1] http://happybase.readthedocs.org/en/latest/

[2] https://github.com/wbolster/happybase
