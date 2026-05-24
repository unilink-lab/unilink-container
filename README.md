# unilink-containers

Container images for building downstream C++ projects with the unilink core
library preinstalled.

The initial image is intentionally small in scope:

- one core image
- unilink installed under `/opt/unilink`
- CMake package discovery through `CMAKE_PREFIX_PATH`
- a smoke verification script that builds a minimal downstream CMake project

## Images

| Image | Purpose |
| --- | --- |
| `ghcr.io/unilink-lab/unilink-core` | C++ build environment with unilink core installed |

## Use

Run the image from a downstream project:

```bash
docker run --rm -it \
  -v "$PWD:/workspace/app" \
  -w /workspace/app \
  ghcr.io/unilink-lab/unilink-core:latest \
  bash
```

Configure a CMake consumer project inside the container:

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=/opt/unilink
cmake --build build
```

The image also sets these environment variables:

```text
UNILINK_ROOT=/opt/unilink
CMAKE_PREFIX_PATH=/opt/unilink
PKG_CONFIG_PATH=/opt/unilink/lib/pkgconfig
LD_LIBRARY_PATH=/opt/unilink/lib
```

## Build Locally

```bash
docker build \
  -f images/core/Dockerfile \
  -t unilink-core:local \
  .
```

Build a different unilink ref:

```bash
docker build \
  -f images/core/Dockerfile \
  --build-arg UNILINK_REF=v0.7.5 \
  -t unilink-core:0.7.5 \
  .
```

## Verify

The core image runs the verification script during the Docker build. You can
also run it manually:

```bash
docker run --rm unilink-core:local verify-core-image
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
