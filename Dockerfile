FROM bitnami/pytorch:latest AS torch-cpu
ENV DEBIAN_FRONTEND=noninteractive
ENV POETRY_HOME="/opt/poetry"
ENV POETRY_VIRTUALENVS_CREATE=false
ENV PATH="$POETRY_HOME/bin:$PATH"
ENV PIP_EXTRA_INDEX_URL='https://download.pytorch.org/whl/cpu'

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install base python tools
RUN pip3 install --upgrade \
  pip \
  setuptools \
  wheel \
  poetry

# Install Base PyTorch System - Assume CPU
RUN pip3 install \
  torch \
  torchvision \
  torchaudio \
  torchdatasets \
  torchtext \
  datasets \
  transformers

FROM torch-cpu AS base-image

USER root

RUN mkdir -p /.cache/
RUN chown -R 1001:1001 /.cache/

RUN mkdir -p /code/models
RUN chown -R 1001:1001 /code/models

RUN apt-get update && apt-get install -y gcc

COPY dependencies/requirements-clean.txt ./requirements.txt
RUN pip install -r requirements.txt

WORKDIR /code

COPY ./app /code/app

USER 1001
