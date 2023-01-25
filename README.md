# k0d (kubernetes tools in docker)

[![.github/workflows/deploy.yaml](https://github.com/zerok8s/k0d/actions/workflows/deploy.yaml/badge.svg)](https://github.com/zerok8s/k0d/actions/workflows/deploy.yaml)

## Available tools
- kubectl
- helm
- helmfile

## Usage
```shell
$ docker run --rm -it --net=host -v ~/.kube/config:/k0d/.kube/config zerosuxx/k0d:latest kubectl get pods
$ docker run --rm -it -v ~/.kube/config:/k0d/.kube/config zerosuxx/k0d:debug k9s
```
