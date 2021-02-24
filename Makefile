PET_PROJ_NAME		:= pet-app
SMALL_PROJ_NAME	:= small-company

# PROJECT GENERATION
GEN_PROJECT_NAME 			?= small-company
GEN_NUMBER_OF_MODULES ?= 11
GEN_LOC								?= 150000
GEN_TYPE							?= flat
GEN_OUTPUT_DIR				?= ../$(GEN_PROJECT_NAME)

## BENCHMARKING

benchmark_all: benchmark_pet_project benchmark_small_company_project

benchmark_pet_project:
	@echo "measuring performance in the ${PET_PROJ_NAME}"
	sh scripts/benchmark.sh $(PET_PROJ_NAME)
	sh scripts/benchmark.sh $(PET_PROJ_NAME) clean

benchmark_small_company_project:
	@echo "measuring performance in the ${SMALL_PROJ_NAME}"
	sh scripts/benchmark.sh $(SMALL_PROJ_NAME)
	sh scripts/benchmark.sh $(SMALL_PROJ_NAME) clean

## BAZEL PROJECT GENERATION

generate_project:
	@echo "generating project with name ${GEN_PROJECT_NAME}"
	sh scripts/generate_project.sh $(GEN_PROJECT_NAME) \
		$(GEN_NUMBER_OF_MODULES) \
		$(GEN_LOC) \
		$(GEN_TYPE) \
		$(GEN_OUTPUT_DIR)
