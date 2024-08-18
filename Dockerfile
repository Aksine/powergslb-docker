# Use the CentOS 7.9.2009
FROM centos:7.9.2009

# Set the timezone
ENV TZ=Australia/Melbourne
# Set the version of PowerGSLB
ENV VERSION=1.7.4

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Install necessary packages
RUN yum -y install epel-release && \
   yum -y update && \
   yum -y install supervisor nc bind-utils iproute less mariadb-client net-tools python2-pip && \
   pip install --upgrade pip && \
   pip install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org --trusted-host pypi.org pyping


# Download and install PowerGSLB
RUN yum -y --setopt=tsflags="" install \
   "https://github.com/AlekseyChudov/powergslb/releases/download/$VERSION/powergslb-$VERSION-1.el7.noarch.rpm" \
   "https://github.com/AlekseyChudov/powergslb/releases/download/$VERSION/powergslb-admin-$VERSION-1.el7.noarch.rpm" \
   "https://github.com/AlekseyChudov/powergslb/releases/download/$VERSION/powergslb-pdns-$VERSION-1.el7.noarch.rpm"



COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start the entrypoint script
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]






# Expose the necessary ports
EXPOSE 53/tcp
EXPOSE 53/udp
EXPOSE 80/tcp
