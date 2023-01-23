#!/bin/bash

# Install Flask
pip3 install flask

# Run the test script
python3 test.py

# Check if the test passed
if [ $? -eq 0 ]; then
    echo "Tests passed"

    export KUBECONFIG=./mykubectl.conf

    minikube start

    eval $(minikube docker-env)

    echo "Building image"
    docker build -t flaskapp:latest .

    kubectl apply -f deployment.yaml

    kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

    kubectl apply -f flask-app-ingress.yaml

    MINIKUBE_IP=$(minikube ip)

    sleep 10

    curl $MINIKUBE_IP

    export KUBECONFIG=./mykubectl.conf
else
    echo "Tests failed"
fi
