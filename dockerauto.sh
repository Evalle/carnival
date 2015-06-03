#!/bin/sh
# v 0.03
# =======
# There are two important things:
# 1) you need to be a root to run this script;
# 2) this script testing only base functionality of Docker on your system. 
sleep 1
echo "dockerat.sh is now testing Docker on your system, you can find all results in '$1' file. Please, be patient..."
sleep 1 
echo "Docker testing on '$HOSTNAME'" > $1
echo "" >> $1
systemctl stop docker
sleep 2
echo "" >> $1
echo "$HOSTNAME:~ # systemctl status docker" >> $1
systemctl status docker >> $1
echo "" >> $1
echo "$HOSTNAME:~ # systemctl start docker" >> $1
systemctl start docker >> $1
sleep 2
echo "" >> $1
echo "$HOSTNAME:~ # systemctl status docker" >> $1
systemctl status docker >> $1
echo "" >> $1
echo "$HOSTNAME:~ # ip a" >> $1
ip a >> $1
echo "" >> $1
echo "$HOSTNAME:~ # docker ps" >> $1
docker ps >> $1
echo "" >> $1
echo "$HOSTNAME:~ # docker run ubuntu uname -r" >> $1
docker run ubuntu uname -r &>> $1
echo "" >> $1
echo "$HOSTNAME:~ # docker run ubuntu echo 'Hello world!'" >> $1
docker run ubuntu echo 'Hello world!' >> $1
echo "" >> $1
echo "$HOSTNAME:~ # docker run ubuntu df -h " >> $1
docker run ubuntu df -h >> $1
echo "" >> $1
echo "$HOSTNAME:~ # docker run ubuntu mount" >> $1
docker run ubuntu mount >> $1
echo "" >> $1
echo "$HOSTNAME:~ # docker ps -a" >> $1
docker ps -a >> $1
echo "" >> $1
echo "$HOSTNAME:~ # docker images " >> $1
docker images >> $1
echo "" >> $1
echo "$HOSTNAME:~ # docker info" >> $1
docker info >> $1

echo "Do you wish to destory all Docker images and containers on your system? (Please choose  1 - for Yes, and 2 - for No)"
select yn in "Yes" "No"; do
    case $yn in 
        Yes ) docker rm -f $(docker ps -a -q) && docker rmi $(docker images -q) > /dev/null; break;;
        No  ) exit;;
    esac
done
echo "" 
echo "Done! Please check '$1' files for results "
