#!/bin/bash

set -euxo pipefail

if [[ "${target_platform}" != "${build_platform}" ]]; then
  # Remove duplicate headers
  rm -r ${BUILD_PREFIX}/venv/lib/python${PY_VER}/site-packages/torch/include
fi

if [[ "$cuda_compiler_version" == "None" ]]; then
  export FORCE_CUDA=0
else
  if [[ ${cuda_compiler_version} == 11.2* ]]; then
      export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX"
  elif [[ ${cuda_compiler_version} == 11.8 ]]; then
      export TORCH_CUDA_ARCH_LIST="3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9+PTX"
      export CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME
  elif [[ ${cuda_compiler_version} == 12* ]]; then
      export TORCH_CUDA_ARCH_LIST="5.0;6.0;6.1;7.0;7.5;8.0;8.6;8.9;9.0+PTX"
      # $CUDA_HOME not set in CUDA 12.0. Using $PREFIX
      export CUDA_TOOLKIT_ROOT_DIR="${PREFIX}"
  else
      echo "unsupported cuda version. edit build.sh"
      exit 1
  fi
  export FORCE_CUDA=1
fi

${PYTHON} -m pip install . -vv
