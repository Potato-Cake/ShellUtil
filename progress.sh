#!/bin/bash
PROGRESS_CURRENT_PRO=0;
PROGRESS_CURRENT_STATUS=""

function progress0()
{
    local PARAM_PROGRESS=$1;
    local PARAM_STATUS=$2;

    if [ $PARAM_PROGRESS -gt 100 ]; then
    	PARAM_PROGRESS=100
    fi
    if [ $PARAM_PROGRESS -lt 0 ]; then
    	PARAM_PROGRESS=0
    fi

    PROGRESS_CURRENT_PRO=$PARAM_PROGRESS;

    local PROGRESS_TOP="\033[44;37m";
    local PROGRESS_BOTTOM="\033[45;37m";
    local PROGRESS_COUNT=`expr $PARAM_PROGRESS / 5`;

    echo -ne "\033[?25l";

    if [ $PROGRESS_COUNT -eq 0 ]; then
    	printf "${PROGRESS_BOTTOM}%10s${PARAM_PROGRESS}%%%8s\033[0m" "" "";
    elif [ $PROGRESS_COUNT -eq 1 ]; then
    	printf "${PROGRESS_TOP}%1s\033[0m${PROGRESS_BOTTOM}%9s${PARAM_PROGRESS}%%%8s\033[0m" "" "" "";
    elif [ $PROGRESS_COUNT -eq 20 ]; then
    	printf "${PROGRESS_TOP}%8s100%%%8s\033[0m" "" "";
    elif [ $PROGRESS_COUNT -lt 9 ]; then
    	PROGRESS_N=`expr 9 - $PROGRESS_COUNT`
    	printf "${PROGRESS_TOP}%${PROGRESS_COUNT}s\033[0m${PROGRESS_BOTTOM}%${PROGRESS_N}s${PARAM_PROGRESS}%%%8s\033[0m" "" "" "";
    elif [ $PROGRESS_COUNT -eq 9 ]; then
    	printf "${PROGRESS_TOP}%9s\033[0m${PROGRESS_BOTTOM}${PARAM_PROGRESS}%%%8s\033[0m" "" "";
	elif [ $PROGRESS_COUNT -eq 10 ]; then
		PROGRESS_N=`expr $PARAM_PROGRESS / 10`;
    	PROGRESS_E=`expr $PARAM_PROGRESS % 10`;
    	printf "${PROGRESS_TOP}%9s${PROGRESS_N}\033[0m${PROGRESS_BOTTOM}${PROGRESS_E}%%%8s\033[0m" "" "";
	elif [ $PROGRESS_COUNT -eq 11 ]; then
    	printf "${PROGRESS_TOP}%9s${PARAM_PROGRESS}\033[0m${PROGRESS_BOTTOM}%%%8s\033[0m" "" "";
	elif [ $PROGRESS_COUNT -eq 12 ]; then
    	printf "${PROGRESS_TOP}%9s${PARAM_PROGRESS}%%\033[0m${PROGRESS_BOTTOM}%8s\033[0m" "" "";
    else
    	PROGRESS_N=`expr $PROGRESS_COUNT - 12`;
    	PROGRESS_E=`expr 20 - $PROGRESS_COUNT`;
    	printf "${PROGRESS_TOP}%9s${PARAM_PROGRESS}%%%${PROGRESS_N}s\033[0m${PROGRESS_BOTTOM}%${PROGRESS_E}s\033[0m" "" "" "";
	fi
	if [ ! $PARAM_STATUS ]; then
		printf " %s \033[K\r" $PROGRESS_CURRENT_STATUS;
	else
        PROGRESS_CURRENT_STATUS=$PARAM_STATUS
		printf " %s \033[K\r" $PARAM_STATUS;
	fi
	if [ $PROGRESS_COUNT -eq 20 ]; then
		PROGRESS_CURRENT_PRO=0;
    	echo -e "\033[?25h";
    fi
}

function progress()
{
	local PARAM_PROGRESS=$1;
    local PARAM_STATUS=$2;
    if [ $PARAM_PROGRESS -gt $PROGRESS_CURRENT_PRO ]; then
    	local PROGRESS_SPAN=`expr $PARAM_PROGRESS - $PROGRESS_CURRENT_PRO`;
    	if [ $PROGRESS_SPAN -gt 1 ]; then
    		for ((i=$PROGRESS_CURRENT_PRO+1; i<$PARAM_PROGRESS; i++))
			do
    			progress0 $i;
    			sleep 0.01;
			done
    	fi
    fi
    if [ $PARAM_PROGRESS -lt $PROGRESS_CURRENT_PRO ]; then
    	local PROGRESS_SPAN=`expr $PROGRESS_CURRENT_PRO - $PARAM_PROGRESS`;
    	local LOCAL_PARAM_STATUS;
    	if [ $PROGRESS_SPAN -gt 1 ]; then
    		for ((i=$PROGRESS_CURRENT_PRO-1; i>$PARAM_PROGRESS; i--))
			do
    			progress0 $i;
    			sleep 0.01;
			done
    	fi
    fi
    progress0 $PARAM_PROGRESS $PARAM_STATUS;
    sleep 0.05;
}

for ((i=0; i<=100; i++))
do
    progress $i "Processing...${i}"
done
for ((i=0; i<=100; i=i+50))
do
    progress $i "Processing...${i}"
done