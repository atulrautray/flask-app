#!/bin/bash

export KUBECONFIG=./mykube.conf

minikube start

kubectl apply -f deployment.yaml

kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

kubectl apply -f flask-app-ingress.yaml

MINIKUBE_IP=$(minikube ip)

export MINIKUBE_IP

sleep 20

curl $MINIKUBE_IP
