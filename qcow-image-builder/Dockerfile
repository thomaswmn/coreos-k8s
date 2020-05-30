FROM centos:centos8

RUN yum clean all && \
    yum makecache && \
    yum -y update && \
    yum -y reinstall glibc-common
RUN yum -y install libguestfs-tools libguestfs-xfs

RUN export LIBGUESTFS_BACKEND=direct && libguestfs-test-tool && rm -fr /var/tmp/.guestfs-0/
