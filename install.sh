#!/bin/bash
function appExits () {
    type "$1" &> /dev/null ;
}

function downloadNecessaryFiles () {
    mkdir -p /etc/vag
    curl -o /etc/vag/nginx.conf 'https://raw.githubusercontent.com/nerdial/Vagabond/master/src/etc/vag/nginx.conf'
    curl -o /etc/vag/php.ini 'https://raw.githubusercontent.com/nerdial/Vagabond/master/src/etc/vag/php.ini'
    curl -o /usr/bin/vag 'https://raw.githubusercontent.com/nerdial/Vagabond/master/vag.sh'
}

if appExits curl ; then
    downloadNecessaryFiles
else
    echo "Curl command is not installed yet.make sure you have installed it properly."
fi
