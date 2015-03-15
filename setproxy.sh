if [ $1 -ge 1 ]
then
export http_proxy="http://$2:$3"
else
export http_proxy=""
fi
