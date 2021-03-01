#!/bin/bash
#timestamp=$(date +%s)
timestamp=$(date '+%Y%m%d%H%M%S')
echo $timestamp
FILEPATH=./result_smartnic/test.txt
slow=500
high=1
#URL_SLOW=http://1.1.1.2:8080/slow/web15k.html  ##15k
URL_SLOW=http://1.1.1.2:8080/index.html
URL_HIGH=http://1.1.1.2:8080/high/web40m.html
#The following URL is used when no limitation for download speed and send speed
Duration=120
#let Rslow=${slow}
let Rslow=20
#let Rhigh=${high}
#let R1=$Duration*${Rele1}
#echo "R1:"$R1


>$FILEPATH
echo $FILEPATH
function wrk_url()
{
	#$1:number of wrk
	#$2: URL $3:Duration Time
	echo "# of slow flows:"$1
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
	#echo $0","$1","$2
	if [ $1 -ge 50 ]
	then
		echo "# of slow flows:"$1
	        echo "wrk -t50 -c"$1" -d"$3" -R"${Rslow}" "$2
        	wrk -t50 -c$1 -d$3 -R${Rslow} -H "Connection: Close" $2 >> $FILEPATH &
	        wait
	fi
}

function wrk_large()
{
        echo "# of high flows:"$1
        for (( i=1; i<=$1; i++ ))
        do
                echo "ele:"$1"+URL:"$2"+time:"$3 &
                #wrk -t40 -c100 -d120s -R40000 -H "Connection: Close" $URL1 >> $FILEPATH &
		#wrk -t20 -c20 -d$3 -R50 -H "Connection: Close" $2 >> $FILEPATH &
                wrk -t1 -c1 -d$3 -R100000 -H "Connection: Close" $2 >> $FILEPATH &
		sleep 2
        done
        wait
}

function wrk_test()
{
	#wrk_url $ele1 $URL1 $Duration &
	#wrk_large $ele2 $URL2 $Duration &
	wrk_light $slow $URL_SLOW $Duration &
	wrk_large $high $URL_HIGH $Duration &

	wait
}


wrk_test
