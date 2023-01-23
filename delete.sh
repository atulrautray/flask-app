#!/bin/bash

kubectl delete deployment flask-app

kubectl delete service flask-app-service

kubectl delete ingress flask-app-ingress