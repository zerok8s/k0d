FROM zerosuxx/alpine AS base

ARG KUBECTL_VERSION=1.27.1
ARG HOME="/k0d"
ENV HOME="${HOME}"

WORKDIR ${HOME}

RUN chmod 751 ${HOME}

RUN curl -f -L "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/`cat /arch`/kubectl" -o /usr/local/bin/kubectl \
	&& chmod +x /usr/local/bin/kubectl

RUN curl -f -L "https://scripts.zer0.hu/ci_deploy/generate-gitlab-ci-yml" -o /usr/local/bin/generate-gitlab-ci-yml \
	&& chmod +x /usr/local/bin/generate-gitlab-ci-yml 

RUN curl -f -L "https://scripts.zer0.hu/ci_deploy/generate-k8s-manifests" -o /usr/local/bin/generate-k8s-manifests \
	&& chmod +x /usr/local/bin/generate-k8s-manifests

RUN curl -f -L "https://scripts.zer0.hu/ci_deploy/git" -o /usr/local/bin/ci-git \
	&& chmod +x /usr/local/bin/ci-git

COPY --chmod=0755 ./bin/* /usr/local/bin/

RUN kubectl version --client=true --output=yaml \
	&& yq --version \
	&& k0d version


FROM base AS full

ARG HELM_VERSION=3.11.3
ARG HELMFILE_VERSION=0.153.1

ARG HELM_CACHE_HOME="${HOME}/.cache/helm"
ENV HELM_CACHE_HOME="${HELM_CACHE_HOME}"
ARG HELM_CONFIG_HOME="${HOME}/.config/helm"
ENV HELM_CONFIG_HOME="${HELM_CONFIG_HOME}"
ARG HELM_DATA_HOME="${HOME}/.local/share/helm"
ENV HELM_DATA_HOME="${HELM_DATA_HOME}"

RUN curl -f "https://get.helm.sh/helm-v${HELM_VERSION}-linux-`cat /arch`.tar.gz" | tar xzfO - -- "linux-`cat /arch`/helm" > /usr/local/bin/helm \
	&& chmod +x /usr/local/bin/helm \
	&& helm plugin install https://github.com/databus23/helm-diff \
    && helm plugin install https://github.com/aslafy-z/helm-git.git

RUN curl -f -L "https://github.com/helmfile/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_${HELMFILE_VERSION}_linux_`cat /arch`.tar.gz" | tar xzfO - -- helmfile > /usr/local/bin/helmfile \
	&& chmod +x /usr/local/bin/helmfile

RUN helm version \
	&& helmfile --version


FROM full AS debug

ARG K9S_VERSION=0.27.2

RUN curl -f -L "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_`cat /arch`.tar.gz" | tar xzfO - -- k9s > /usr/local/bin/k9s \
	&& chmod +x /usr/local/bin/k9s

RUN k9s version
