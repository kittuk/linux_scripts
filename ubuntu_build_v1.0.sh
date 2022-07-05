# Ask for the user password
# Script only works if sudo caches the password for a few minutes
sudo true
echo 'ktowning ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo
echo 'kittuk ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo
sudo true

cd ~/

upfile=~/update.sh
touch ${upfile}
chmod +x ${upfile}
chmod a+x ${upfile}
chmod +rx ${upfile}
#sudo ./update.sh

cat > ${upfile} << EOF
#!/bin/bash

check_exit_status() {

    if [ $? -eq 0 ]
    then
        echo
        echo "Success"
        echo
    else
        echo
        echo "[ERROR] Process Failed!"
        echo
		
        read -p "The last command exited with an error. Exit script? (yes/no) " answer

        if [ "$answer" == "yes" ]
        then
            exit 1
        fi
    fi
}

greeting() {

    echo
    echo "Hello, $USER. Let's update this system."
    echo -e "\e[1;42m $HOSTNAME\e[0m"
    echo
}

update() {

    sudo apt-get update;
    check_exit_status

    sudo apt-get upgrade -y;
    check_exit_status

    sudo apt-get dist-upgrade -y;
    check_exit_status
}

housekeeping() {

    sudo apt-get autoremove -y;
    check_exit_status

    sudo apt-get autoclean -y;
    check_exit_status

    #echo sudo updatedb;
    #check_exit_status
}

leave() {

    echo
    echo "--------------------"
    echo "- Update Complete! -"
    echo "--------------------"
    echo
    #exit
}

myreboot() {
    if [ -f /var/run/reboot-required ]; then
        echo -e "\e[1;42m Restarting $HOSTNAME\e[0m"
        echo -e "\e[1;42m Reboot Needed !!! \e[0m"
        sleep 5
        sudo reboot
    else
        echo -e "\e[1;42m $HOSTNAME\e[0m"
        echo -e "\e[1;42m No reboot \e[0m"
        sleep 5
    fi
    exit
}

#mydocker(){

#!/bin/bash
#i=`ps -eaf | grep -i docker |sed '/^$/d' | wc -l`
#echo $i
#if [[ $i > 1 ]]
#then
#  echo -e "\e[1;42m Docker Running !!! \e[0m"
#  echo "docker service is running"
#  sudo docker images |grep -v REPOSITORY|awk '{print $1}'|xargs -L1 docker pull && sudo docker-compose -f ~/docker/docker-compose.yml up -d --remove-orphans && docker container prune -f
  
#else
#  echo -e "\e[1;42m No Docker \e[0m"
#  echo "docker service not running"
#fi  

#systemctl is-active --quiet docker && echo "docker is running" || echo "docker is NOT running"
#    if [ systemctl is-active --quiet docker ]; then
#    sudo docker images |grep -v REPOSITORY|awk '{print $1}'|xargs -L1 docker pull && sudo docker-compose -f ~/docker/docker-compose.yml up -d --remove-orphans && docker container prune -f
#    else
#    echo -e "\e[1;42m No Docker \e[0m"
#    fi
#    }

greeting
update
housekeeping
leave
#mydocker
myreboot

#if [ -f /var/run/reboot-required ]; then
#echo 'reboot required'
#fi
EOF

mkdir ~/bin
mv ${upfile} ~/bin/up
export PATH=~/bin:$PATH
source ~/.bashrc
chmod +rx ~/bin/up
up

sudo timedatectl set-timezone Europe/London
