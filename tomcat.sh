#!/bin/sh
# description: Auto-starts tomcat
# /etc/init.d/tomcatd
# Tomcat auto-start
# Source function library.
. /etc/init.d/functions
# source networking configuration.
. /etc/sysconfig/network

export JAVA_HOME=/home/data1/liancheng/GTM/tomcat9/jdk1.8.0_202
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
            echo "Starting Tomcat "
            $CATALINA_HOME_HMI/bin/startup.sh
            echo "The startup command is successfully executed .However, the CMC and HMI may not start successfully"
            sleep 5
            if [ -f $CATALINA_HOME_NB/bin/startup.sh ]; then
                echo "start tomcat"
                $CATALINA_HOME_NB/bin/startup.sh
                echo "The startup command is successfully executed .However, the nbmetro may not start successfully"

            fi
        fi
    fi

}

stop_serve() {
    if [ -f $CATALINCATALINA_HOME_HMIA_HOME/bin/shutdown.sh ]; then
        echo $"Stopping Tomcat"
        $CATALINA_HOME_HMI/bin/shutdown.sh
        sleep 1
        if [ -f $CATALINA_HOME_NB/bin/shutdown.sh ]; then
            echo "NB start tomcat"
            $CATALINA_HOME_NB/bin/shutdown.sh
            echo "NB start OK"
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
'start_server')
    start_server
    ;;
'restart_server')
    restart_server
    ;;
'stop_server')
    stop_server
    ;;
*)
    echo "usage: $0 {start_server|restart_server|stop_server}"
    exit 1
    ;;
esac
