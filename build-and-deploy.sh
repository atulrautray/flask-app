#!/bin/bash

# Run the test script
python3 test.py

# Check if the test passed
if [ $? -eq 0 ]; then
    echo "Tests passed"

    unset KUBECONFIG

    minikube start

    eval $(minikube docker-env)

    echo "Building image"
    docker build -t flaskapp:latest .

    kubectl apply -f deployment.yaml

    kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

    kubectl apply -f flask-app-ingress.yaml

    MINIKUBE_IP=$(minikube ip)

    sleep 20

    curl $MINIKUBE_IP
else
    echo "Tests failed"
fi
