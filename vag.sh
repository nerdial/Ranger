#!/bin/bash
function portIsNumber () {
    regex='^[0-9]+([.][0-9]+)?$'
    if ! [[ $1 =~ $regex ]] ; then
        echo "error: Not a number" >&2; exit 1
    else
        return 1
    fi
}
function appExist () {
    type "$1" &> /dev/null ;
}

function installNginx () {
    nginx=stable
    add-apt-repository ppa:nginx/$nginx
    apt-get update
    apt-get install nginx -y
}

function installPHP () {
    add-apt-repository ppa:ondrej/php
    apt-get update
    apt-get install php7.2-fpm php7.2-cli -y
}

defaultPort=8000
defaultHost='localhost'
if [ -z ${1+x} ]; then 
    host=$defaultHost
else 
    host=$1 
fi

if [ -z ${2+x} ]; then 
    port=$defaultPort
else 
    portIsNumber $2
    port=$2 
fi

if appExist nginx ; then
    echo "nginx is installed"
else
    installNginx    
fi

if appExist php-fpm7.2 ; then
    echo "php-fpm is installed"
else
    installPHP    
fi

arrIN=(${PWD//// })
configName=${arrIN[-1]}

absoulteRootPath='{absoulteRootPath}'
applicationPort='{applicationPort}'
hostName='{hostName}'

modifiedPath="${PWD/////\\}"
cat /etc/vag/nginx.conf | sed "s|"$absoulteRootPath"|"$PWD"|g" | sed "s|"$applicationPort"|"$port"|g" | sed "s|"$hostName"|"$host"|g" > /etc/nginx/conf.d/$configName".conf"
service php7.2-fpm restart 
nginx -s reload
urlPath="http://localhost:"$port"/"
python -mwebbrowser $urlPath


