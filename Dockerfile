FROM openjdk:8-jre-stretch

EXPOSE 8080/tcp

# Setup
RUN apt-get update && \
    apt-get -y install python2.7 \
                       python-requests \
                       supervisor

ADD download-streama.py /download-streama.py
ADD supervisord.conf /etc/supervisor/supervisord.conf

RUN chmod +x /download-streama.py

# Install Streama
WORKDIR /opt
RUN python /download-streama.py && \
    ln -s /opt/*.war /opt/streama.war && \
    chmod +x /opt/*

# Cleanup
RUN apt-get -y remove build-essential \
                      python-dev \
                      libz-dev \
                      wget && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/* \
           /download-streama.py

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
VOLUME [ "/opt/streama" ]