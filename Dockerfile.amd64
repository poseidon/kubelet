FROM docker.io/alpine:3.11 AS fetcher
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"

ARG KUBELET=v1.18.3
ARG ARCH=amd64
ARG SHA=1027a6fccadd320f123894dc624db31539333deef0b3d51b4bd3efc9214f2d74a0a50c53dc28e5801426d3c9556f82f4e06042c824151fea9112df795976d158

RUN apk add curl && \
  curl -L https://dl.k8s.io/${KUBELET}/kubernetes-node-linux-${ARCH}.tar.gz -o node.tar.gz && \
  echo "${SHA}  node.tar.gz" | sha512sum -c && \
  tar xzf node.tar.gz kubernetes/node/bin/kubectl kubernetes/node/bin/kubelet


FROM us.gcr.io/k8s-artifacts-prod/build-image/debian-iptables:v12.1.0
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"

RUN clean-install \
  bash \
  ca-certificates \
  ceph-common \
  cifs-utils \
  e2fsprogs \
  xfsprogs \
  ethtool \
  glusterfs-client \
  iproute2 \
  jq \
  nfs-common \
  socat \
  udev \
  util-linux

COPY --from=fetcher /kubernetes/node/bin/kubelet /usr/local/bin/kubelet
COPY --from=fetcher /kubernetes/node/bin/kubectl /usr/local/bin/kubectl
ENTRYPOINT ["/usr/local/bin/kubelet"]
