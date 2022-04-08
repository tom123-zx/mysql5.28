#!/bin/sh
num=
for i in `kubectl api-versions`;do
	if [[ $i =~ / ]];then
		url=127.0.0.1:8080/apis/$i
	else
		url=127.0.0.1:8080/api/$i
	fi
	res=($(curl $url 2> /dev/null|awk '/kind/{print $2}'|tr -d '",'|sort|uniq|sed '1d'))
	echo "-------------------------------------------------------------------------"
	for j in "${res[@]}";do
		if [ "$j" == "${res[0]}" ];then
			printf "| %-36s | %-30s |\n" $i $j
		else
			printf "| %-36s | %-30s |\n" "$num" "$j"
		fi
	done
done
	echo "-------------------------------------------------------------------------"
