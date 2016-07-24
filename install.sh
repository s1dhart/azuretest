#!/bin/bash
cd /home/sid
http=$(ss -tln |   awk 'NR > 1{gsub(/.*:/,"",$4); print $4}' |  sort -un |  awk -v n=8080 '$0 < n {next}; $0 == n {n++; next}; {exit}; END {print n}')
ajp=$(ss -tln |   awk 'NR > 1{gsub(/.*:/,"",$4); print $4}' |  sort -un |  awk -v n=8009 '$0 < n {next}; $0 == n {n++; next}; {exit}; END {print n}')
ssl=$(ss -tln |   awk 'NR > 1{gsub(/.*:/,"",$4); print $4}' |  sort -un |  awk -v n=443 '$0 < n {next}; $0 == n {n++; next}; {exit}; END {print n}')
sudo echo $1, $http, $ajp > param.file
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
-Dinput.target.tomcat.http.port=$http \
-Dinput.target.ajp.port=$ajp \
-jar /home/sid/eclipse-installer-1.3.0-SNAPSHOT.jar \
-console \
-options-system
sudo start olm_$1_eclipse
sudo cp /etc/nginx/sites-available/eclipse_template /etc/nginx/sites-available/$1
cd /etc/nginx/sites-available
sudo sed -i s/443/$ssl/g $1
sudo sed -i s/8011/$ajp/g $1
sudo sed -i s/sidenv1/$1/g $1
cd /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/$1 $1
sudo service nginx reload
echo https://care.westeurope.cloudapp.azure.com:$ssl/eclipse/ | sudo sendmail -f "saurabh.siddhartha@olmgroup.com" me@onenote.com,sid@olmgroup.com
