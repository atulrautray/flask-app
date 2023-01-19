# Favorite Athlete Server

Simple flask app with a get request, that returns my favorite athlete. The flask app is containerized and running on minikube

## Description

An in-depth paragraph about your project and overview of use.

## Running the Project

### Dependencies

* minikube
* curl

### Executing program

* To run the flask-app, use the following command. The app should run and produce the output of a get request
```
./run.sh
```
* If perssion is denied to execute run.sh, allow execution by running this command first.
```
chmod +x run.sh
```

## Testing

* To run the test, use the following command.
```
python3 test.py
```
* To test the server manually, the ip can be found using the following command(flask-app/minikube should be running).
```
minikube ip
```

## Key Points and Problems Encountered

### Flask app should run on 0.0.0.0
* By defaut flask will bind to localhost a.k.a. 127.0.0.1 which is only accessible to process running on the same machine. Docker containers are virtually different machines. [Source](https://www.reddit.com/r/docker/comments/xwfm08/why_do_i_need_to_specify_host0000_when_running_a/)

### Size of Docker Image
* Find ways to minimize size of image (look up --no-cache)

### kube.conf Permission Denied
* Unable to run minikube cluster because default kube.conf path permissions. Set $KUBECONFIG to a different config file as a workaround.

### Running Pods on Control Plane
* ??

### Using a Custom URL for Ingress
* To map a custom url to the ingress IP, the mapping needs to be added to the /etc/hosts file which requires sudo access. No url has been set for this project.

### Ingress Controller Error
* Occassionally, would get error when trying to create ingress (Internal error occurred: failed calling webhook). Resolved by removing the Validating Webhook entirely. [Source](https://stackoverflow.com/questions/61616203/nginx-ingress-controller-failed-calling-webhook)

