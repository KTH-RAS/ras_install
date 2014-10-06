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

# install ros packages and other dependencies
sudo apt-get install ros-hydro-rqt-graph ros-hydro-rqt-gui ros-hydro-rqt-plot ros-hydro-kobuki-soft ros-hydro-kobuki-keyop ros-hydro-roscpp-tutorials ros-hydro-rosserial-arduino ros-hydro-rosserial-server ros-hydro-openni2-launch ros-hydro-openni2-camera ros-hydro-rgbd-launch -y

sudo apt-get install libboost-random1.46-dev openjdk-7-jre ipython -y


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
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/hydro-2014/rosinstall/lab1.rosinstall
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/hydro-2014/rosinstall/imu.rosinstall
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/hydro-2014/rosinstall/arduino.rosinstall

wstool merge lab1.rosinstall
wstool merge imu.rosinstall
wstool merge arduino.rosinstall

wstool update

cd ~/catkin_ws
catkin_make
source ~/.bashrc

# compile arduino libraries and copy to sketchbook folder
mkdir -p ~/sketchbook/libraries

rospack profile
cd ~/catkin_ws
rosrun rosserial_arduino make_libraries.py ~/sketchbook/libraries

cp -a ~/catkin_ws/src/ras_arduino_inos/libraries/* ~/sketchbook/libraries/


# install arduino IDE
cd ~/Downloads/
wget http://arduino.googlecode.com/files/arduino-1.0.5-linux64.tgz

tar -xzf arduino*tgz

cd /usr/local/bin
sudo ln -s ~/Downloads/arduino-1.0.5/arduino .

# add user to dialout group
sudo adduser ras dialout
