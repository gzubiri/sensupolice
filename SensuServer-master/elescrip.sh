usr/bin/redis-server --daemonize yes
/sbin/rabbitmq-server -detached -c /etc/sensu/conf.d/rabbitmq.json
sleep 3
rm -f /etc/sensu/uchiwa.json
cp /etc/sensu/uchiwa.json /etc/sensu/dashboard.d/uchiwa.json
/usr/sbin/rabbitmqctl add_vhost /sensu
/usr/sbin/rabbitmqctl add_user sensu secret
/usr/sbin/rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
/opt/sensu/embedded/bin/sensu-server -b -c /etc/sensu/conf.d/config.json &
/opt/sensu/embedded/bin/sensu-api -b -c /etc/sensu/conf.d/config.json &
/opt/sensu/embedded/bin/sensu-client -b -c /etc/sensu/conf.d/client.json &
/opt/uchiwa/bin/uchiwa -d /etc/sensu/dashboard.d -c /etc/sensu/dashboard.d/uchiwa.json -p /opt/uchiwa/src/public
/usr/sbin/init
