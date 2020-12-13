#!/bin/bash
#timestamp=$(date +%s)
timestamp=$(date '+%Y%m%d%H%M%S')
echo $timestamp
FILEPATH=./result/test.txt
ele1=400
ele2=3
ele3=1
#URL1=http://13.0.0.29:8089/slow/web1m.html
URL1=http://13.0.0.29:8089/slow/web1m.html
URL2=http://13.0.0.29:8089/high/web30m.html
URL3=http://13.0.0.29:8089/high/web2g.html
Duration=300
DurationLarge=20
let Rele1=${ele1}*2
let R1=$Duration*${Rele1}
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
	echo "wrk -t"40" -c"$1" -d"$3" -R"${R1}" "$2 
	wrk -t40 -c$1 -d$3 -R${R1} -H "Connection: Close" $2 >> $FILEPATH &
}

function wrk_large()
{
        echo "elephant:"$1
        for (( i=1; i<=$1; i++ ))
        do
                echo "ele:"$1"+URL:"$2"+time:"$3 &
                #wrk -t40 -c100 -d120s -R40000 -H "Connection: Close" $URL1 >> $FILEPATH &
		#wrk -t20 -c20 -d$3 -R50 -H "Connection: Close" $2 >> $FILEPATH &
                wrk -t1 -c1 -d$3 -R50 -H "Connection: Close" $2 >> $FILEPATH &
		sleep 2
        done
        wait
}

function wrk_test()
{
	#wrk_url $ele1 $URL1 $Duration &
	#wrk_large $ele2 $URL2 $Duration &
	wrk_light $ele1 $URL1 $Duration &
	wrk_large $ele3 $URL3 $Duration &
#	wrk_large $ele3 $URL3 $Duration &
#	sleep 2
#	wrk_large $ele3 $URL3 $Duration &


	#wrk_large $ele2 $URL2 $DurationLarge & 
	#sleep 20
	#wrk_large $ele3 $URL3 $DurationLarge & 
	#sleep 20
	#wrk_large  $ele2 $URL2 80 &
	#wrk_large $ele3 $URL3 80 &
	#sleep 1
	#wrk_large $ele3 $URL3 $DurationLarge &
	#sleep 5
	#wrk_large $ele2 $URL2 73 &
	#wrk_large $ele2 $URL2 73 &

	wait
}

wrk_test
