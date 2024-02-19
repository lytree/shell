#!/bin/sh
# description: Auto-starts tomcat
# /etc/init.d/tomcatd
# Tomcat auto-start
# Source function library.
. /etc/init.d/functions
# source networking configuration.
. /etc/sysconfig/network

find_process() {
    ps -U liancheng -u liancheng -f | less | grep tomcat | grep -v grep
    if [ $? -ne 0 ]; then
        $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    else
        return 1
    fi
}

find_process_test() {
    $PID = find_process()
   if [ $PID -eq 1 ]; then
        echo "------"
    else
        echo "|||||||"
    fi
}

case "$1" in
'find_process')
    find_process
    ;;
*)
    echo "usage: $0 {find_process}"
    exit 1
    ;;
esac
