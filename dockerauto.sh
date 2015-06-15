#!/bin/sh
# v 0.06
# =======
# There are four important things:
# 1) you need to have root privilegies to run this script;
# 2) this script only testing basic Docker functionality on your system;
# 3) all your results in $LOG file;
# 4) have a lot of fun!

ERRORS='0'
LOG='log'

# fucntion that checking status of your command
function check {
    if [ $? -eq 0 ]; then
        echo "PASSED"
    else
        echo "FAILED"
        ERRORS=$[$ERRORS+1]     
    fi
}

echo "dockerat.sh is now testing Docker on your system, you can find your results in '$LOG' file. Please, be patient..."

echo "Docker testing on '$HOSTNAME' host" > $LOG
echo "" >> $LOG

sleep 2
echo "" >> $LOG
echo "$HOSTNAME:~ # systemctl status docker" >> $LOG
systemctl status docker >> $LOG
echo "test #1 Check status of Docker on your system... " 
check

echo "" >> $LOG
echo "$HOSTNAME:~ # systemctl start docker" >> $LOG
systemctl start docker >> $LOG
check

sleep 2
echo "" >> $LOG
echo "$HOSTNAME:~ # systemctl status docker" >> $LOG
systemctl status docker >> $LOG
check

echo "" >> $LOG
echo "$HOSTNAME:~ # ip a" >> $LOG
# We probably need to use "ip a s | grep -i docker" here to find out that we have docker network interface >> TODO
ip a >> $LOG
check 

echo "" >> $LOG
echo "$HOSTNAME:~ # docker ps" >> $LOG
docker ps >> $LOG
check
sleep 1

echo "" >> $LOG
echo "$HOSTNAME:~ # docker run ubuntu uname -r" >> $LOG
docker run ubuntu uname -r &>> $LOG
check 

echo "" >> $LOG
echo "$HOSTNAME:~ # docker run ubuntu echo 'Hello world!'" >> $LOG
docker run ubuntu echo 'Hello world!' >> $LOG
check 

echo "" >> $LOG
echo "$HOSTNAME:~ # docker run ubuntu df -h " >> $LOG
docker run ubuntu df -h >> $LOG
check 

echo "" >> $LOG
echo "$HOSTNAME:~ # docker run ubuntu mount" >> $LOG
docker run ubuntu mount >> $LOG
check

echo "" >> $LOG
echo "$HOSTNAME:~ # docker ps -a" >> $LOG
docker ps -a >> $LOG
check

echo "" >> $LOG
echo "$HOSTNAME:~ # docker images " >> $LOG
docker images >> $LOG
check

echo "" >> $LOG
echo "$HOSTNAME:~ # docker info" >> $LOG
docker info >> $LOG
check

echo ""
if [ $ERRORS -eq 0 ]; then
        echo "All Tests are Passed, check your results in '$LOG' file"
    else
        echo "One of the tests is FAILED, please check '$LOG' for additional information"
    fi

echo "" 

echo "Do you wish to destory all Docker images and containers on your system? (Please choose  1 - for Yes, and 2 - for No)"
select yn in "Yes" "No"; do
    case $yn in 
        Yes ) echo ""; echo "Deleting your containers: "; echo ""; docker rm -f $(docker ps -a -q) && docker rmi $(docker images -q) &> /dev/null; break;;
        No  ) exit;;
    esac
done



