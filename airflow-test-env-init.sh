set -x

cd /usr/local/lib/python3.9/site-packages/airflow && \
# cp -R example_dags/* /root/airflow/dags/ && \
# cp -R contrib/example_dags/example_kubernetes_*.py /root/airflow/dags/ && \
# cp -a contrib/example_dags/libs /root/airflow/dags/ && \
airflow db init && \
alembic upgrade heads && \
(airflow users create --username airflow --lastname airflow --firstname airflow --email airflow@drakemultimedia.com --role Admin --password airflow || true) 