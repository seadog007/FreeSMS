#!/bin/bash

Phone=$1
Msg=$2

if [ -z "$Phone" ]
then
	echo "Enter the Phone number (without first 0):"
	read Phone
fi

if [ -z "$Msg" ]
then
	until [ -n "`./messagecount.sh $Msg`" ]
	do
		echo "Enter your message (160 chars):"
		read Msg
	done
fi

SID=`curl -s -D- -o /dev/null http://www.afreesms.com/worldwide/taiwan | grep session_id | awk -F=\|\; '{print $2}'`
Hidden=`curl -s http://www.afreesms.com/worldwide/taiwan -H "Cookie: session_id=$SID" -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36' | grep -o '".\{38\}" value=".\{36\}"' | sed 's/"//g' | sed 's/ value//g'`
ID=`shuf -i 0000000000000000000-9999999999999999999 -n 1`
Threshold='55'
VerCode=`./ocr.sh $ID $SID $Threshold`
Time=`date +%s%3N`

#remove # to show debug message
#img2txt -H 20 out.png
#echo $VerCode
#read VerCode
until [ -n "$res" ]
do
res=$(curl -s 'http://www.afreesms.com/worldwide/taiwan' \
-H 'Pragma: no-cache' \
-H 'Origin: http://www.afreesms.com' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-H 'Accept: */*' \
-H 'Cache-Control: no-cache' \
-H 'Connection: keep-alive' \
-H 'Accept-Language: zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4,zh-CN;q=0.2' \
-H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2272.76 Safari/537.36' \
-H 'Referer: http://www.afreesms.com/worldwide/taiwan' \
-H "Cookie: rd=www.afreesms.com; session_id=$SID" \
--data "xajax=processMsg&\
xajaxr=$Time&\
xajaxargs[]=%3Cxjxquery%3E\
%3Cq%3E\
IL_IN_TAG%3D1%26\
countrycode%3D886%26\
smsto%3D$Phone%26\
message%3D$Msg%26\
msgLen%3D141%26\
imgcode%3D$VerCode%26\
$Hidden%26\
IL_IN_TAG%3D1\
%3C%2Fq%3E\
%3C%2Fxjxquery%3E" | grep report)
done