#!/bin/sh
# v 0.9
# =======
# There are four important things:
# 1) you need to have root privilegies to run this script;
# 2) this script only testing basic Docker functionality on your system;
# 3) you can find all your results in the log file (see $LOG variable);
# 4) have a lot of fun!

ERRORS=0

#docker version variable:
VOUTPUT="$(docker --version)"

# All your results in the $LOG you can change it and give specific name to it if you want to below:
LOG='log'

# function that checking status of your command
function check {
    if [ $? -eq 0 ]; then
        echo "PASSED"
    else
        echo "FAILED"
        ERRORS=$[$ERRORS+1]     
    fi
}

function check_version {
    if [ "$1"== "{$VOUTPUT}" ]; then
        echo "PASSED"
    else
        echo "FAILED"
        ERRORS=$[$ERRORS+1]     
    fi
}
 

echo "dockerat.sh is now testing Docker on your system, you can find your results in '$LOG' file. Please, be patient..."

echo "Docker testing on '$HOSTNAME' host" > $LOG
echo "" >> $LOG

echo "" >> $LOG
echo "$HOSTNAME:~ # systemctl start docker" >> $LOG
systemctl start docker >> $LOG
echo "test #1 Trying to start Docker on our system..."
check

sleep 2
echo "" >> $LOG
echo "$HOSTNAME:~ # systemctl status docker" >> $LOG
systemctl status docker >> $LOG
echo "test #2 Check status of Docker on our system..."
check

sleep 2
echo "" >> $LOG
echo "$HOSTNAME:~ # systemctl restart docker" >> $LOG
systemctl restart docker >> $LOG
echo "test #3 Check that we can restart Docker on our system..."
check

echo "" >> $LOG
echo "$HOSTNAME:~ # docker --version" >> $LOG
docker --version >> $LOG
echo "test #4 Check Docker version..."
check_version

echo "" >> $LOG
echo "$HOSTNAME:~ # ip a s" >> $LOG
ip a s | grep -i docker >> $LOG
echo "test #5 Check that we have docker network interface on our system..."
check 

echo "" >> $LOG
echo "$HOSTNAME:~ # docker ps" >> $LOG
docker ps >> $LOG
echo "test #6 Check the list of running docker containers..."
check
sleep 1

echo "" >> $LOG
echo "$HOSTNAME:~ # docker run ubuntu uname -r" >> $LOG
docker run ubuntu uname -r &>> $LOG
echo "test #7 Check that we can start a new docker container via 'docker run ubuntu uname -r'"
check 

echo "" >> $LOG
echo "$HOSTNAME:~ # docker run ubuntu echo 'Hello world!'" >> $LOG
docker run ubuntu echo 'Hello world!' >> $LOG
echo "test #8 Check that we can start a new docker container via 'docker run ubuntu echo 'Hello world!'"
check 

echo "" >> $LOG
echo "$HOSTNAME:~ # docker run ubuntu df -h " >> $LOG
docker run ubuntu df -h >> $LOG
echo "test #9 Check that we can start a new docker container via 'docker run ubuntu df -h'..."
check 

echo "" >> $LOG
echo "$HOSTNAME:~ # docker run ubuntu mount" >> $LOG
docker run ubuntu mount >> $LOG
echo "test #10 Check that we can start a new docker container via 'docker run ubuntu mount'..."
check

echo "" >> $LOG
echo "$HOSTNAME:~ # docker ps -a" >> $LOG
docker ps -a >> $LOG
echo "test #11 Check that we can see the list of all docker containers on our system..."
check

echo "" >> $LOG
echo "$HOSTNAME:~ # docker images " >> $LOG
docker images >> $LOG
echo "test #12 Check that we can see the list of all docker images on our system..."
check

echo "" >> $LOG
echo "$HOSTNAME:~ # docker info" >> $LOG
docker info >> $LOG
echo "test #13 Check docker info..."
check

echo ""
if [ $ERRORS -eq 0 ]; then
echo "All Tests are PASSED, check your results in '$LOG' file"
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
