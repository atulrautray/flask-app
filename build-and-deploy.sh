#!/bin/bash

cd docker-files

# Run the test script
python3 test.py

# Check if the test passed
if [ $? -eq 0 ]; then
    echo "Tests passed"

    echo "Building image"
    docker build -t sampleaccount9234/flaskapp:latest .

    echo "Pushing image to dockerhub"
    echo "Samplepassword123" | docker login -u "sampleaccount9234" --password-stdin
    docker push sampleaccount9234/flaskapp:latest

    cd ..

    export KUBECONFIG=./mykube.conf

    minikube start

    kubectl apply -f deployment.yaml

    kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

    kubectl apply -f flask-app-ingress.yaml

    MINIKUBE_IP=$(minikube ip)

    sleep 20

    curl $MINIKUBE_IP
else
    echo "Tests failed"
fi
