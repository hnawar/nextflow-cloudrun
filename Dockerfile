FROM python:3.7

# Copy local code to the container image.
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

#Install Nextflow
RUN apt update  && apt install -y openjdk-11-jre curl
RUN curl -fsSL https://get.nextflow.io | bash

COPY nextflow.config .
COPY credentials.json .
COPY main.nf .
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/credentials.json
ENV NXF_MODE=google
ENV NXF_VER=21.04.3


# Install production dependencies.
RUN pip install Flask gunicorn
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app
