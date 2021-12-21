#!/bin/bash

cw=`pwd`

export GITLAB_HOME=$cw/gitlab
export GITLAB_RUNNER_HOME=$cw/gitlab-runner

docker-compose up -d
