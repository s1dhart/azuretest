#!/bin/bash
cd /home/sid
echo $1, $2, $3 > param.file
sudo java \
-DTRACE=true \
-DDEBUG=true \
-Dinput.target.db.server.hostname=localhost \
-Dinput.target.db.server.dbname_schema=$1 \
-Dinput.target.db.server.port=1999 \
-Dinput.target.install.environment=$1 \
-Dinput.target.db.username=postgres \
-Dinput.target.db.password=postgres \
-Dinput.target.db.platform=POSTGRESQL \
-Dinput.target.install.user=autouser \
-Dinput.target.install.group=autogroup \
-Dinput.target.tomcat.http.port=$2
-Dinput.target.ajp.port=$3
-jar /home/sid/eclipse-installer-1.3.0-SNAPSHOT.jar \
-console \
-options-system
