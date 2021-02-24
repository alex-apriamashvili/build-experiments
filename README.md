## Build Systems Overview (Experiment)

This repository contains experimental projects and scripts that allow benchmarking of 2 build systems available for iOS development today: [`xcodebuild`](https://developer.apple.com/library/archive/technotes/tn2339/_index.html) and [`Bazel`](https://www.bazel.build/)

### Contents
There are 2 projects in this repository:
* `./pet-app` – simulates a personal project with just `1000` lines of code and 3 modules.
* `./small-company` – simulates a project of a small company with `15k` lines of code and 11 modules.

The rest of the files in the repo are supporting. The ones that worth highlighting are:
* `./scripts` – a directory that contains automation scripts for benchmarking and mock-project generation.
* `./.logs` – a directory that contains logs and .csv-reports from the experiment runs.
* `./uber-poet` – a [mock-project generation tool](https://github.com/uber/uber-poet) developed by Uber.
* `Makefile` – a [`GNU Make`](https://www.gnu.org/software/make/) file that serves as an entry point for all scripts.

### Running experiments
Currently, there are 2 projects and 2 build systems available, thus there is a couple of options for experimentation with those projects and systems:
#### Running all experiments at once
To trigger the execution of all experiments simply use the following command:
```bash
$ make benchmark_all
```
This command will run benchmarks for the following scenarios:
* 10* sequential _incremental_ builds of the `pet-app` using `Bazel`;
* 10 sequential _incremental_ builds of the `pet-app` using `xcodebuild`;
* 10 sequential _clean_ builds of the `pet-app` using `Bazel`;
* 10 sequential _clean_ builds of the `pet-app` using `xcodebuild`;
* 10 sequential _incremental_ builds of the `small-company` using `Bazel`;
* 10 sequential _incremental_ builds of the `small-company` using `xcodebuild`;
* 10 sequential _clean_ builds of the `small-company` using `Bazel`;
* 10 sequential _clean_ builds of the `small-company` using `xcodebuild`;

\* – The number of sequential runs can be modified in the `benchmark.sh`

All the results will be saved under:  
`./.logs/<app-name>/<build-system>-<incremental|clean>.csv`  
The reports will include total running time for each individual build run, as well as the average time calculated via formula.

#### Running experiments for individual apps
To run builds and see the results for individual apps, use one of the commands below:
```bash
$ make benchmark_pet_project
```
– To run experiments against the `./pet-app`
 ```bash
 $ make benchmark_small_company_project
 ```
– To run experiments against the `./small-company` project.
The reports for the experiments will be similar to the ones received when running all build experiments

### Generating new projects
There might be a need to generate a new mock-project from scratch. To do so, please use the command below:
```bash
$ GEN_PROJECT_NAME=<your-proj-name> make generate_project
```

This command will use `uber-poet` to generate a mock project with the following parameters:
* `modules`: **11**
* `lines_of_code`: **150000**
* `type`: **flat**

If you must change any of these parameters, please do so in the `Makefile` or by providing corresponding variables as part of your `make` call.

**Please note**:
* _The original `uber-poet` has been modified in order to produce `Bazel` project_
* _There is no automation for creating an Xcode project with `xcodebuild` enabled. That action would have to be manual._
