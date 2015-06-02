#!/bin/sh
# 1) you need to give a filename to this script as an argument;
# 2) you need to be root to run this test
# 3) !!! IMPORTANT !!! in the end, script will remove all containers and images !!! IMPORTANT !!!
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

# uncomment lines below to stop and remove all containers for older version of Docker:
# docker stop $(docker ps -a -q)
# docker rm $(docker ps -a -q)

# For newer version of Docker we can do that in one command.
# (comment line below if you have an older version of Docker)
docker rm -f $(docker ps -a -q) && docker rmi $(docker images -q) &>

echo "Done! Please check '$1' for results"

