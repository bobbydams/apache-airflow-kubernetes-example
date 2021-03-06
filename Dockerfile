FROM python:3.9-slim

# install deps
RUN apt-get update -y && apt-get install -y \
    libczmq-dev \
    libssl-dev \
    inetutils-telnet \
    bind9utils \
    gcc \
    && apt-get clean

RUN pip install --upgrade pip

RUN pip install apache-airflow
RUN pip install 'apache-airflow[kubernetes]'
RUN pip install 'apache-airflow[postgres]'

COPY airflow-test-env-init.sh /tmp/airflow-test-env-init.sh
RUN chmod +x /tmp/airflow-test-env-init.sh

COPY bootstrap.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh
ENTRYPOINT ["/bootstrap.sh"]