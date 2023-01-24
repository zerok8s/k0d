FROM alpine AS base

ARG HELMFILE_VERSION=0.150.0

RUN apk add --no-cache \
	curl \
	bash \
	openssl \
	git \
	nano \
    && rm -rf /tmp/* /var/cache/apk/*

RUN if [ `arch` == 'x86_64' ]; then echo "amd64" > /arch; else echo "arm64" > /arch; fi

RUN curl -f -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/`cat /arch`/kubectl" -o /usr/local/bin/kubectl \
	&& chmod +x /usr/local/bin/kubectl

RUN curl -f "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3" | bash

RUN curl -f -L "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_`cat /arch`.tar.gz" | tar xzf - -- helmfile \
	&& mv helmfile /usr/local/bin/helmfile \
	&& chmod +x /usr/local/bin/helmfile

RUN kubectl version --client=true --output=yaml \
	&& helm version \
	&& helmfile --version

RUN adduser \
	--disabled-password \
	--gecos "" \
	app

USER app


FROM base AS debug

ARG K9S_VERSION=0.26.7

RUN [[ `arch` == 'x86_64' ]] && normalizedArch="x86_64" || normalizedArch="arm64" \
	&& curl -f -L "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_${normalizedArch}.tar.gz" | tar xzf - -- k9s \
	&& mv k9s /usr/local/bin/k9s \
	&& chmod +x /usr/local/bin/k9s