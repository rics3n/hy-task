# Goal

- Setup a simple Kubernetes cluster (public cloud or use minikube or k3s).
- Implement and deploy web application that exposes a single API endpoint for matching vendor code encoded in uploaded image.
- In a Github repository provide application code, k8s manifest files, scripts, and documentation.

## Tasks

1. Provision a Kubernetes cluster

2. Implement and dockerize basic application, which:

	a. exposes a single RESTful service endpoint for image upload. We assume that this image is a scanned invoice, which somewhere in its text contains exactly one vendor code string matching VND-\w{4,20} pattern, for example VND-GOOGLE or VND-MICROSOFT.

	b. this endpoint implements vendor id matching, by:

		- performing OCR operation on uploaded image, using an existing web service that is deployed within the Kubernetes cluster. Example service that you could use:
        https://hub.docker.com/r/mauvilsa/tesseract-recognize

		- searching for vendor code in the OCR result, matching it against vendor database and finally returning vendor ID.

3. Deploy database service suitable for vendor matching, that contains following example records (please include more if needed):

```csv
company,ID
GOOGLE,123
MICROSOFT,124
TESLA,125
NOKIA,126
APPLE,127
SAMSUNG,128
```

Database should support fuzzy search matching, so in case of badly OCR-ed company name, matching still should perform well. For example, both for VND-MICROSOFT and VND-M1RCOFOST we should get `124`  as a result (remove VND- prefix to get vendor company name).

Use an existing database service that can be easily deployed on Kuberenetes and supports fuzzy full text search, for example: SOLR, Elasticsearch, PostgreSQL.

Beside application code please include Dockerfile and Kubernetes manifests needed for deployment. For implementation purposes we prefer Python, but feel free to use programming language and web framework of your choice.

## Expected

1. Provide a step-by-step instruction in README.md on what you did to:
   - setup the cluster 
   - deploy the application, OCR service and database
   - preload the search database with example data

2. Describe application API and how to test the application (curl commands preferably).

3. Write a bash script that sets up everything. If you use minikube, the script should start it and wait for it to be ready. If you use a public cloud, you might include a draft of Terraform or native script.

4. Include in your documentation, a brief discussion section:
   a. How would you load test the application? Which tools would you use?
   b. How would you monitor the application? What metrics would you implement? Which tools would you use?
