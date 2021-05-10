#!/bin/bash

DIRNAME=$(cd "$(dirname "$0")"; pwd)
BUILD_DIRNAME=${DIRNAME}/build

kubectl apply -f $DIRNAME/namespace.yaml
kubectl config set-context --current --namespace=airflow-example 

set -e

kubectl apply -f $DIRNAME/secrets.yaml
kubectl apply -f $BUILD_DIRNAME/configmaps.yaml
kubectl apply -f $DIRNAME/postgres.yaml
kubectl apply -f $DIRNAME/volumes.yaml
kubectl apply -f $BUILD_DIRNAME/airflow.yaml

# wait for up to 10 minutes for everything to be deployed
PODS_ARE_READY=0
for i in {1..150}
do
  echo "------- Running kubectl get pods -------"
  PODS=$(kubectl get pods | awk 'NR>1 {print $0}')
  echo "$PODS"
  NUM_AIRFLOW_READY=$(echo $PODS | grep airflow | awk '{print $2}' | grep -E '([0-9])\/(\1)' | wc -l | xargs)
  NUM_POSTGRES_READY=$(echo $PODS | grep postgres | awk '{print $2}' | grep -E '([0-9])\/(\1)' | wc -l | xargs)
  if [ "$NUM_AIRFLOW_READY" == "1" ] && [ "$NUM_POSTGRES_READY" == "1" ]; then
    PODS_ARE_READY=1
    break
  fi
  sleep 4
done

if [[ "$PODS_ARE_READY" == 1 ]]; then
  echo "PODS are ready."
else
  echo "PODS are not ready after waiting for a long time. Exiting..."
  exit 1
fi