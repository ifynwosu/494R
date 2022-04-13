#! /bin/bash

set -o errexit

#######################################################
# Build the Docker image
#######################################################

# use this for the first ever run on a system to give appropriate permissions
  # docker build -t test \
  #     --build-arg USER_ID=$(id -u) \
  #     --build-arg GROUP_ID=$(id -g) .

# use this on subsequent runs
docker build -t test .

#######################################################
# Run detailed functional tests on small file
#######################################################

# While you are testing, use this command:
dockerCommand="docker run -i -t --rm \
    -v $(pwd)/Data:/Data \
    test"

# dockerCommand="docker run -d --rm \
#     -v $(pwd)/Data:/Data \
#     test"

$dockerCommand Rscript /Scripts/ICGC_Exp.r
#$dockerCommand bash