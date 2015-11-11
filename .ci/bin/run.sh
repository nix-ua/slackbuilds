#!/bin/bash

for LIBFILE in $(ls .ci/lib/*.sh); do
    if [ -x "${LIBFILE}" ]; then
        source "${LIBFILE}"
    fi
done

readonly BIN_ROOT='./.ci/bin'

run_script()
{
    exec bash -i -c "${@}" &
    wait ${!}
    return ${?}
}

run_script ${BIN_ROOT}/pre-build.sh

if [ ${?} -eq 0 ]; then
    run_script ${BIN_ROOT}/build-pkgs.sh \
        || exit ${?}

    run_script ${BIN_ROOT}/post-build.sh \
        || exit ${?}

elif [ ${?} -eq -1 ]; then
    # Skip build
    exit 0
else
    exit ${?}
fi

exit 0
