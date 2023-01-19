# Use python:3.10-alpine as the base image
FROM python:3.10-alpine

# Set the working directory to /app
WORKDIR /app

# Copy the current directory to the /app directory in the container
COPY . /app

# Run pip install to install all the package dependencies specified in the requirements.txt file
RUN pip install -r requirements.txt

# Tell Docker that the container will listen on port 5000
EXPOSE 5000

# Specify the command that will run when the container starts
CMD ["python3", "/app/app.py"]
