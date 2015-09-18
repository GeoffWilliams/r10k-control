FROM pe2015-2-0_aio-master
RUN yum clean all
RUN yum install -y sudo openssh-server openssh-clients curl ntpdate
EXPOSE 22
CMD /usr/sbin/init
