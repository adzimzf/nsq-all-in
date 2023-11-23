# Use a base image that suits your application
FROM ubuntu:latest

# Install Supervisor
RUN apt-get update &&  apt-get install -y supervisor && apt-get install -y wget

# Install NSQ.
RUN \
  mkdir -p /tmp/nsq && \
  wget https://s3.amazonaws.com/bitly-downloads/nsq/nsq-1.2.1.linux-amd64.go1.16.6.tar.gz -O - | tar -xvz --strip=1 -C /tmp/nsq && \
  mv /tmp/nsq/bin/* /usr/local/bin/ && \
  rm -rf /tmp/nsq

# Expose ports.
EXPOSE 4150
EXPOSE 4151
EXPOSE 4160
EXPOSE 4161
EXPOSE 4171

# Create a directory for your application
WORKDIR /usr/src/app

# Copy the Supervisor configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Run Supervisor on container start
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
