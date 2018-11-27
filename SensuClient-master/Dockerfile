FROM centos/systemd

RUN yum install epel-release -y

COPY ./sensu.repo /etc/yum.repos.d/

RUN yum install sensu -y 

COPY ./client.json /etc/sensu/conf.d/client.json

COPY ./rabbitmq.json /etc/sensu/conf.d/rabbitmq.json

COPY ./transport.json /etc/sensu/transport.json

RUN chown -R sensu:sensu /etc/sensu

RUN sensu-install -p cpu-checks
RUN sensu-install -p disk-checks
RUN sensu-install -p memory-checks
RUN sensu-install -p network-checks
RUN sensu-install -p process-checks

COPY ./clientscript.sh /etc/sensu/conf.d/clientscript.sh

RUN chmod 777 /etc/sensu/conf.d/clientscript.sh

EXPOSE 3000

ENTRYPOINT ["bash", "-c", "bash /etc/sensu/conf.d/clientscript.sh && /usr/sbin/init"]

#CMD ["/usr/sbin/init"]

