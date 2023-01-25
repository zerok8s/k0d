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

RUN adduser \
	--disabled-password \
	--gecos "" \
	app

RUN ([[ `arch` == 'x86_64' ]] && echo "amd64" || echo "arm64") > /arch

USER app

ENV PATH=${PATH}:/home/app/bin

WORKDIR /home/app

RUN mkdir ./bin

RUN curl -f -L "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/`cat /arch`/kubectl" -o ./bin/kubectl \
	&& chmod +x ./bin/kubectl

RUN curl -f "https://get.helm.sh/helm-v${HELM_VERSION}-linux-`cat /arch`.tar.gz" | tar xzf --no-same-owner - -- helm \
	&& mv helm ./bin/helm \
	&& chmod +x ./bin/helm \
	&& helm plugin install https://github.com/databus23/helm-diff

RUN curl -f -L "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_`cat /arch`.tar.gz" | tar xzf --no-same-owner - -- helmfile \
	&& mv helmfile ./bin/helmfile \
	&& chmod +x ./bin/helmfile

RUN curl -f -L "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_cat /arch" -o ./bin/yq \
	&& chmod +x ./bin/yq

RUN kubectl version --client=true --output=yaml \
	&& helm version \
	&& helmfile --version \
	&& yq --version

FROM base AS debug

ARG K9S_VERSION=0.26.7

RUN [[ `arch` == 'x86_64' ]] && normalizedArch="x86_64" || normalizedArch="arm64" \
	&& curl -f -L "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_${normalizedArch}.tar.gz" | tar xzf --no-same-owner - -- k9s \
	&& mv k9s /usr/local/bin/k9s \
	&& chmod +x /usr/local/bin/k9s

RUn k9s version

USER app