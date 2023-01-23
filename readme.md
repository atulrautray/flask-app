# Favorite Athlete Server

Simple Flask app with a GET request, that returns my favorite athlete. The flask app is containerized and running on minikube.

## Description

In this project a simple Flask app with a GET method is deployed using Docker and Kubernetes.

### Flask App

The Flask server will only respond to requests made using the HTTP GET method. When a GET request is received, the server will return a JSON object containing a single key-value pair, with my favorite athlete. If any other type of request (e.g. POST, PUT, DELETE) is received, the server will return the string "Only GET method valid".

### Docker File

This Dockerfile starts with the base image "python:3.10-alpine", which is a minimal Alpine Linux distribution with Python 3.10 installed. Application files are then copied into the docker container using "WORKDIR" to create a container directory and "COPY" to copy contents. The neccessary dependancies (listed in the requirements.txt file) are installed using "RUN".

### Kubernetes

The (containerized) Flask app is deployed on kubernetes using three components: deployment, service and ingress.

#### Deployment

* The deployment defines a deployment named "flask-app" with 3 pod replicas. The container uses the previously built image named "flaskapp:latest" and it has specific resource limits for memory and CPU. The container listens on port 5000. The pod is configured to run as a non-root user.

#### Service

* The service provides an endpoint for accessing the pods managed by the deployment. This service is named "flask-app-service" and it uses a label selector to determine which pods it should send traffic to, in this case pods with the label "app: flask-app". The service listens on port 5000, and forwards traffic to the target port 5000 on the pods.

#### Ingress

* Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. The ingress is directing traffic to the service named "flask-app-service" on port 5000. The service resource has a selector that matches pods labeled with "app: flask-app" and it exposes the service on port 5000.

### build-and-deploy script

* The build-and-deploy script does the following in order:
  * Install flask
  * Run a mock test on the Flask app
  * If test is successful
  * Unset KUBECONF
  * Start a minikube cluster
  * Switch the context of docker
  * Build the docker image
  * Apply a deployment and service
  * Delete Validating Webhook (see Fixes section for details)
  * Apply ingress
  * Store minikube IP in a shell variable
  * Wait 20 seconds for ingress to get assigned an IP
  * Send curl GET request to the ingress IP
 
## Running the Project

### Dependencies

* minikube
* curl
* flask module

### Executing program

* To run the flask-app, use the following command. The app should run and produce the output of a GET request.
```
./build-and-deploy.sh
```
* To delete the deployment, service and ingress use the following command.
```
./delete.sh
```
* If permission is denied while trying to execute either shell script, allow execution by running this command first.
```
chmod +x build-and-deploy.sh
<or>
chmod +x delete.sh
```

## Testing

* The Flask app's functionality is tested by the test.py file before the docker image is built. The test.py does not need the Flask server to be running, it directly tests the functions in the app. No HTTP requests are made.

* To test the server manually, the IP can be found using the following command (flask-app and minikube should be running). curl requests can be sent to this IP to verify that app is running.
```
minikube ip
```

* With the IP from the above command, we can try different URL's such as:
  * <ip from previous command\>.nip.io
  * atuls-fav-athlete.<ip from previous command\>.nip.io
  * loacal-arc.<ip from previous command\>.nip.io
  * Go to [nip.io](https://nip.io/) for details

## Key Points, Questions, Problems and Fixes

### Flask app should run on 0.0.0.0

* By defaut flask will bind to localhost a.k.a. 127.0.0.1 which is only accessible to process running on the same machine. Docker containers are virtually different machines. Defining 0.0.0.0 is more or less 'listen to all'. That way the app will run on any internal ip address it will get from the docker infrastructure. [Source](https://www.reddit.com/r/docker/comments/xwfm08/why_do_i_need_to_specify_host0000_when_running_a/)

### Reduce Size of Docker Image?

* Find ways to minimize size of image (try --no-cache??)

### Using local Docker Images

*  Instead of pushing the image to dockerhub and making kubernetes pull from there, minikkube looks for the local image. Firstly, switch the context of docker to minikube using eval $(minikube docker-env). Secondly, change the deployment to make sure it never pulls an image by setting imagePullPolicy: Never.

### kube.conf Permission Denied

* Unable to run minikube cluster because default kube.conf path permissions. Unset KUBECONFIG.

### Kubeconfig file and Contexts

* The kubeconfig file is a configuration file used by the command-line tool kubectl to connect to a Kubernetes cluster. It is a JSON or YAML file that contains information such as the API server endpoint, the authentication method and credentials, and the default namespace. Contexts is a combination of cluster, user and namespace.

### Running Pods on Control Plane?

* Minikube is a single node cluster by default. Consequesntly, the pod with the app is deployed in the control plane. Is this ok/bad/dangerous?

### Cluster-IP Service Forwarding

* The Service resource is indeed a load-balancer. Depending on the proxy mode it could be round-robin or random. If you're going with the default (iptables-based proxy) it would be a random pod selected every time you hit the virtual IP of the service. [Source](https://stackoverflow.com/questions/52268491/how-does-kubernetes-service-decide-which-backend-pod-to-route-to)

### Load Balancer vs Ingress

* Load Balancers in Kubernetes have quite a bit of overlap with ingresses. This is because they are primarily used to expose services to the internet, which is also a feature of ingresses. However, rather than a standalone object like an ingress, a load balancer is just an extension/type of a service. [Source](https://www.baeldung.com/ops/kubernetes-ingress-vs-load-balancer)

### Using a Custom URL for Ingress

* To map a custom url to the ingress IP, the mapping needs to be added to the /etc/hosts file which requires sudo access. No url has been set for this project.

### Ingress Controller Error

* Occassionally, would get error when trying to create ingress (Internal error occurred: failed calling webhook). Resolved by removing the Validating Webhook entirely. [Source](https://stackoverflow.com/questions/61616203/nginx-ingress-controller-failed-calling-webhook)