S_PROJ_NAME := pet-app
M_PROJ_NAME := company-app

# PROJECT GENERATION
GEN_PROJECT_NAME 			?= medium-app
GEN_NUMBER_OF_MODULES ?= 12
GEN_NUMBER_OF_LAYERS 	?= 4
GEN_LOC								?= 150000
GEN_TYPE							?= layered
GEN_OUTPUT_DIR				?= ../$(GEN_PROJECT_NAME)

## BENCHMARKING

benchmark_all: benchmark_pet_project benchmark_company_project

benchmark_pet_project:
	@echo "measuring performance in the ${S_PROJ_NAME}"
	sh scripts/benchmark.sh $(S_PROJ_NAME)
	sh scripts/benchmark.sh $(S_PROJ_NAME) clean

benchmark_company_project:
	@echo "measuring performance in the ${M_PROJ_NAME}"
	sh scripts/benchmark.sh $(M_PROJ_NAME) incremental layered
	sh scripts/benchmark.sh $(M_PROJ_NAME) clean layered

## BAZEL PROJECT GENERATION

generate_project:
	@echo "generating project with name ${GEN_PROJECT_NAME}"
	sh scripts/generate_project.sh $(GEN_PROJECT_NAME) \
		$(GEN_NUMBER_OF_MODULES) \
		$(GEN_LOC) \
		$(GEN_TYPE) \
		$(GEN_NUMBER_OF_LAYERS) \
		$(GEN_OUTPUT_DIR)
