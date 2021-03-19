#!/bin/bash
#timestamp=$(date +%s)
timestamp=$(date '+%Y%m%d%H%M%S')
echo $timestamp
FILEPATH=./test.txt
Flow_Light=700
Flow_Heavy=3
#URL1=http://13.0.0.29:8089/slow/web1m.html
URL_Light=http://13.0.0.29:8081/slow/web50k.html
URL_Heavy=http://13.0.0.29:8081/high/web500m.html
#URL3=http://13.0.0.29:8089/high/web1g.html
Duration=180
DurationLarge=20
let Rele1=20000
let R1=${Rele1}
echo "R1:"$R1


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
		echo "wrk -t"50" -c"$1" -d"$3" -R"${R1}" "$2 
		wrk -t50 -c$1 -d$3 -R${R1} -L -U -H "Connection: Close" $2 >> $FILEPATH &
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
#	wrk_large $ele3 $URL3 $Duration &
#	sleep 2
#	wrk_large $ele3 $URL3 $Duration &

	wait
}

wrk_test
