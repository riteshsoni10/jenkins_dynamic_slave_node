FROM alpine:latest
MAINTAINER Ritesh Kumar(soni199513@gmail.com)
RUN apk add --no-cache --update openssh openjdk11 curl gettext && \
    adduser -D -h /home/slave_node --gecos "Jenkins Slave Node" slave_node && \
    echo "slave_node:jenkins" | chpasswd && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/bin && \
    ssh-keygen -A && \
    mkdir /home/slave_node/.kube

COPY client.crt client.key ca.crt config.template /home/slave_node/.kube/
RUN chown -Rf slave_node.slave_node /home/slave_node/.kube
ENV KUBERNETES_CLUSTER_IP="192.168.99.101"
ENV CA_CERTIFICATE="ca.crt"
ENV CLIENT_CERTIFICATE="client.crt"
ENV CLIENT_KEY="client.key"

EXPOSE 22
RUN envsubst "`env | awk -F = '{printf " \\\\$%s", $1}'`" < /home/slave_node/.kube/config.template > /home/slave_node/.kube/config


CMD ["/usr/sbin/sshd", "-D"]


