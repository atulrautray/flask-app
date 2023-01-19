# Favorite Athlete Server

Simple Flask app with a GET request, that returns my favorite athlete. The flask app is containerized and running on minikube.

## Description

In this project a simple Flask app with a GET method is deployed using Docker and Kubernetes.

### Flask App

The Flask server will only respond to requests made using the HTTP GET method. When a GET request is received, the server will return a JSON object containing a single key-value pair, with my favorite athlete. If any other type of request (e.g. POST, PUT, DELETE) is received, the server will return the string "Only GET method valid".

### Docker File

This Dockerfile starts with the base image "python:3.10-alpine", which is a minimal Alpine Linux distribution with Python 3.10 installed. Application files are then copied into the docker container using "WORKDIR" to create a container directory and "COPY" to copy contents. The neccessary dependancies (listed in the requirements.txt file) are installed using "RUN".

The resulting Docker Image is then pushed to a public repo (atulrautray/flask-app) to be accessed later by the kubernetes deployment.

### Kubernetes

The (containerized) Flask app is deployed on kubernetes using three components: deployment, service and ingress.

#### Deployment
* The deployment defines a deployment named "flask-app" with 3 pod replicas. The container uses the previously built image named "atulrautray/flaskapp:latest" and it has specific resource limits for memory and CPU. The container listens on port 5000.

#### Service
* The service provides an endpoint for accessing the pods managed by the deployment. This service is named "flask-app-service" and it uses a label selector to determine which pods it should send traffic to, in this case pods with the label "app: flask-app". The service listens on port 5000, and forwards traffic to the target port 5000 on the pods.

#### Ingress
* Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. The ingress is directing traffic to the service named "flask-app-service" on port 5000. The service resource has a selector that matches pods labeled with "app: flask-app" and it exposes the service on port 5000.

#### build-and-deploy script
* The build-and-deploy script does the following in order:
  * Set new path for KUBECONF (see Fixes section for details)
  * Start a minikube cluster
  * Apply a deployment and service
  * Delete Validating Webhook (see Fixes section for details)
  * Apply ingress
  * Store minikube IP in a shell variable
  * Wait 20 seconds for ingress to get assigned an IP (same as minikube ip)
  * Send curl GET request to the ingress IP
 
***
## Running the Project

### Dependencies

* minikube
* curl
* requests

### Executing program

* To run the flask-app, use the following command. The app should run and produce the output of a get request.
```
./build-and-deploy.sh
```
* If permission is denied to execute run.sh, allow execution by running this command first.
```
chmod +x build-and-deploy.sh
```

***
## Testing

* To run the test, use the following command. (Note-requires requests module)
```
python3 test.py
```
* To test the server manually, the IP can be found using the following command (flask-app/minikube should be running).
```
minikube ip
```

***
## Key Points, Questions, Problems and Fixes

### Flask app should run on 0.0.0.0

* By defaut flask will bind to localhost a.k.a. 127.0.0.1 which is only accessible to process running on the same machine. Docker containers are virtually different machines. Defining 0.0.0.0 is more or less 'listen to all'. That way the app will run on any internal ip address it will get from the docker infrastructure. [Source](https://www.reddit.com/r/docker/comments/xwfm08/why_do_i_need_to_specify_host0000_when_running_a/)

### Size of Docker Image

* Find ways to minimize size of image (try --no-cache??)

### kube.conf Permission Denied

* Unable to run minikube cluster because default kube.conf path permissions. Set $KUBECONFIG to a different config file as a workaround.

### Running Pods on Control Plane

* Minikube is a single node cluster by default. Consequesntly, the pod with the app is deployed in the control plane. Is this ok/bad/dangerous?

### Cluster-IP

* How does clusterip decide which pod to forward traffic to? Does it act as a load balancer?

### Using a Custom URL for Ingress

* To map a custom url to the ingress IP, the mapping needs to be added to the /etc/hosts file which requires sudo access. No url has been set for this project.

### Ingress Controller Error

* Occassionally, would get error when trying to create ingress (Internal error occurred: failed calling webhook). Resolved by removing the Validating Webhook entirely. [Source](https://stackoverflow.com/questions/61616203/nginx-ingress-controller-failed-calling-webhook)

### Ingress IP

* Does ingress always have the IP? IP has been hardcoded in test.py until work-around is found.