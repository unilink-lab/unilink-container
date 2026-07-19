# wirestead-containers

Container images for building downstream C++ projects with the Wirestead core
library preinstalled.

The initial image is intentionally small in scope:

- one core image
- Wirestead installed under `/opt/wirestead`
- CMake package discovery through `CMAKE_PREFIX_PATH`
- a smoke verification script that builds a minimal downstream CMake project

## Images

| Image | Purpose |
| --- | --- |
| `ghcr.io/wirestead/wirestead-core` | C++ build environment with Wirestead core installed |

## Use

Run the image from a downstream project:

```bash
docker run --rm -it \
  -v "$PWD:/workspace/app" \
  -w /workspace/app \
  ghcr.io/wirestead/wirestead-core:latest \
  bash
```

Configure a CMake consumer project inside the container:

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=/opt/wirestead
cmake --build build
```

The image also sets these environment variables:

```text
WIRESTEAD_ROOT=/opt/wirestead
CMAKE_PREFIX_PATH=/opt/wirestead
PKG_CONFIG_PATH=/opt/wirestead/lib/pkgconfig
LD_LIBRARY_PATH=/opt/wirestead/lib
```

## Build Locally

```bash
docker build \
  -f images/core/Dockerfile \
  -t wirestead-core:local \
  .
```

Build a different Wirestead ref:

```bash
docker build \
  -f images/core/Dockerfile \
  --build-arg WIRESTEAD_REF=v0.9.0 \
  -t wirestead-core:0.9.0 \
  .
```

## Verify

The core image runs the verification script during the Docker build. You can
also run it manually:

```bash
docker run --rm wirestead-core:local verify-core-image
```

## Repository Layout

```text
.
├── images/
│   └── core/
│       ├── Dockerfile
│       └── README.md
├── scripts/
│   └── verify-core-image.sh
└── README.md
```
