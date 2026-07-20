ARG UBUNTU_VERSION=24.04
FROM ubuntu:${UBUNTU_VERSION}

ARG DEBIAN_FRONTEND=noninteractive
ARG WIRESTEAD_REPOSITORY=https://github.com/wirestead/wirestead.git
ARG WIRESTEAD_REF=v0.9.0
ARG WIRESTEAD_PREFIX=/opt/wirestead

LABEL org.opencontainers.image.title="wirestead-core"
LABEL org.opencontainers.image.description="C++ build environment with Wirestead core installed"
LABEL org.opencontainers.image.source="https://github.com/wirestead/wirestead-container"
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

RUN git clone --depth 1 --branch "${WIRESTEAD_REF}" "${WIRESTEAD_REPOSITORY}" /tmp/wirestead-src \
  || ( \
    git clone "${WIRESTEAD_REPOSITORY}" /tmp/wirestead-src \
    && git -C /tmp/wirestead-src fetch --depth 1 origin "${WIRESTEAD_REF}" \
    && git -C /tmp/wirestead-src checkout FETCH_HEAD \
  )

RUN cmake -S /tmp/wirestead-src -B /tmp/wirestead-build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${WIRESTEAD_PREFIX}" \
    -DWIRESTEAD_BUILD_EXAMPLES=OFF \
    -DWIRESTEAD_BUILD_TESTS=OFF \
    -DWIRESTEAD_BUILD_DOCS=OFF \
    -DWIRESTEAD_ENABLE_INSTALL=ON \
    -DWIRESTEAD_ENABLE_PKGCONFIG=ON \
    -DWIRESTEAD_ENABLE_EXPORT_HEADER=ON \
    -DBUILD_PYTHON_BINDINGS=OFF \
  && cmake --build /tmp/wirestead-build --parallel \
  && cmake --install /tmp/wirestead-build \
  && rm -rf /tmp/wirestead-src /tmp/wirestead-build

ENV WIRESTEAD_ROOT="${WIRESTEAD_PREFIX}"
ENV CMAKE_PREFIX_PATH="${WIRESTEAD_PREFIX}"
ENV PKG_CONFIG_PATH="${WIRESTEAD_PREFIX}/lib/pkgconfig"
ENV LD_LIBRARY_PATH="${WIRESTEAD_PREFIX}/lib"

RUN echo "${WIRESTEAD_PREFIX}/lib" > /etc/ld.so.conf.d/wirestead.conf && ldconfig

COPY scripts/verify-core-image.sh /usr/local/bin/verify-core-image
RUN chmod +x /usr/local/bin/verify-core-image && verify-core-image

WORKDIR /workspace
CMD ["bash"]
