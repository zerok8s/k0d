FROM alpine AS base

ARG KUBECTL_VERSION=1.26.1
ARG HELM_VERSION=3.11.0
ARG HELMFILE_VERSION=0.150.0

RUN apk add --no-cache \
	curl \
	bash \
	openssl \
	git \
	nano \
	jq \
	dumb-init \
    && rm -rf /tmp/* /var/cache/apk/*

ARG HOME="/k0d"
ENV HOME="${HOME}"
ARG HELM_CACHE_HOME="${HOME}/.cache/helm"
ENV HELM_CACHE_HOME="${HELM_CACHE_HOME}"
ARG HELM_CONFIG_HOME="${HOME}/.config/helm"
ENV HELM_CONFIG_HOME="${HELM_CONFIG_HOME}"
ARG HELM_DATA_HOME="${HOME}/.local/share/helm"
ENV HELM_DATA_HOME="${HELM_DATA_HOME}"

RUN ([[ `arch` == 'x86_64' ]] && echo "amd64" || echo "arm64") > /arch

RUN curl -f -L "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/`cat /arch`/kubectl" -o /usr/local/bin/kubectl \
	&& chmod +x /usr/local/bin/kubectl

RUN curl -f "https://get.helm.sh/helm-v${HELM_VERSION}-linux-`cat /arch`.tar.gz" | tar xzfO - -- "linux-`cat /arch`/helm" > /usr/local/bin/helm \
	&& chmod +x /usr/local/bin/helm \
	&& helm plugin install https://github.com/databus23/helm-diff

RUN curl -f -L "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_`cat /arch`.tar.gz" | tar xzfO - -- helmfile > /usr/local/bin/helmfile \
	&& chmod +x /usr/local/bin/helmfile

RUN curl -f -L "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_`cat /arch`" -o /usr/local/bin/yq \
	&& chmod +x /usr/local/bin/yq

RUN chmod 751 ${HOME}

RUN kubectl version --client=true --output=yaml \
	&& helm version \
	&& helmfile --version \
	&& yq --version


FROM base AS debug

ARG K9S_VERSION=0.26.7

RUN [[ `arch` == 'x86_64' ]] && normalizedArch="x86_64" || normalizedArch="arm64" \
	&& curl -f -L "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_${normalizedArch}.tar.gz" | tar xzfO - -- k9s > /usr/local/bin/k9s \
	&& chmod +x /usr/local/bin/k9s

RUN k9s version
