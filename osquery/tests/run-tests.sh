#!/usr/bin/env bash
# Copyright 2018, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -ve

export TEST_DIR="$(readlink -f $(dirname ${0})/../../)"

pushd "${HOME}"
  if [[ ! -d "src" ]]; then
    mkdir src
  fi
  pushd src
    ln -sf "${TEST_DIR}"
  popd
popd

source ${TEST_DIR}/osquery/tests/manual-test.rc

bash -v "${TEST_DIR}/osquery/bootstrap-embedded-ansible.sh"

${HOME}/ansible25/bin/ansible-galaxy install --force \
                                             --roles-path="${HOME}/ansible25/repositories/roles" \
                                             --role-file="${TEST_DIR}/osquery/tests/ansible-role-requirements.yml"

${HOME}/ansible25/bin/ansible-playbook -i 'localhost,' \
                                       -vv \
                                       ${TEST_DIR}/osquery/tests/test.yml
