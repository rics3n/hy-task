# Based on https://github.com/kbst/terraform-kubestack/blob/master/quickstart/src/ci-cd/Dockerfile
#
# Build
FROM python:2.7-slim AS builder

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gcc \
    unzip \
    python-virtualenv \
    libffi-dev

RUN mkdir -p /opt/bin

# Default versions
ARG KUBECTL_VERSION=v1.15.11
ARG TERRAFORM_VERSION=0.12.19
ARG GOOGLE_CLOUD_SDK_VERSION=272.0.0

# Common dependencies
RUN echo "KUBECTL_VERSION: ${KUBECTL_VERSION}" \
    && curl -Lo /opt/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x /opt/bin/kubectl \
    && /opt/bin/kubectl version --client=true

RUN echo "TERRAFORM_VERSION: ${TERRAFORM_VERSION}" \
    && curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /opt/bin \
    && chmod +x /opt/bin/terraform \
    && /opt/bin/terraform version

# Google specific dependencies
RUN echo "GOOGLE_CLOUD_SDK_VERSION: ${GOOGLE_CLOUD_SDK_VERSION}" \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz \
    && tar zxvf google-cloud-sdk-${GOOGLE_CLOUD_SDK_VERSION}-linux-x86_64.tar.gz google-cloud-sdk \
    && mv google-cloud-sdk /opt/google-cloud-sdk \
    && /opt/google-cloud-sdk/bin/gcloud --version

COPY nss-wrapper /opt/bin/nss-wrapper

#
#
# Final
FROM python:2.7-slim

RUN apt-get update && apt-get install -y \
      ca-certificates \
      git \
      jq \
      wget \
      openssh-client \
      dnsutils \
      libnss-wrapper \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt /opt
ENV PATH=/opt/bin:/opt/google-cloud-sdk/bin:$PATH \
    HOME=/infra/.user

WORKDIR /infra

ENTRYPOINT ["/opt/bin/nss-wrapper"]
CMD bash
