#!/bin/bash

# Used for manually running tests via 'gitlab-runner exec shell ...'
# (eg. via scrontab) when no runner is available for direct gitlab
# integration.

# prereqs:
# - install gitlab-runner.  Don't need root, can do like:
#     mkdir -p ~/packages/gitlab-runner
#     cd ~/packages
#     curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/latest/rpm/gitlab-runner_amd64.rpm"
#     cd gitlab-runner
#     rpm2cpio ../gitlab-runner_amd64.rpm | cpio -i --make-directories
#   and then run gitlab-runner by:  ~/packages/gitlab-runner/usr/bin/gitlab-runner

# note:  'gitlab-runner exec' is currently rather limited :(
# see:  https://gitlab.com/gitlab-org/gitlab-runner/-/issues/2797
#
# Must create tweaked versions of ci .yml files to:
# - use '<<' instead of 'extends'
# - inline chgrp and chmod instead of using '*finalize'
# - call each file and task directly:  can't use 'include',
#   only runs explicitly listed task, one at a time
# - seems to only include global vars and a final variables: declaration, doesn't merge intermediates from <<
# - seems to only see final script: declarations, doesn't merge intermediates from <<
# - sets pipefail, which breaks 'conda activate ...'
# - [list all limitations...]

# should we:
# - source a conf file to set: SDK_DASHBOARD_{TOKEN,URL}, SDK_WORK_DIR, SITE
# - create a full environment and run code from fresh clone/fetch each time for complete testing?
# - set FF_ENABLE_JOB_CLEANUP ?  https://docs.gitlab.com/runner/configuration/feature-flags.html
# - cleanup /tmp/{old,new}-env-[0-9]+.txt
# ?
# Yes!  Have too for scrontab and SDK_DASHBOARD_TOKEN atleast!
# At a min, the rc file must be:
#  * executable
#  * and set the following (shown as example)
#---start example rc
### should customize all of these for your site + installation:
# export RUNNER=${RUNNER:-~/packages/gitlab-runner/usr/bin/gitlab-runner}
#
# export SDK_DASHBOARD_TOKEN=${SDK_DASHBOARD_TOKEN:-[token acquired from dashboard token request service]}
# export SDK_DASHBOARD_URL=${SDK_DASHBOARD_URL:-https://sdk.testing.exaworks.org/result}
# export SDK_WORK_DIR=${SDK_WORK_DIR:-/global/cfs/cdirs/m[####]/sdk}
#
# export SITE=${SITE:-perlmutter}
#
# export PIP_CONF_FILE=${PIP_CONF_FILE:-.gitlab/nersc-ci-manual-exec-pip.yml}
# export CONDA_CONF_FILE=${CONDA_CONF_FILE:-.gitlab/nersc-ci-manual-exec-conda.yml}
#
# export CI_PIPELINE_ID=${RANDOM}
# export CI_COMMIT_BRANCH="master"
# export BUILDS_DIR="${SDK_WORK_DIR}/builds"
#---end example rc

echo "starting $0 run at $(date) in $(pwd) ..."

export SITE_CI_GITLAB_RUNNER_SH_RC=${SITE_CI_GITLAB_RUNNER_SH_RC:-${HOME}/.nersc-ci-gitlab-runner.sh.rc}
if [ -x "${SITE_CI_GITLAB_RUNNER_SH_RC}" ]; then
    . ${SITE_CI_GITLAB_RUNNER_SH_RC}
fi

if [ -z "$SDK_DASHBOARD_TOKEN" ]; then
    echo -e "$0:\tSDK_DASHBOARD_TOKEN env var must be set!!!\n"
    exit
fi

echo "cd'ing to \$REPO_DIR ($REPO_DIR)..."
pushd $REPO_DIR

### for temp dev hacking...
###$RUNNER exec shell \
###	--env "SDK_DASHBOARD_TOKEN=${SDK_DASHBOARD_TOKEN}" \
###	--env "SDK_DASHBOARD_URL=${SDK_DASHBOARD_URL}" \
###	--env "SDK_WORK_DIR=${SDK_WORK_DIR}" \
###	--env "CI_PIPELINE_ID=${RANDOM}" \
###	--env 'CI_COMMIT_BRANCH=master' \
###    --builds-dir ${BUILDS_DIR} --cicd-config-file ${PIP_CONF_FILE} pip_env_setup_perlmutter

#if [ "$1" == "pip" ]; then  # tmp for debug
for task in {pip_env_setup_,pip_build_,pip_test_}${SITE} pip_cleanup; do
    echo "### running: $task ..."
    date
    # hack to try to get cleanup working... give it a min to clear build dir from previous?
    if [ "$task" == "pip_cleanup" ]; then
	echo "sleeping for cleanup from previous..."
	sleep 180
    fi
#    echo "### checking build dir ..."
#    find ${BUILDS_DIR} -xdev -print0 | xargs -0r ls -altrd
    $RUNNER exec shell \
    	--env "SDK_DASHBOARD_TOKEN=${SDK_DASHBOARD_TOKEN}" \
    	--env "SDK_DASHBOARD_URL=${SDK_DASHBOARD_URL}" \
    	--env "SDK_WORK_DIR=${SDK_WORK_DIR}" \
    	--env "CI_PIPELINE_ID=${RANDOM}" \
    	--env 'CI_COMMIT_BRANCH=master' \
        --builds-dir ${BUILDS_DIR} --cicd-config-file ${PIP_CONF_FILE} $task
done    
#else  # tmp for debug
for task in {conda_setup_,conda_env_setup_,conda_build_,conda_test_}${SITE} conda_cleanup; do
    echo "### running: $task ..."
    date
    # hack to try to get cleanup working... give it a min to clear build dir from previous?
    if [ "$task" == "conda_cleanup" ]; then
	echo "sleeping for cleanup from previous..."
	sleep 180
    fi
#    echo "### checking build dir ..."
#    find ${BUILDS_DIR} -xdev -print0 | xargs -0r ls -altrd
    $RUNNER exec shell \
    	--env "SDK_DASHBOARD_TOKEN=${SDK_DASHBOARD_TOKEN}" \
    	--env "SDK_DASHBOARD_URL=${SDK_DASHBOARD_URL}" \
    	--env "SDK_WORK_DIR=${SDK_WORK_DIR}" \
    	--env "CI_PIPELINE_ID=${RANDOM}" \
    	--env 'CI_COMMIT_BRANCH=master' \
        --builds-dir ${BUILDS_DIR} --cicd-config-file ${CONDA_CONF_FILE} $task
done    
#fi  # tmp for debug
date
