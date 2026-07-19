# wirestead-core Image

`wirestead-core` provides a C++ build environment with the Wirestead core
library installed under `/opt/wirestead`.

It is intended for downstream projects that want to build against Wirestead
without installing the C++ dependency stack on the host machine.

## Build Arguments

| Argument | Default | Description |
| --- | --- | --- |
| `UBUNTU_VERSION` | `24.04` | Ubuntu base image version |
| `WIRESTEAD_REPOSITORY` | `https://github.com/wirestead/wirestead.git` | Source repository used to build Wirestead |
| `WIRESTEAD_REF` | `v0.9.0` | Wirestead tag, branch, or commit to install |
| `WIRESTEAD_PREFIX` | `/opt/wirestead` | Install prefix inside the image |

## Local Build

```bash
docker build -f images/core/Dockerfile -t wirestead-core:local .
```

Build a specific Wirestead release:

```bash
docker build \
  -f images/core/Dockerfile \
  --build-arg WIRESTEAD_REF=v0.9.0 \
  -t wirestead-core:0.9.0 \
  .
```

## Verify

The image includes `verify-core-image`, which builds and runs a minimal CMake
consumer project using `find_package(wirestead CONFIG REQUIRED)`.

```bash
docker run --rm wirestead-core:local verify-core-image
```
