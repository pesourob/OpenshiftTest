# Fáze sestavení
FROM alpine:3.18 AS builder

# Kopírování dat do image
COPY data/ /opt

# Instalace potřebných balíčků a nastavení prostředí
RUN apk add --no-cache openjdk11-jdk vim unzip sudo && \
    mkdir -p /opt/IBM/java && \
    tar -xvzf /opt/TASK1/ibm-semeru-certified-jdk_x64_linux_11.0.21.0.tar.gz -C /opt/IBM/java/ && \
    java -jar /opt/TASK2/wlp-nd-all-23.0.0.12.jar --acceptLicense /opt/IBM && \
    rm -rvf /opt/TASK* google

# Fáze výsledné image
FROM alpine:3.18

# Kopírování potřebných souborů z fáze sestavení
COPY --from=builder /opt /opt

# Nastavení prostředí
ENV JAVA_HOME="/opt/IBM/java/jdk-11.0.21+9"
ENV PATH="$JAVA_HOME/bin:$PATH"

# Instalace sudo a nastavení uživatele
RUN apk add --no-cache sudo && \
    adduser -D -s /bin/bash wasadmin && \
    echo 'wasadmin ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    chown -R wasadmin:root /opt && \
    echo 'export JAVA_HOME=/opt/IBM/java/jdk-11.0.21+9' >> /home/wasadmin/.bashrc && \
    echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /home/wasadmin/.bashrc

# Přepnutí na uživatele wasadmin
USER wasadmin

# Spuštění aplikace
CMD ["/bin/bash"]
