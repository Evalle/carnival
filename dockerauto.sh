#!/bin/sh
# v 0.05
# =======
# There are four important things:
# 1) you need to have root privilegies to run this script;
# 2) this script only testing basic Docker functionality on your system;
# 3) all your results in results.txt file;
# 4) have a lot of fun!

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

echo "dockerat.sh is now testing Docker on your system, you can find your results in 'results.txt' file. Please, be patient..."
sleep 1 

echo "" >> results.txt
echo "Docker testing on '$HOSTNAME' host" > results.txt
echo "" >> results.txt
systemctl stop docker
check

sleep 2
echo "" >> results.txt
echo "$HOSTNAME:~ # systemctl status docker" >> results.txt
systemctl status docker >> results.txt
check

echo "" >> results.txt
echo "$HOSTNAME:~ # systemctl start docker" >> results.txt
systemctl start docker >> results.txt
check

sleep 2
echo "" >> results.txt
echo "$HOSTNAME:~ # systemctl status docker" >> results.txt
systemctl status docker >> results.txt
check

echo "" >> results.txt
echo "$HOSTNAME:~ # ip a" >> results.txt
# We probably need to use "ip a s | grep -i docker" here to find out that we have docker network interface >> TODO
ip a >> results.txt
check 

echo "" >> results.txt
echo "$HOSTNAME:~ # docker ps" >> results.txt
docker ps >> results.txt
check
sleep 1

echo "" >> results.txt
echo "$HOSTNAME:~ # docker run ubuntu uname -r" >> results.txt
docker run ubuntu uname -r &>> results.txt
check 

echo "" >> results.txt
echo "$HOSTNAME:~ # docker run ubuntu echo 'Hello world!'" >> results.txt
docker run ubuntu echo 'Hello world!' >> results.txt
check 

echo "" >> results.txt
echo "$HOSTNAME:~ # docker run ubuntu df -h " >> results.txt
docker run ubuntu df -h >> results.txt
check 

echo "" >> results.txt
echo "$HOSTNAME:~ # docker run ubuntu mount" >> results.txt
docker run ubuntu mount >> results.txt
check

echo "" >> results.txt
echo "$HOSTNAME:~ # docker ps -a" >> results.txt
docker ps -a >> results.txt
check

echo "" >> results.txt
echo "$HOSTNAME:~ # docker images " >> results.txt
docker images >> results.txt
check

echo "" >> results.txt
echo "$HOSTNAME:~ # docker info" >> results.txt
docker info >> results.txt
check

echo ""
if [ $ERRORS -eq 0 ]; then
        echo "All Tests are Passed, check your results in 'results.txt' file"
    else
        echo "One of the tests is FAILED, please check 'results.txt' for additional information"
    fi

echo "" 

echo "Do you wish to destory all Docker images and containers on your system? (Please choose  1 - for Yes, and 2 - for No)"
select yn in "Yes" "No"; do
    case $yn in 
        Yes ) echo ""; echo "These containers will be deleted: "; echo ""; docker rm -f $(docker ps -a -q) && docker rmi $(docker images -q) &> /dev/null; break;;
        No  ) exit;;
    esac
done



