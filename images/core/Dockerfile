ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}

ARG DEBIAN_FRONTEND=noninteractive
ARG UNILINK_REPOSITORY=https://github.com/jwsung91/unilink.git
ARG UNILINK_REF=v0.7.2
ARG UNILINK_PREFIX=/opt/unilink

LABEL org.opencontainers.image.title="unilink-core"
LABEL org.opencontainers.image.description="C++ build environment with unilink core installed"
LABEL org.opencontainers.image.source="https://github.com/unilink-lab/unilink-containers"
LABEL org.opencontainers.image.licenses="Apache-2.0"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    libboost-dev \
    libboost-system-dev \
    libspdlog-dev \
    ninja-build \
    pkg-config \
    python3 \
    python3-pip \
    tar \
    unzip \
    zip \
  && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "${UNILINK_REF}" "${UNILINK_REPOSITORY}" /tmp/unilink-src \
  || ( \
    git clone "${UNILINK_REPOSITORY}" /tmp/unilink-src \
    && git -C /tmp/unilink-src fetch --depth 1 origin "${UNILINK_REF}" \
    && git -C /tmp/unilink-src checkout FETCH_HEAD \
  )

RUN cmake -S /tmp/unilink-src -B /tmp/unilink-build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${UNILINK_PREFIX}" \
    -DUNILINK_BUILD_EXAMPLES=OFF \
    -DUNILINK_BUILD_TESTS=OFF \
    -DUNILINK_BUILD_DOCS=OFF \
    -DUNILINK_ENABLE_INSTALL=ON \
    -DUNILINK_ENABLE_PKGCONFIG=ON \
    -DUNILINK_ENABLE_EXPORT_HEADER=ON \
    -DBUILD_PYTHON_BINDINGS=OFF \
  && cmake --build /tmp/unilink-build --parallel \
  && cmake --install /tmp/unilink-build \
  && rm -rf /tmp/unilink-src /tmp/unilink-build

ENV UNILINK_ROOT="${UNILINK_PREFIX}"
ENV CMAKE_PREFIX_PATH="${UNILINK_PREFIX}"
ENV PKG_CONFIG_PATH="${UNILINK_PREFIX}/lib/pkgconfig"
ENV LD_LIBRARY_PATH="${UNILINK_PREFIX}/lib"

RUN echo "${UNILINK_PREFIX}/lib" > /etc/ld.so.conf.d/unilink.conf && ldconfig

COPY scripts/verify-core-image.sh /usr/local/bin/verify-core-image
RUN chmod +x /usr/local/bin/verify-core-image && verify-core-image

WORKDIR /workspace
CMD ["bash"]
