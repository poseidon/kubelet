FROM docker.io/alpine:3.11 AS fetcher
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"

ARG KUBELET=v1.18.2
ARG ARCH=amd64
ARG SHA=b342dbb9fce1c2667ed255e0b7457063e7f4827a74d4c946087bb471144a552e93e17e624075273fd72b1788fc9219ae46a8d8b1c247b2f26320e932143fef1b

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
