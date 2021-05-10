# Sample Apache Airflow in Kubernetes

This repo is an example of running Apache Airflow in Kubernetes.

## Prerequisites 

* Minikube
* kubectl
* Docker

# Build Docker Image

```shell
$ docker build -t <docker repo>:latest .
$ docker push <docker repo>:latest
```

# Create Kubernetes Deployment

```shell
$ ./kube/apply.sh
```