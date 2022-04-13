#!/usr/bin/env bats

# global variables ############################################################
IMAGE="debug"
CST_VERSION="latest" # version of GoogleContainerTools/container-structure-test
HADOLINT_VERSION="v1.17.6-9-g550ee0d-alpine"

# build container to test the behavior ########################################
@test "build container" {
  docker build -t $IMAGE -f src/Dockerfile . >&2
}

# functions ###################################################################
function setup() {
  unset var
}

function debug() {
  status="$1"
  output="$2"
  if [[ ! "${status}" -eq "0" ]]; then
  echo "status: ${status}"
  echo "output: ${output}"
  fi
}

# variables ###################################################################
DATA="$(pwd)/test/data:/mnt/"

###############################################################################
## test cases #################################################################
###############################################################################

@test "check duplicates in packages file" {
  linecount=$(cat src/packages.txt | wc -l | sed 's/ //g')
  linecountu=$(cat src/packages.txt | sort -u | wc -l | sed 's/ //g')
  [ "$linecount" -eq "$linecountu" ]
}

@test "markdown linting" {
  docker run --rm -i -v pwd:/workspace wpengine/mdl /workspace
  debug "${status}" "${output}" "${lines}"
  [[ "${status}" -eq 0 ]]
}

@test "dockerfile linting" {
  docker run --rm -i hadolint/hadolint:$HADOLINT_VERSION < src/Dockerfile
  debug "${status}" "${output}" "${lines}"
  [[ "${status}" -eq 0 ]]
}

@test "run container-structure-test" {

  # init
  mkdir -p $HOME/bin
  export PATH=$PATH:$HOME/bin

  # check the os
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
          cst_os="linux"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
          cst_os="darwin"
  else
          skip "This test is not supported on your OS platform 😒"
  fi

  # donwload the container-structure-test binary
  cst_bin_name="container-structure-test-$cst_os-amd64"
  cst_download_url="https://storage.googleapis.com/container-structure-test/$CST_VERSION/$cst_bin_name"

  if [ ! -f "$HOME/bin/container-structure-test" ]; then
    curl -LO $cst_download_url
    chmod +x $cst_bin_name
    mv $cst_bin_name $HOME/bin/container-structure-test
  fi

  container-structure-test test --image ${IMAGE} -q --config test/structure_test.yaml

  debug "${status}" "${output}" "${lines}"

  [[ "${status}" -eq 0 ]]
}

@test "vulnerability scanner" {

  # init
  mkdir -p $HOME/bin
  export PATH=$PATH:$HOME/bin

  # install grype
  curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b $HOME/bin

  # exec grype
  grype ${IMAGE} -f High -q -o table

  # check the feedback
  debug "${status}" "${output}" "${lines}"
  [[ "${status}" -eq 0 ]]
}
