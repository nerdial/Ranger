#!/bin/bash
vagabondVersion=0.1.0

showHelp () {
    echo 'List of options you may run :'
    echo '----------------------------------------------------------------------------------'
    echo '      -h or --help       shows the help manual'
    echo '      -s or --server     defines which host project should run on, default=localhost'
    echo '      -p or --port       application port  ,default=8000'
    echo '      -d or --default    use php built-in webserver instead'
    echo '      -r or --root       set application root ,default=current directory'
    echo '      -v or --version    shows the version of vagabond'
    echo '      -i or --ini        specify .ini file for php-fpm or php built-in server ,default=looks for php.ini in the current directory,'  
    echo '                         if could not find any, i will use default file located in /etc/vag/php.ini'                                
    echo '----------------------------------------------------------------------------------'
}

portIsNumber () {
    regex='^[0-9]+([.][0-9]+)?$'
    if ! [[ $1 =~ $regex ]] ; then
        echo "error: specified port is not a valid number" >&2; exit 
    else
        return 1
    fi
}

appExist () {
    type "$1" &> /dev/null ;
}

installNginx () {
    nginx=stable
    add-apt-repository ppa:nginx/$nginx
    apt-get update
    apt-get install nginx -y
}

installPHP () {
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
    add-apt-repository ppa:ondrej/php
    apt-get update
    apt-get install php7.2-fpm php7.2-cli php-7.2-zip php-7.2-mbstring php-7.2-dom -y
}

installSoftwarePropertiesCommon () {
     apt-get install software-properties-common -y
}

printVersion () {
    echo  "Vagabond" $vagabondVersion
}

defaultPort=8000
defaultHost='localhost'

while :; do
    case $1 in

        -h|--help)
            showHelp    # Display the help manual.
            exit
            ;;

        -v|--version)
            printVersion    # Show version of vagabond.
            exit
            ;;   

        -s|--server)
            if [ "$2" ]; then
                defaultHost=$2
                shift
            else
                die 'ERROR: "--server" requires a non-empty option argument.'
            fi
            ;; 
        -p|-\?|--port)
            if [ "$2" ]; then
                portIsNumber $2
                defaultPort=$2
                shift
            else
                die 'ERROR: "--port" requires a non-empty option argument.'
            fi
            ;; 
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            exit
            ;;
        *)               # Default case: No more options, so break out of the loop.
            break
    esac
    shift
done

if appExist add-apt-repository ; then
    #echo "add-apt-repository is installed"
else
    installSoftwarePropertiesCommon    
fi

if appExist nginx ; then
    #echo "nginx is installed"
else
    installNginx    
fi

if appExist php-fpm7.2 ; then
    #echo "php-fpm is installed"
else
    installPHP    
fi

arrIN=(${PWD//// })
configName=${arrIN[-1]}

absoulteRootPath='{absoulteRootPath}'
applicationPort='{applicationPort}'
hostName='{hostName}'

modifiedPath="${PWD/////\\}"
cat /etc/vag/nginx.conf | sed "s|"$absoulteRootPath"|"$PWD"|g" | sed "s|"$applicationPort"|"$defaultPort"|g" | sed "s|"$hostName"|"$defaultHost"|g" > /etc/nginx/conf.d/$configName".conf"

if (( $(ps -ef | grep -v grep | grep php7.2-fpm | wc -l) > 0 )); then
    /usr/sbin/service php7.2-fpm restart
else
    /usr/sbin/service php7.2-fpm start
fi

if (( $(ps -ef | grep -v grep | grep nginx | wc -l) > 0 )); then
    /usr/sbin/nginx -s reload
else
    /usr/sbin/nginx
fi

urlPath="http://localhost:"$defaultPort"/"
python -mwebbrowser $urlPath