#!/bin/bash

# install ros

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116

sudo apt-get update
sudo apt-get install ros-indigo-desktop -y

sudo rosdep init
rosdep update


# setup environment
source /opt/ros/indigo/setup.bash
echo "export EDITOR=emacs" >> ~/.bashrc

# install editors/ ssh
sudo apt-get install ssh emacs qtcreator vim -y

# install ros packages and dependencies
sudo apt-get install ros-indigo-rqt-graph ros-indigo-rqt-gui ros-indigo-rqt-plot ros-indigo-kobuki-soft ros-indigo-kobuki-keyop ros-indigo-roscpp-tutorials -y

sudo apt-get install libboost-random1.55-dev -y


# pip wstool and git
sudo apt-get install git python-pip -y

sudo pip install wstool


# create catkin ws

mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src

catkin_init_workspace
wstool init

cd ~/catkin_ws
catkin_make
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

# merge rosinstall file
cd ~/catkin_ws/src
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/indigo-2015/rosinstall/vm.rosinstall

wstool merge vm.rosinstall
wstool update

cd ~/catkin_ws
catkin_make
source ~/.bashrc

sh ./install_phidgets_imu.sh
