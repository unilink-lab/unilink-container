# unilink-core Image

`unilink-core` provides a C++ build environment with the unilink core library
installed under `/opt/unilink`.

It is intended for downstream projects that want to build against unilink
without installing the C++ dependency stack on the host machine.

## Build Arguments

| Argument | Default | Description |
| --- | --- | --- |
| `UBUNTU_VERSION` | `24.04` | Ubuntu base image version |
| `UNILINK_REPOSITORY` | `https://github.com/jwsung91/unilink.git` | Source repository used to build unilink |
| `UNILINK_REF` | `v0.7.2` | unilink tag, branch, or commit to install |
| `UNILINK_PREFIX` | `/opt/unilink` | Install prefix inside the image |

## Local Build

```bash
docker build -f images/core/Dockerfile -t unilink-core:local .
```

Build a specific unilink release:

```bash
docker build \
  -f images/core/Dockerfile \
  --build-arg UNILINK_REF=v0.7.2 \
  -t unilink-core:0.7.2 \
  .
```

## Verify

The image includes `verify-core-image`, which builds and runs a minimal CMake
consumer project using `find_package(unilink CONFIG REQUIRED)`.

```bash
docker run --rm unilink-core:local verify-core-image
```
