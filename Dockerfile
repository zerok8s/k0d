FROM alpine

ARG HELMFILE_VERSION=0.150.0

RUN apk add --no-cache \
	curl \
	bash \
	openssl \
	git \
    && rm -rf /tmp/* /var/cache/apk/*

RUN if [ `arch` == 'x86_64' ]; then echo "amd64" > /arch; else echo "arm64" > /arch; fi

RUN curl -f -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/`cat /arch`/kubectl" -o /usr/local/bin/kubectl \
	&& chmod +x /usr/local/bin/kubectl

RUN curl -f https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN curl -f -L "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_`cat /arch`.tar.gz" | tar xzf - -- helmfile \
	&& mv helmfile /usr/local/bin/helmfile \
	&& chmod +x /usr/local/bin/helmfile \
	&& rm -rf /tmp/*

RUN kubectl version --client=true --output=yaml \
	&& helm version \
	&& helmfile --version

RUN adduser \
	--disabled-password \
	--gecos "" \
	app

USER app