#!/bin/bash
curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-s390x.tar.gz
tar -xvzf node_exporter-1.0.1.linux-s390x.tar.gz
mv node_exporter-1.0.1.linux-s390x/node_exporter /usr/local/bin
rm -rf node_exporter-1.0.1.linux-s390x*

echo '#!/bin/bash
# chkconfig: 2345 20 80
# Source function library.
. /etc/init.d/functions

start() {
   ./usr/local/bin/node_exporter &
   echo "Node Exporter is starting..."
}

stop(){
killall node_exporter
}

status(){
if [[ $? != 0 ]]; then
    /etc/init.d/node_exporter start
fi
}

case "$1" in
        start)
                start 
                ;;
        stop)
                stop 
                ;;
        restart)
                stop
                start
                ;;
        status)
                status
                ;;
        *)
echo $"Usage: $0 {start|stop|restart|reload|status}" 
esac
exit $?' > node_exporter
chmod 755 node_exporter
mv node_exporter /etc/init.d/
service node_exporter start

chkconfig --add node_exporter
chkconfig --level 35 node_exporter on
chkconfig --list

iptables -I INPUT 1 -p tcp --dport 9100 -j ACCEPT
service iptables save

cd ~/tmp
rm -rf install-scripts/
