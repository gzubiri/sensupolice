FROM centos/systemd

RUN yum install epel-release -y

COPY SensuServer-master/sensu.repo /etc/yum.repos.d/

RUN yum install sensu -y 

COPY SensuServer-master/check-cpu.json /etc/sensu/conf.d/
COPY SensuServer-master/check-disk-usage.json /etc/sensu/conf.d/
COPY SensuServer-master/check-memory-percent.json /etc/sensu/conf.d
COPY SensuServer-master/check_nic.json /etc/sensu/conf.d/
#COPY SensuServer-master/check-ports.json /etc/sensu/conf.d/
COPY SensuServer-master/check-process.json /etc/sensu/conf.d/
#COPY SensuServer-master/check-metrics-memory.json /etc/sensu/conf.d/
#COPY SensuServer-master/check-metrics-net.json /etc/sensu/conf.d/
#COPY SensuServer-master/nic.sh /etc/sensu/conf.d/
COPY SensuServer-master/nic.sh /etc/sensu/conf.d/

RUN yum install redis -y

RUN systemctl enable redis

RUN yum install -y https://dl.bintray.com/rabbitmq/rpm/erlang/20/el/7/x86_64/erlang-20.0.1-1.el7.centos.x86_64.rpm

RUN yum install -y https://dl.bintray.com/rabbitmq/rabbitmq-server-rpm/rabbitmq-server-3.6.12-1.el7.noarch.rpm

COPY SensuServer-master/rabbitmq.json /etc/sensu/conf.d/

RUN systemctl enable rabbitmq-server

#RUN rabbitmqctl add_vhost /sensu

#RUN rabbitmqctl add_user sensu secret

#RUN rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"

RUN yum install sensu uchiwa -y

COPY SensuServer-master/client.json /etc/sensu/conf.d/

COPY SensuServer-master/uchiwa.json /etc/sensu/

RUN chown -R sensu:sensu /etc/sensu

RUN systemctl enable sensu-{server,api,client} \
&& systemctl enable uchiwa

COPY SensuServer-master/elescrip.sh /etc/sensu/conf.d/

RUN chmod 777 /etc/sensu/conf.d/elescrip.sh

COPY SensuServer-master/uchiwa.json /opt/uchiwa/bin/
COPY SensuServer-master/uchiwa.json /etc/sensu/dashboard.d/

RUN sensu-install -p cpu-checks
RUN sensu-install -p disk-checks
RUN sensu-install -p memory-checks
RUN sensu-install -p network-checks
RUN sensu-install -p process-checks

EXPOSE 3000

ENTRYPOINT ["bash", "-c", "bash /etc/sensu/conf.d/elescrip.sh && /usr/sbin/init"]
#ENTRYPOINT [ "bash", "-c", "usr/bin/redis-server --daemonize yes && /sbin/rabbitmq-server -detached -c /etc/sensu/conf.d/rabbitmq.json && sleep 3 && /usr/sbin/rabbitmqctl add_vhost /sensu && /usr/sbin/rabbitmqctl add_user sensu secret && /usr/sbin/rabbitmqctl set_permissions -p /sensu sensu \".*\" \".*\" \".*\" && /opt/sensu/embedded/bin/sensu-server -b -c /etc/sensu/conf.d/config.json  && /opt/sensu/embedded/bin/sensu-api -b -c /etc/sensu/conf.d/config.json && /opt/sensu/embedded/bin/sensu-client -b -c /etc/sensu/conf.d/client.json && /opt/uchiwa/bin/uchiwa -c /etc/sensu/uchiwa.json && /usr/sbin/init" ]


