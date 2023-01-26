# k0d (kubernetes tools in docker)

[![.github/workflows/deploy.yaml](https://github.com/zerok8s/k0d/actions/workflows/deploy.yaml/badge.svg)](https://github.com/zerok8s/k0d/actions/workflows/deploy.yaml)
[![Docker Image Download](https://img.shields.io/docker/pulls/zerosuxx/k0d)](https://hub.docker.com/r/zerosuxx/k0d)
[![Docker Image Size](https://img.shields.io/docker/image-size/zerosuxx/k0d?label=amd64%20image%20size)](https://hub.docker.com/r/zerosuxx/k0d)
[![Docker Image Size with architecture](https://img.shields.io/docker/image-size/zerosuxx/k0d?arch=arm64&label=arm64%20image%20size)](https://hub.docker.com/r/zerosuxx/k0d)


## Available tools
- kubectl
- helm
- helmfile

## Usage
```shell
$ docker run --rm -it --net=host -v ~/.kube/config:/k0d/.kube/config zerosuxx/k0d:latest kubectl get pods
$ docker run --rm -it -v ~/.kube/config:/k0d/.kube/config zerosuxx/k0d:debug k9s
```
