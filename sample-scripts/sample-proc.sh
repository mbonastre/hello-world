#!/bin/sh
#
# Sample script to run from cron
#
PROC="sample-proc"
# Fixed PROC_DIR: PROC_DIR="/srv/${PROC}"
# Autodetect PROC_DIR:
PROC_DIR="$( cd $( dirname $0 ) ; pwd -L )"

# Log rotation:
#   No overwrite: new files keep appearing
#     - %Y%m%d-%H%M - one file per execution
#     - %Y%m%d: one file per day
#   Overwrite: fixed number of files
#     - %w: 7 files, one per day of week (0 to 6)
#     - %u: 7 files, one per day of week (1 to 7)
#     - %d: 31 files (01-31)
#     - %j: 365 files (001-365)
#     - %j mod n: n files, one per day, from 0 to j-1
#       $(( $(date "+%j") % 200 ))
LOG_FILE="${PROC_DIR}/${PROC}-$(date "+%d").log"

println() {
    local char="-"  maxcols=70
    local prefix="" size=0
    local text="$@"
    if [ "${#text}" -lt "${maxcols}" ] ; then
      size=$(( ${maxcols} - ${#text} ))
      for i in $(seq 1 ${size:-${maxcols}}) ; do
        prefix="${prefix}${char}"
      done
    fi
    echo -n "${prefix}${text:+ }"
    echo "${text:--}"
}

println_date() {
    println $@ "$( date "+%Y-%m-%d %H:%M.%S" )"
}

exec >> ${LOG_FILE} 2>&1

println_date "Start process ${PROC}" 

sleep 2

println_date "End process ${PROC}"
