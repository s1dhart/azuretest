#!/bin/bash
cd /home/sid
http=$(ss -tln |   awk 'NR > 1{gsub(/.*:/,"",$4); print $4}' |  sort -un |  awk -v n=8080 '$0 < n {next}; $0 == n {n++; next}; {exit}; END {print n}')
ajp=$(ss -tln |   awk 'NR > 1{gsub(/.*:/,"",$4); print $4}' |  sort -un |  awk -v n=8009 '$0 < n {next}; $0 == n {n++; next}; {exit}; END {print n}')
ssl=$(ss -tln |   awk 'NR > 1{gsub(/.*:/,"",$4); print $4}' |  sort -un |  awk -v n=443 '$0 < n {next}; $0 == n {n++; next}; {exit}; END {print n}')
sudo echo "Following are the connection details of the deployment" > email.file
sudo echo "Customer Name" $1 >> email.file
sudo echo "HTTP Port Used" $http >> email.file
sudo echo "AJP Port Used" $ajp >> email.file
sudo echo "Username : sid1" >> email.file
sudo echo "Password: see passkey" >> email.file
sudo su - postgres -c "createdb -h localhost -p 1999 -U postgres $1"
#sudo java \
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
cd /home/sid
sudo echo Secure URL for newly Created deployment is : >> email.file
sudo echo  https://care.westeurope.cloudapp.azure.com:$ssl/eclipse/ >> email.file
sudo echo start cmd /k "C:\Users\saurabhs\Desktop\putty.exe" -ssh "care.westeurope.cloudapp.azure.com" >> putty.bas
(cat email.file ; uuencode NL_HLD.pdf NL_HLD.pdf ;uuencode putty.bas putty.bas )  | mail -s "Deployment details for Customer: "$1 sidhart@gmail.com,me@onenote.com,sid@olmgroup.com -a "From:saurabh.siddhartha@olmgroup.com"
