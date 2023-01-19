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
* By defaut flask will bind to localhost a.k.a. 127.0.0.1 which is only accessible to process running on the same machine. Docker containers are virtually different machines

### Size of Docker Image
* Find ways to minimize size of image
