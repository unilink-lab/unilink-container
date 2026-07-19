#!/usr/bin/env bash
set -euo pipefail

wirestead_root="${WIRESTEAD_ROOT:-/opt/wirestead}"
workdir="$(mktemp -d)"
trap 'rm -rf "${workdir}"' EXIT

cat > "${workdir}/CMakeLists.txt" <<'EOF'
cmake_minimum_required(VERSION 3.28)

project(wirestead_core_image_smoke LANGUAGES CXX)

find_package(wirestead CONFIG REQUIRED)

add_executable(smoke main.cpp)
target_link_libraries(smoke PRIVATE wirestead::wirestead)
target_compile_features(smoke PRIVATE cxx_std_20)
EOF

cat > "${workdir}/main.cpp" <<'EOF'
#include <wirestead/wirestead.hpp>

int main() {
  return 0;
}
EOF

cmake -S "${workdir}" -B "${workdir}/build" -G Ninja \
  -DCMAKE_PREFIX_PATH="${wirestead_root}"
cmake --build "${workdir}/build" --parallel
"${workdir}/build/smoke"
