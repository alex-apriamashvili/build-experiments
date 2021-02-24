__POET_DIR="./uber-poet"
__GEN="./genproj.py"

__PROJECT_NAME="${1}"
__NUMBER_OF_MODULES="${2:-5}"
__LOC="${3:-15000}"
__TYPE="${4:-flat}"
__OUTPUT_DIR="${5:-../${__PROJECT_NAME}}"

__generate() {
  if [[ "$(ls -A ${__OUTPUT_DIR})" ]]; then return 0; fi

  pipenv run "${__GEN}" \
    --output_directory "${__OUTPUT_DIR}" \
    --buck_module_path "/${__PROJECT_NAME}" \
    --gen_type "${__TYPE}" \
    --lines_of_code "${__LOC}" \
    --module_count "${__NUMBER_OF_MODULES}"
}

__copy_workspace() {
  cp "./WORKSPACE" "./${__PROJECT_NAME}/"
}

main() {
  cd "${__POET_DIR}"
  pipenv install
  __generate
  cd - &> /dev/null
  __copy_workspace
}

main "${@}"
