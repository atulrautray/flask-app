#!/bin/bash

# Install Flask
pip3 install flask

# Run the test script
python3 test.py

# Check if the test passed
if [ $? -eq 0 ]; then
    echo "Tests passed"

    unset KUBECONFIG

    minikube start

    minikube addons enable ingress

    eval $(minikube docker-env)

    echo "Building image"
    docker build -t flaskapp:latest .

    kubectl apply -f deployment.yaml

    kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

    kubectl apply -f flask-app-ingress.yaml

    MINIKUBE_IP=$(minikube ip)

    sleep 10

    unset KUBECONFIG

    curl $MINIKUBE_IP/athlete
else
    echo "Tests failed"
fi
