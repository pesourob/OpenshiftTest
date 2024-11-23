FROM rockylinux:9.1

MAINTAINER robert.pesout@tietoevry.com

COPY data/ /opt

USER root

# Preparing image & Installation packages
ENV JAVA_HOME="/opt/IBM/java/jdk-11.0.21+9"
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN yum install -y vim unzip && yum -y clean all && rm -rf /var/cache/yum && \
    useradd -m -s /bin/bash -G wheel wasadmin

RUN mkdir -p /opt/IBM/java && \
    tar -xvzf /opt/TASK1/ibm-semeru-certified-jdk_x64_linux_11.0.21.0.tar.gz -C /opt/IBM/java/ && \
    mkdir -p /opt/IBM/ && \
    chown -R wasadmin:root /opt && \
    echo 'export JAVA_HOME=/opt/IBM/java/jdk-11.0.21+9' >> /home/wasadmin/.bashrc && \
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /home/wasadmin/.bashrc

USER wasadmin

RUN source /home/wasadmin/.bashrc && java -jar /opt/TASK2/wlp-nd-all-23.0.0.12.jar --acceptLicense /opt/IBM && rm -rvf /opt/TASK* google
