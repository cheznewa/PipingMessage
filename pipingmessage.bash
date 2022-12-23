#!/bin/bash
server=https://ppng.io
getid()
{
cat /sys/class/net/*/address | sha256sum | cut -f 1 -d " "
}
getcontacts()
{
cat $HOME/.contacts
}
receives()
{
l=$(wc -l $HOME/.contacts | cut -d " " -f 1)
for n in $(seq $l)
do
a=$(getcontacts | head -n $n | tail -n 1)
id=$(cut -d ";" -f 1 <<< $a)
name=$(cut -d ";" -f 2 <<< $a)
printf "${name} : \n"
timeout 1 curl -s "${server}/${id}_$(getid)"
printf "\n"
done
}
send()
{
if [[ -n $2 ]]
then
curl -sT - ${server}/$(getid)_$1 <<< $2 > /dev/null
else
curl -sT - ${server}/$(getid)_$1 > /dev/null
fi
}
main()
{
if [[ getcontacts == $1 ]]
then
getcontacts
fi
if [[ getid == $1 ]]
then
getid
fi
if [[ receives == $1 ]]
then
receives
fi
if [[ send == $1 ]]
then
send $2 $3
fi
if [[ -z $1 ]]
then
usage
fi
}
usage()
{
printf "$0 send id [message]\n"
printf "$0 receives\n"
printf "$0 getid\n"
printf "$0 getcontacts\n"
printf "Please Write Contacte Into ${HOME}/.contacts\nSyntax :: ID;Name Of Contact ID\n"
}
main $*