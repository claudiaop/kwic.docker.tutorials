#!/usr/bin/env bash

function usage
{
echo -e "\nUsage:
    Options:
    -c  - [REQUIRED] tcpClient.py host and port arguments separated by ':' (e.g. \"inner:7778\")
    -w  - [REQUIRED] Other services host and port to wait for before starting (e.g. \"gateway1:8010;gateway2:8010\")
    -a  - [OPTIONAL] Additional arguments for  wait-for-host-and-port.sh (eg: '-t 60') .

    Both -w & -a options require to have wait-for-host-and-port.sh script inside container in \$PATH
    "
echo "Error on line ($BASH_LINENO)"
exit 1
}

if [ $# == 0 ]; then
        usage
fi


while [[ $# > 0 ]]; do
    key="$1"
    shift

    case "$key" in
        -c)
            clientHostPort=$1
            shift
            ;;
        -w)
            waitHostAndPort=$1
            shift
            ;;
        -a)
            additionalArgs=$1
            shift
            ;;
        *)
            echo "Error. Unknown option [$key]"
                usage
            ;;
    esac
done
# $1 can be for example "gateway1:8010;gateway2:8010"
# $2 represents additional arguments for  wait-for-host-and-port.sh (eg: '-t 60') wait-for-host-and-port.sh
OIFS=$IFS
IFS=';'
for x in $waitHostAndPort
do
    IFS=' '
    wait-for-host-and-port.sh $x $additionalArgs
    IFS=';'
done
IFS=$OIFS

clientCommand="tcpClient.py"
OIFS=$IFS
IFS=':'
for x in $clientHostPort
do
    clientCommand=$clientCommand" ${x}"
done
IFS=$OIFS
echo $clientCommand
sleep 30
$clientCommand