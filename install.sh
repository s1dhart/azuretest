#!/bin/sh
java \
-DTRACE=true \
-DDEBUG=true \
-Dinput.target.db.server.hostname=localhost \
-Dinput.target.db.server.dbname_schema=INST_dev \
-Dinput.target.db.server.port=5432 \
-Dinput.target.install.environment=auto \
-Dinput.target.db.username=postgres \
-Dinput.target.db.password=postgres \
-Dinput.target.db.platform=POSTGRESQL \
-Dinput.target.install.user=autouser \
-Dinput.target.install.group=autogroup \
-jar /media/sf_ecl-installer/target/eclipse-installer-1.3.0-SNAPSHOT.jar \
-console \
-options-system
