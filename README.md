# Project Structure

This project is separated into two parts. The first one is the microservice to match an invoice against a database of company names which can be found in `cp-matcher` utilizing tesseract to do ocr tasks. The second folder `tf` contains all files to setup the infrastructure and provision required services to run the microservice on a gke cluster.

# Development

The dev env is using only basic docker functionality. To mirror better the production env this could be migrated to minikube etc. in the future. All commands are run from the root of the project.

We will start two containers running postgres and tesseract

```bash
docker run --name postgres \
    -d -e POSTGRES_PASSWORD=password \
    postgres:11
```

```bash
docker run --name tesseract -d \
    mauvilsa/tesseract-recognize:2020.01.13-ubuntu18.04-pkg
```


After the two preconditions are met we can start the interactive development env. This container will be initialized by a shell script to install and configure the environment to directly get started with development.

```bash
docker run --rm -it \
    -v `pwd`/cp-matcher:/src \
    -w /src \
    --link tesseract:tesseract \
    --link postgres:postgres \
    ruby:2.7 bin/dev.sh
```

After everything is installed the test can be run inside this container with running `rspec`. To start the development server run `rails s`.

# Provisioning

Before provisioning the whole infrastructure the docker image of the cp-matcher needs to be build and pushed to a registery. The docker image is based on an official small footprint alpine docker image (ruby:2.7) and extended to run the cp-matcher. With the terraform docker provider and by using dind the following step can be integrated into terraform.

```bash
docker build -t rics3n/cp-matcher:latest cp-matcher/.
docker push rics3n/cp-matcher:latest
```

All other provisioning tasks are done from within a pre-configured docker container. This container has all the tools installed for provisioning tasks.

```bash
docker build -t rics3n/infra-gce:latest tf/docker-image/.
docker run --rm -ti \
    -v `pwd`:/infra \
    -u `id -u`:`id -g` \
    rics3n/infra-gce:latest
```

The stack is based on gce. First we need to configure the credentials used to interact with the gce api. Then terrform is used to provision the whole infrastrucure including all services.

```bash
gcloud init
terraform init
terraform apply
```

Unfortunatley one manual step has to be performed to run database migration and preload data into the db. This should also be integrated into the terraform scripts.

```bash
kubectl exec -it \
    $(kubectl get pods | grep cp-matcher | awk '{print $1}' | head -n 1) \
    -- /bin/sh
```

Inside the container the db migration can be run with `rails db:migrate`. This step will also preload the data from seed.rb. Everything is setup now and the app can be used.

# Api

The cp-matcher service exposes two routes:

1. Status 

This endpoint exposes a status api to check if the api server was started and is running.

```api
GET /api/v1/status
```

2. Company Name Finder

The endpoint tries to find a company name inside an image and matches it against a database. The company is returned.

```
POST /api/v1/ocr/invoice/find_company
```

**Parameters**
| Name        | Description                                   | Required  |
| ------------|:---------------------------------------------:| ---------:|
| images      | an image to match for a company in png format | true      |



# Testing

The service can be tested with the following commands:

```bash
curl -F images=@cp-matcher/data/invoice_match.png -X POST http://35.198.113.228/api/v1/ocr/invoice/find_company
curl -F images=@cp-matcher/data/invoice_fuzzy_match.png -X POST http://35.198.113.228/api/v1/ocr/invoice/find_company
```

# Discussion

## Load Testing

For api load testing I would use [k6](https://k6.io/) to get a better understanding of the performace implications when using the service at scale. k6 could be run on a separate gke cluster to distribute request and mirror closer real world szenarios. If global testing is necessary gke can be setup in multiple regions. For a very simple setup it is possible to run it on any machine. Alternatively JMeter can be used.

## Monitoring

### Cloud && Container Monitoring

All major cloud providers offer monitoring for kubernetes. The functionality is very dependant on the cloud provider itself. To standardize the monitoring experience with much more control I would use in a bigger project prometheus in connection with alert manger and grafana. Starting with a default set of metrics like [kube-prometheus](https://github.com/coreos/kube-prometheus) is a good starting point and is mostely suffecient for most clusters.

### Service Monitoring

The service cp-matcher should be monitored with application metrics like Response Time, Error Rate, Time spend in DB, Time spend in tesseract service, success rate of company identification, documents with no company found, usage over time, errors, . From these metrics both the technical functionality can be evaluated as well as the use for the service to customers. 

## Security

There are some open topics to address if this service should be used in production

- setup private network for fine grained control over service communication. This will also make it possible to connect the cloud sql instance to the private network in order to hide it from the outside world and make it more secure

- setup dns and TLS endpoint encryption for example with LetsEncrypt to securley communicate with the service

- setup database backup & recovery

- setup authentication & authorization

- configure resource limit for containers
