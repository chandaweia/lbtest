#!/bin/bash

timestamp=$(date)
#timestamp=$(date +%s)
#timestamp=$(date '+%Y%m%d%H%M%S')
echo $timestamp
Flow_Light=100
Flow_Heavy=3
URL_Light=http://13.0.0.29:8081/slow/web200k.html
URL_Heavy=http://13.0.0.29:8081/high/web730m.html
Duration=180
DurationLarge=20
#let R_Light=20000
let R_Light=${Flow_Light}
RESULT_DIR=./wrk3
echo "R_Light:"$R_Light

if [ $# -ne 1 ];then
	echo "Please input w(weight) or r(rss)"
        exit 
fi
if [[ $1 != "w" ]] && [[ $1 != "r" ]]; then
	echo "Please input correct Type: w(weight) or r(rss)"
	exit
fi

# $1: w for weight, r for rss
FILEPATH=$RESULT_DIR/wrk_${Flow_Light}${Flow_Heavy}_$1.txt

>$FILEPATH
echo $FILEPATH
function wrk_url()
{
	#$1:number of wrk
	#$2: URL $3:Duration Time
	echo "elephant:"$1
	for (( i=1; i<=$1; i++ ))
        do
		echo "ele:"$1"+URL:"$2"+time:"$3 &
                #wrk -t40 -c100 -d120s -R40000 -H "Connection: Close" $URL1 >> $FILEPATH &
		wrk -t2 -c2 -d$3 -R${R1} -H "Connection: Close" $2 >> $FILEPATH &
        done
	wait
}

function wrk_light()
{
	if [ $1 -ge 50 ]
        then
		echo "wrk -t"50" -c"$1" -d"$3" -R"${R_Light}" "$2 
		wrk -t50 -c$1 -d$3 -R${R_Light} -L -U -H "Connection: Close" $2 >> $FILEPATH &
		wait
	fi
}

function wrk_large()
{
        echo "elephant:"$1
        for (( i=1; i<=$1; i++ ))
        do
                #echo "ele:"$1"+URL:"$2"+time:"$3 &
		echo "wrk -t1 -c1 -d"$3" -R50 "$2
		wrk -t1 -c1 -d$3 -R50 -L -U -H "Connection: Close" $2 >> $FILEPATH &
		sleep 3
        done
        wait
}

function wrk_test()
{
	#wrk_url $ele1 $URL1 $Duration &
	#wrk_large $ele2 $URL2 $Duration &
	wrk_light $Flow_Light $URL_Light $Duration &
	wrk_large $Flow_Heavy $URL_Heavy $Duration &
	#wrk_large $ele3 $URL3 $Duration &
	#sleep 2
	#wrk_large $ele3 $URL3 $Duration &

	wait
}

wrk_test
