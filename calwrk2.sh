#!/bin/bash 
#./cal.sh result/wrk1.txt n2n.csv 

WrkDIR=./wrk6
RESULT=$1
ThreadN=0
ConnN=0
Math=0 #Math=0 rss, Math=1 weight

echo "file,Threads,Concurrency,Math,50%,75%,90%,99%,99.9%,99.99%,99.999%,100%,u50%,u75%,u90%,u99%,u99.9%,u99.99%,u99.999%,u100%,Throughput" > $RESULT

function write_latency()
{
	echo -n "$2," >> $RESULT
}
function write_throughput()
{
	echo $1 >> $RESULT
}
function getwrk()
{
	#echo -n "$3,$5,${10}," >> $RESULT
	#echo "$3,$5,${10},"
	ThreadN=$3
	ConnN=$5
	Math=${10}
	#echo "${ThreadN}+${ConnN}+${Math}"
}
function write_tcm()
{
	echo -n "$1,$ThreadN,$ConnN,$Math," >> $RESULT
}

function readfile()
{
	while read line
	do
		if [[ $line == wrk* ]]
		then
			getwrk $line
			#echo $line
		elif [[ $line == Running* ]]
                then
			write_tcm $1
		elif [[ $line == 50.000%* ]]
		then
			#echo $line
			write_latency $line
		elif [[ $line == 75.000%* ]]
                then
                        #echo $line
                        write_latency $line
		elif [[ $line == 90.000%* ]]
                then
                        #echo $line
                        write_latency $line
		elif [[ $line == 99.000%* ]]
                then
                        #echo $line
                        write_latency $line
		elif [[ $line == 99.900%* ]]
                then
                        #echo $line
                        write_latency $line
		elif [[ $line == 99.990%* ]]
                then
                        #echo $line
                        write_latency $line
		elif [[ $line == 99.999%* ]]
		then
			#echo $line
			write_latency $line
		elif [[ $line == 100.000%* ]]
                then
                        #echo $line
                        write_latency $line
		elif [[ $line == *requests* ]]
		then
			#echo $line
			write_throughput $line
		fi

	done < $1
}

echo $RESULT

#readfile $1
function readdir()
{
	echo $WrkDIR
	for file in $WrkDIR/*
	do
		if test -f $file
		then
			echo $file
			readfile $file
		fi
	done
}
readdir
#readfile $1 $2
#readfile $1 $WrkPATH/$1 
#echo $RESULT
#readfile $WrkPATH/pubsub-test.txt 
#readfile $WrkPATH/bridge-11k-1593455789.txt 11 
#readfile $WrkPATH/bridge-111k-1593455789.txt 111 
