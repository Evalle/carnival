#!/bin/sh
# v 0.03
# =======
# There are two important things:
# 1) you need to be root to run this script;
# 2) this script is useful only for basic Docker functionality testing on your system. 

ERRORS='0'


# fucntion that checking status of your command
function check {
    if [ $? -eq 0 ]; then
        echo "Test Passed"
    else
        echo "Failed"
        ERRORS=$[$ERRORS+1]     
    fi
}

echo "dockerat.sh is now testing Docker on your system, you can find all results in '$1' file. Please, be patient..."
sleep 1 
echo "Docker testing on '$HOSTNAME'" > $1
echo "" >> $1
systemctl stop docker
check

sleep 2
echo "" >> $1
echo "$HOSTNAME:~ # systemctl status docker" >> $1
systemctl status docker >> $1
check

echo "" >> $1
echo "$HOSTNAME:~ # systemctl start docker" >> $1
systemctl start docker >> $1
check

sleep 2
echo "" >> $1
echo "$HOSTNAME:~ # systemctl status docker" >> $1
systemctl status docker >> $1
check

echo "" >> $1
echo "$HOSTNAME:~ # ip a" >> $1
# We need "ip a s | grep -i docker"  here to find that we have docker newtork interface here >> TODO
ip a >> $1
check 

echo "" >> $1
echo "$HOSTNAME:~ # docker ps" >> $1
docker ps >> $1
check

echo "" >> $1
echo "$HOSTNAME:~ # docker run ubuntu uname -r" >> $1
docker run ubuntu uname -r &>> $1
check 

echo "" >> $1
echo "$HOSTNAME:~ # docker run ubuntu echo 'Hello world!'" >> $1
docker run ubuntu echo 'Hello world!' >> $1
check 

echo "" >> $1
echo "$HOSTNAME:~ # docker run ubuntu df -h " >> $1
docker run ubuntu df -h >> $1
check 

echo "" >> $1
echo "$HOSTNAME:~ # docker run ubuntu mount" >> $1
docker run ubuntu mount >> $1
check

echo "" >> $1
echo "$HOSTNAME:~ # docker ps -a" >> $1
docker ps -a >> $1
check

echo "" >> $1
echo "$HOSTNAME:~ # docker images " >> $1
docker images >> $1
check

echo "" >> $1
echo "$HOSTNAME:~ # docker info" >> $1
docker info >> $1
check

echo "Do you wish to destory all Docker images and containers on your system? (Please choose  1 - for Yes, and 2 - for No)"
select yn in "Yes" "No"; do
    case $yn in 
        Yes ) docker rm -f $(docker ps -a -q) && docker rmi $(docker images -q) > /dev/null; break;;
        No  ) exit;;
    esac
done
echo "" 
echo "Done! Please check '$1' files for results "
