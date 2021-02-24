__START=0
__STOP=0

__APP_PATH="${1}"
__TYPE="${2:-incremental}"

__NUMBER_OF_ITERATIONS=10
__HEADER="#;time"
__FOOTER="avg;=SUM(B2:B$(( 1 + ${__NUMBER_OF_ITERATIONS} )))/${__NUMBER_OF_ITERATIONS}"
__XCODEBUILD_REPORT="xcodebuild-${__TYPE}.csv"
__BAZEL_REPORT="bazel-${__TYPE}.csv"

__bazel() {
  local trial="${1}"
  __START=$SECONDS
  if [[ "${__TYPE}" == "clean" ]]; then
    bazel clean &> /dev/null
  fi
  bazel build //App:App &> /dev/null
  __STOP=$SECONDS
  local elapsed=$(( ${__STOP} - ${__START} ))
  echo "#${trial};${elapsed}"
}

__bench_bazel() {
  cd "${__APP_PATH}"
  echo "${__HEADER}" > "${__BAZEL_REPORT}"
  for (( i=1; i<=$__NUMBER_OF_ITERATIONS; i++ )); do
    __bazel "${i}" >> "${__BAZEL_REPORT}"
  done
  echo "${__FOOTER}" >> "${__BAZEL_REPORT}"
  cd - &> /dev/null
  mv "${__APP_PATH}/${__BAZEL_REPORT}" "${report_path}/${__BAZEL_REPORT}"
}

__xcodebuild() {
  local trial="${1}"
  local clean_build=""
  if [[ "${__TYPE}" == "clean" ]]; then
    local clean_build="clean"
  fi

  __START=$SECONDS
  xcodebuild ${clean_build} build \
    -scheme "App" \
    -sdk iphonesimulator \
    -project "App.xcodeproj" &> /dev/null
  __STOP=$SECONDS
  local elapsed=$(( ${__STOP} - ${__START} ))
  echo "#${trial};${elapsed}"
}

__bench_xcodebuild() {
  cd "${__APP_PATH}"
  echo "${__HEADER}" > "${__XCODEBUILD_REPORT}"
  for (( i=1; i<=$__NUMBER_OF_ITERATIONS; i++ )); do
    __xcodebuild "${i}" >> "${__XCODEBUILD_REPORT}"
  done
 echo "${__FOOTER}" >> "${__XCODEBUILD_REPORT}"
  cd - &> /dev/null
  mv "${__APP_PATH}/${__XCODEBUILD_REPORT}" "${report_path}/${__XCODEBUILD_REPORT}"
}

main() {
  local report_path="./.logs/${__APP_PATH}"
  mkdir -p "${report_path}"
  __bench_bazel
  __bench_xcodebuild
}

main "${@}"
