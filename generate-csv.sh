#!/usr/bin/env bash

set -eo pipefail

# Base directory that contains STL files
BASE='./VT/STLs'

# CSV header
echo 'partname,component,subcomponent,color,quantity,filepath'

while read -r -d '' stlPath ; do
    stlPath="${stlPath##${BASE}/}" # strip $BASE from the path
    awk -F'/' -f process-path.awk <<< "${stlPath}"
done < <(find "${BASE}" -type f -name '*.stl' -print0)
