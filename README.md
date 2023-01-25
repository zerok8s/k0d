# k0d (kubernetes tools in docker)

## Available tools
- kubectl
- helm
- helmfile

## Usage
```shell
$ docker run --rm -it --net=host -v ~/.kube/config:/k0d/.kube/config zerosuxx/k0d:latest kubectl get pods
$ docker run --rm -it -v ~/.kube/config:/k0d/.kube/config zerosuxx/k0d:debug k9s
```
