#!/bin/bash

#timestamp=$(date)
#timestamp=$(date +%s)
timestamp=$(date '+%Y%m%d%H%M%S')
echo $timestamp
Flow_Light=300
Flow_Heavy=3
URL_Light=http://13.0.0.29:8081/slow/web200k.html
URL_Heavy=http://13.0.0.29:8081/high/web730m.html
Duration=1800
DurationLarge=20
#let R_Light=20000
let R_Light=${Flow_Light}
RESULT_DIR=./wrk9
SCRIPT_DIR=./scripts
echo "R_Light:"$R_Light
math=0

if [ $# -ne 1 ];then
	echo "Please input w(weight) or r(rss)"
        exit 
fi

if [[ $1 != w* ]] && [[ $1 != r* ]]; then
	echo "Please input correct Type: w(weight) or r(rss)"
	exit
fi

if [[ $1 != w* ]]; then
	math=0
else
	math=1
fi

# $1: w for weight, r for rss
#FILEPATH=$RESULT_DIR/wrk_${Flow_Light}${Flow_Heavy}_$1_$timestamp.txt
FILESPATH=$RESULT_DIR/wrk_${Flow_Light}${Flow_Heavy}_$1

#>$FILESPATH
#echo $FILESPATH

function wrk_light()
{
	Filepath=${FILESPATH}_Light.txt
	if [ $1 -ge 50 ]
        then
		echo "Light file:"$Filepath
		echo "wrk -t"50" -c"$1" -d"$3" -R"${R_Light}" "$2 
		echo "wrk -t 50 -c $1 -d$3 -R ${R_Light} -math $math --latency $2" > $Filepath
		wrk -t50 -c$1 -d$3 -R${R_Light} -U -H "Connection: Close" $2 >> $Filepath &
		wait
	fi
}

function wrk_large()
{
	if [ $1 -ge 1 ]
        then
		HeavyFile=${FILESPATH}_Heavy.txt
		echo "Heavy file:"$HeavyFile
		echo "wrk -t $1 -c $1 -d$3 -R 50 -math $math --latency $2" > $HeavyFile
	fi

        for (( i=1; i<=$1; i++ ))
        do
		echo "wrk -t1 -c1 -d"$3" -R50 "$2
		#wrk -t1 -c1 -d$3 -R50 -U --script=extra_wrk.lua --latency -H "Connection: Close" $2 >> $FILEPATH &
		wrk -t1 -c1 -d$3 -R50 -U --script=$SCRIPT_DIR/delay.lua -H "Connection: Close" $2 >> $HeavyFile &

		sleep 2
        done
        wait
}

function wrk_test()
{
	wrk_light $Flow_Light $URL_Light $Duration &
	wrk_large $Flow_Heavy $URL_Heavy $Duration &

	wait
}

wrk_test
