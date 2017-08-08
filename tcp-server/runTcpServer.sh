#!/usr/bin/env bash

function usage
{
echo -e "\nUsage:
    Options:
    -c  - [REQUIRED] tcpServer.py host and port arguments separated by ':' (e.g. \"outer:1234\")
    -t  - [REQUIRED] Test time in minutes
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
            serverHostPort=$1
            shift
            ;;
        -t)
            testTime=$1
            shift
            ;;
        *)
            echo "Error. Unknown option [$key]"
                usage
            ;;
    esac
done

serverCommand="tcpServer.py"
OIFS=$IFS
IFS=':'
for x in $serverHostPort
do
    serverCommand=$serverCommand" ${x}"
done
IFS=$OIFS
echo $serverCommand

$serverCommand > /soak-result.txt.tmp & export SERVER_PID=$!

echo $SERVER_PID

timeout=$((${1:-$testTime}*60));
echo "TEST TIME IS ${timeout} seconds"

while  kill -0 $SERVER_PID >/dev/null 2>&1  &&  [ $timeout -gt 0 ]
do
    sleep 60
    timeout=$(($timeout-60))
    echo "Remaining test time is : $timeout seconds"
    if  grep -q "NO message received in" /soak-result.txt.tmp  || [[ ! -s /soak-result.txt.tmp ]]; then
       echo '{"soak_result":"Test failed. Check logs in target/TEST*"}' > /soak-result.json
       echo "`basename $0`: Ouch! Test failed. Check logs in target/TEST* "
       tail -n 20 /soak-result.txt.tmp
       tail -n 50  /soak-result.txt.tmp >> /soak-result.txt
       if [ -f /soak-result.json.tmp ]; then
          rm -f /soak-result.json.tmp
       fi
       rm -f /soak-result.json.tmp
       exit -1;
    else
        tail -n 10 /soak-result.txt.tmp
        tail -n 10 /soak-result.txt.tmp > /soak-result.txt
        echo '{"soak_result":"Success"}' > /soak-result.json.tmp
    fi
done


echo "`basename $0`: Finishing test..."
if [ -f /soak-result.json.tmp ]; then
   cat /soak-result.json.tmp > /soak-result.json
fi

if [ -f /soak-result.json ]; then
   echo "soak-result.json was generated. Waiting for test to finish..."
   ping -q -W 20 -i 6 inner
fi


