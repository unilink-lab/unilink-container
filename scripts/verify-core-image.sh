#!/usr/bin/env bash
set -euo pipefail

unilink_root="${UNILINK_ROOT:-/opt/unilink}"
workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT

cat > "${workdir}/CMakeLists.txt" <<'EOF'
cmake_minimum_required(VERSION 3.28)

project(unilink_core_image_smoke LANGUAGES CXX)

find_package(unilink CONFIG REQUIRED)

add_executable(smoke main.cpp)
target_link_libraries(smoke PRIVATE unilink::unilink)
target_compile_features(smoke PRIVATE cxx_std_20)
EOF

cat > "${workdir}/main.cpp" <<'EOF'
#include <unilink/unilink.hpp>

int main() {
  return 0;
}
EOF

cmake -S "${workdir}" -B "${workdir}/build" -G Ninja \
  -DCMAKE_PREFIX_PATH="${unilink_root}"
cmake --build "${workdir}/build" --parallel
"${workdir}/build/smoke"
