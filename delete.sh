#!/bin/bash

# Delete Deployment
kubectl delete deployment flask-app

# Delete Service
kubectl delete service flask-app-service

# Delete Ingress
kubectl delete ingress flask-app-ingress