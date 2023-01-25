# Use python:3.10-alpine as the base image
FROM python:3.10-alpine

# Create non root user
RUN adduser -u 1000 -D worker

# Set the working directory to /app
WORKDIR /app

# Copy the current directory to the /app directory in the container as the non-root user
COPY --chown=worker:worker . /app

# Run pip install to install all the package dependencies specified in the requirements.txt file
RUN pip install --no-cache-dir -r requirements.txt

# Tell Docker that the container will listen on port 8000
EXPOSE 8000

# Specify the command that will run when the container starts
CMD ["gunicorn", "app:app", "-b", "0.0.0.0:8000"]
