#!/bin/bash
cd /home/sid
$2=ss -tln |   awk 'NR > 1{gsub(/.*:/,"",$4); print $4}' |  sort -un |  awk -v n=8080 '$0 < n {next}; $0 == n {n++; next}; {exit}; END {print n}'
$3=ss -tln |   awk 'NR > 1{gsub(/.*:/,"",$4); print $4}' |  sort -un |  awk -v n=8009 '$0 < n {next}; $0 == n {n++; next}; {exit}; END {print n}'
echo $1, $2, $3 > param.file
sudo su - postgres -c "createdb -h localhost -p 1999 -U postgres $1"
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
-Dinput.target.tomcat.http.port=$2 \
-Dinput.target.ajp.port=$3 \
-jar /home/sid/eclipse-installer-1.3.0-SNAPSHOT.jar \
-console \
-options-system
