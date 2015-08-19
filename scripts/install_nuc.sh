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

# install ros packages and other dependencies
sudo apt-get install ros-indigo-rqt-graph ros-indigo-rqt-gui ros-indigo-rqt-plot ros-indigo-kobuki-soft ros-indigo-kobuki-keyop ros-indigo-roscpp-tutorials ros-indigo-rosserial-arduino ros-indigo-rosserial-server ros-indigo-openni2-launch ros-indigo-openni2-camera ros-indigo-rgbd-launch -y

sudo apt-get install libboost-random1.55-dev openjdk-7-jre ipython -y


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

# merge rosinstall files
cd ~/catkin_ws/src
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/indigo-2015/rosinstall/lab1.rosinstall
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/indigo-2015/rosinstall/arduino.rosinstall

wstool merge lab1.rosinstall
wstool merge arduino.rosinstall

wstool update

cd ~/catkin_ws
catkin_make

# compile arduino libraries and copy to sketchbook folder
mkdir -p ~/sketchbook/libraries

source ~/catkin_ws/devel/setup.bash
cd ~/catkin_ws
rosrun rosserial_arduino make_libraries.py ~/sketchbook/libraries

cp -a ~/catkin_ws/src/ras_arduino_inos/libraries/* ~/sketchbook/libraries/

# install IMU
sh ./install_phidgets_imu.sh

# install arduino IDE
cd ~/Downloads/
wget http://arduino.googlecode.com/files/arduino-1.0.5-linux64.tgz

tar -xzf arduino*tgz

cd /usr/local/bin
sudo ln -s ~/Downloads/arduino-1.0.5/arduino .

# add user to dialout group
sudo adduser ras dialout
sudo adduser ras audio
