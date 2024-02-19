#!/bin/sh
# description: Auto-starts tomcat
# /etc/init.d/tomcatd
# Tomcat auto-start
# Source function library.
. /etc/init.d/functions
# source networking configuration.
. /etc/sysconfig/network

export JAVA_HOME=/home/data1/liancheng/GTM/tomcat9/jdk
export CATALINA_HOME_HMI=/home/data1/liancheng/GTM/tomcat9
export CATALINA_BASE_HMI=/home/data1/liancheng/GTM/tomcat9
export CATALINA_HOME_NB=/home/data1/liancheng/GTM/apache-tomcat-8.5.71
export CATALINA_BASE_NB=/home/data1/liancheng/GTM/apache-tomcat-8.5.71

start_server() {
    find_process
    pid=$?
    if [ pid == 1]; then
        echo "服务存活 ，请先stop_server或restart_server"
    else
        if [ -f $CATALINA_HOME_HMI/bin/startup.sh ]; then
            echo "HMI CMC 执行启动指令"
            $CATALINA_HOME_HMI/bin/startup.sh
            echo "HMI CMC 启动指令执行成功 但是请注意未必启动成功"
            sleep 5
            if [ -f $CATALINA_HOME_NB/bin/startup.sh ]; then
                echo "接口服务执行启动命令"
                $CATALINA_HOME_NB/bin/startup.sh
                echo "接口服务启动命令执行成功"

            fi
        fi
    fi

}

stop_server() {
    if [ -f $CATALINA_HOME_HMI/bin/shutdown.sh ]; then
        echo "执行停止指令"
        $CATALINA_HOME_HMI/bin/shutdown.sh
	echo "HMI 停止指令执行成功"
        sleep 1
        if [ -f $CATALINA_HOME_NB/bin/shutdown.sh ]; then
            echo "接口服务执行停止指令"
            $CATALINA_HOME_NB/bin/shutdown.sh
            echo "接口服务停止指令执行成功"
            sleep 5
            find_process
            pid=$?
            echo "服务未杀死 执行kill -9 命令"
            ps -U liancheng -u liancheng -f | less | grep tomcat | grep -v grep | grep -v PID | awk '{print $2}' | xargs kill -9
        fi
    fi
}

restart_server() {
    if [ -f $CATALINCATALINA_HOME_HMIA_HOME/bin/shutdown.sh ]; then
        echo "Stopping Tomcat 命令执行成功"
        $CATALINA_HOME_HMI/bin/shutdown.sh
        echo "命令执行成功"
        sleep 1
        if [ -f $CATALINA_HOME_NB/bin/shutdown.sh ]; then
            echo "NB stop tomcat "
            $CATALINA_HOME_NB/bin/shutdown.sh
            echo "接口服务stop 指令执行成功"
            sleep 1
            ps -U liancheng -u liancheng -f | less | grep tomcat | grep -v grep | grep -v PID | awk '{print $2}' | xargs kill -9
            if [ -f $CATALINA_HOME_HMI/bin/startup.sh ]; then
                echo "Starting Tomcat"
                $CATALINA_HOME_HMI/bin/startup.sh
                echo "CMC和HMI 启动命令执行成功"
                sleep 5
                if [ -f $CATALINA_HOME_NB/bin/startup.sh ]; then
                    echo "接口服务开始启动"
                    $CATALINA_HOME_NB/bin/startup.sh
                    echo "接口服务启动指令执行成功"
                fi
            fi

        fi
    fi
}
find_process() {
    ps -U liancheng -u liancheng -f | less | grep tomcat | grep -v grep
    if [ $? -ne 0 ]; then
        return 0
    else
        return 1
    fi
}
case "$1" in
'start')
    start_server
    ;;
'restart')
    restart_server
    ;;
'stop')
    stop_server
    ;;
*)
    echo "usage: $0 {start|restart|stop}"
    exit 1
    ;;
esac
