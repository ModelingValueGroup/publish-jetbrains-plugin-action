#!/bin/bash
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## (C) Copyright 2018-2019 Modeling Value Group B.V. (http://modelingvalue.org)                                        ~
##                                                                                                                     ~
## Licensed under the GNU Lesser General Public License v3.0 (the 'License'). You may not use this file except in      ~
## compliance with the License. You may obtain a copy of the License at: https://choosealicense.com/licenses/lgpl-3.0  ~
## Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on ~
## an 'AS IS' BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the  ~
## specific language governing permissions and limitations under the License.                                          ~
##                                                                                                                     ~
## Maintainers:                                                                                                        ~
##     Wim Bast, Tom Brus, Ronald Krijgsheld                                                                           ~
## Contributors:                                                                                                       ~
##     Arjan Kok, Carel Bast                                                                                           ~
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set -euo pipefail

if [[ "${INPUT_TRACE:-false}" == "true" ]]; then
    # shellcheck disable=SC2207
    INPUT_VARS=( $(env | grep '^INPUT_' | sed 's/^INPUT_//;s/=.*//' | sort) )
    for name in "${INPUT_VARS[@]}"; do
        printf "# %16s = %s\n" "$name" "$(eval "echo \${INPUT_$name:-}")"
    done
    set -x
fi

if [[ "$INPUT_HUBTOKEN" == "" ]]; then
    echo "::error::hubToken can not be empty, create a token at https://hub.jetbrains.com"
    exit 85
fi
if [[ "$INPUT_PLUGINID" == "" ]]; then
    echo "::error::pluginId can not be empty, do a manual upload first at https://plugins.jetbrains.com/plugin/add"
    exit 86
fi
if [[ ! "$INPUT_FILE" == *.zip ]]; then
    echo "::error::plugins should be packaged in zip files"
    exit 87
fi

if [[ "$INPUT_CHANNEL" == "" ]]; then
    branch="${GITHUB_REF#refs/heads/}"
    if [[ "$branch" == "master" ]]; then
        INPUT_CHANNEL="stable"
    elif [[ "$branch" == "develop" ]]; then
        INPUT_CHANNEL="eap"
    else
        echo "::info::skipping publish of jetbrains plugin because branch ($branch) is not master or develop"
    fi
fi
if [[ "$INPUT_CHANNEL" != "" ]]; then
    curl -i \
        --header "Authorization: Bearer $INPUT_HUBTOKEN" \
        -F "pluginId=$INPUT_PLUGINID" \
        -F  "channel=$INPUT_CHANNEL" \
        -F     "file=$INPUT_FILE" \
        https://plugins.jetbrains.com/plugin/uploadPlugin

    echo "::info::find your updated plugin at https://plugins.jetbrains.com/plugin/$INPUT_PLUGINID"
fi