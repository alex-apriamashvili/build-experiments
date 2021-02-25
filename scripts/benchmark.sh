# -- INPUT --

__APP_PATH="${1}"
__TYPE="${2:-incremental}"
__STRUCT="${3:-flat}"

# -- CONFIG --

__NUMBER_OF_ITERATIONS=10
__HEADER="#;time"
__FOOTER="avg;=SUM(B2:B$(( 1 + ${__NUMBER_OF_ITERATIONS} )))/${__NUMBER_OF_ITERATIONS}"
__XCODEBUILD_REPORT="xcodebuild-${__TYPE}.csv"
__BAZEL_REPORT="bazel-${__TYPE}.csv"

# -- INTERNAL VARIABLES --
__START=0
__STOP=0
__MOCK_MODULE_NAME="MockLib2"
__SOURCES_FILE_PATH="Sources/File1.swift"
__ORIGINAL_NEEDLE="x = 7"
__NEEDLE="${__ORIGINAL_NEEDLE}"
__REPLACEMENT_OPTIONS=(
"x = 3"
"x = 5"
"x = 24"
"x = 42"
"x = 21"
)

__get_source_file_path() {
  local level_suffix=""
  if [[ "layered" == "${__STRUCT}" ]]; then local level_suffix="_1"; fi

  echo "${__MOCK_MODULE_NAME}${level_suffix}/${__SOURCES_FILE_PATH}"
}

__modify_sources() {
  if [[ "${__TYPE}" == "clean" ]]; then return 0; fi

  local iteration="${1}"
  local index=$(( $iteration % 5 ))
  local file=$(__get_source_file_path)
  local phrase="${__REPLACEMENT_OPTIONS[$index]}"

  sed -i '' "s|$__NEEDLE|$phrase|g" "${file}"

  __NEEDLE=$phrase
}

__revert_changes() {
  if [[ "${__TYPE}" == "clean" ]]; then return 0; fi

  local file=$(__get_source_file_path)

  sed -i '' "s|$__NEEDLE|$__ORIGINAL_NEEDLE|g" "${file}"

  __NEEDLE=$__ORIGINAL_NEEDLE
}

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
    __modify_sources ${i}
  done
  __revert_changes
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
    __modify_sources ${i}
  done
  __revert_changes
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
