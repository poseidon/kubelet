FROM alpine:3.11 AS fetcher
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"

ARG KUBELET=v1.18.0-rc.1
ARG ARCH=amd64
ARG SHA=27d8955d535d14f3f4dca501fd27e4f06fad84c6da878ea5332a5c83b6955667f6f731bfacaf5a3a23c09f14caa400f9bee927a0f269f5374de7f79cd1919b3b

RUN apk add curl && \
  curl -L https://dl.k8s.io/${KUBELET}/kubernetes-node-linux-${ARCH}.tar.gz -o node.tar.gz && \
  echo "${SHA}  node.tar.gz" | sha512sum -c && \
  tar xzf node.tar.gz kubernetes/node/bin/kubectl kubernetes/node/bin/kubelet


FROM k8s.gcr.io/debian-iptables:v12.0.1
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"

RUN clean-install \
  bash \
  ca-certificates \
  ceph-common \
  cifs-utils \
  e2fsprogs \
  xfsprogs \
  ethtool \
  git \
  glusterfs-client \
  iproute2 \
  jq \
  openssh-client \
  nfs-common \
  socat \
  udev \
  util-linux

COPY --from=fetcher /kubernetes/node/bin/kubelet /usr/local/bin/kubelet
COPY --from=fetcher /kubernetes/node/bin/kubectl /usr/local/bin/kubectl
ENTRYPOINT ["/usr/local/bin/kubelet"]
