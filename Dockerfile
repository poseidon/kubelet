FROM docker.io/alpine:3.13 AS fetcher
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"

ARG KUBELET=v1.17.9
ARG ARCH=amd64
ARG SHA=a8baebd0725d69cde59e5eaad5fbcd9b35911b67539df0d28407f96b8baafc854e7e043af7139c9fc4126bae7bebfe6ca7dfb80180c56399819593d31b96a6d5

RUN apk add curl && \
  curl -L https://dl.k8s.io/${KUBELET}/kubernetes-node-linux-${ARCH}.tar.gz -o node.tar.gz && \
  echo "${SHA}  node.tar.gz" | sha512sum -c && \
  tar xzf node.tar.gz kubernetes/node/bin/kubectl kubernetes/node/bin/kubelet


FROM us.gcr.io/k8s-artifacts-prod/build-image/debian-iptables:buster-v1.6.0
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
