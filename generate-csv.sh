#!/usr/bin/env bash

set -euo pipefail

AWK='awk'

if [[ "${OSTYPE}" == darwin* ]]; then
    if command -v gawk &>/dev/null; then
        AWK='gawk'
    else
        echo 'This script requires gawk (GNU awk) to run and you seem to not have it.'
        echo 'If you are doing funky stuff, you know better than I do, just remove this check.'
        exit 1
    fi
fi

# Base directory that contains STL files
BASE="$1"

# CSV header
echo 'partname,component,subcomponent,color,quantity,filepath'

while read -r -d '' stlPath ; do
    stlPath="${stlPath##"${BASE}/"}" # strip $BASE from the path
    "${AWK}" -F'/' -f process-path.awk <<< "${stlPath}"
done < <(find "${BASE}" -type f -name '*.stl' -print0)
