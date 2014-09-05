#!/bin/bash

# install ros

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu precise main" > /etc/apt/sources.list.d/ros-latest.list'

wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -

sudo apt-get update
sudo apt-get install ros-hydro-desktop -y

sudo rosdep init
rosdep update

# setup environment
source /opt/ros/hydro/setup.bash
echo "export EDITOR=emacs" >> ~/.bashrc

# install editors/ ssh
sudo apt-get install ssh emacs qtcreator vim -y

# install ros packages and dependencies
sudo apt-get install ros-hydro-rqt-graph ros-hydro-rqt-gui ros-hydro-rqt-plot ros-hydro-kobuki-soft ros-hydro-kobuki-keyop ros-hydro-roscpp-tutorials -y

sudo apt-get install libboost-random1.46-dev -y


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
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/hydro-2014/rosinstall/vb.rosinstall

wstool merge vb.rosinstall
wstool update

cd ~/catkin_ws
catkin_make

