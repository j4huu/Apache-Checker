#! /bin/bash

###edit the following
email1=adresa1@mail.com 
email2=adresa2@mail.com
###stop editing

host=`hostname -f`
if (( $(ps -ef | grep -v grep | grep apache2 | wc -l) > 0 ))
  then
  echo "Apache webserver is running"
else
  /etc/init.d/apache2 start && 
  [[ curl -o /dev/null --silent --head --write-out '%{http_code}' "localhost" -eq 200]] &&
  [[ $(ss -tlnp | grep apache2 | wc -l) >0]]
  if (( $(ps -ef | grep -v grep | grep apache2 | wc -l) > 0 ))
    then
    subject="Apache webserver at $host has been started"
  echo "$service at $host wasn't running and has been started on port 80 and the requests from it are OK" | mail -s "$subject" $email1
  else
  subject="Apache webserver at $host is not running"
  echo "Apache webserver at $host is stopped and cannot be started!!!" | mail -s "$subject" $email2
  fi
fi
