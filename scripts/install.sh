#!/bin/bash

# install ros

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install ros-indigo-desktop -y

sudo rosdep init -y
rosdep update -y


# setup environment
echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
source ~/.bashrc

# install editors/ ssh
sudo apt-get install ssh emacs qtcreator vim git -y

# install ros packages and other dependencies
sudo apt-get install ros-indigo-rqt-graph ros-indigo-rqt-gui ros-indigo-rqt-plot ros-indigo-kobuki-soft ros-indigo-kobuki-keyop ros-indigo-roscpp-tutorials ros-indigo-librealsense ros-indigo-rgbd-launch ros-indigo-cmake-modules ros-indigo-camera-info-manager -y

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

# install realsense drivers
cd /tmp
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
git checkout -b b0.9.2 v0.9.2
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && udevadm trigger
./scripts/patch-uvcvideo-ubuntu-mainline.sh
sudo modprobe uvcvideo

# install phidget drivers
cd /tmp
wget http://www.phidgets.com/downloads/libraries/libphidget.tar.gz
tar -zxvf libphidget.tar.gz
cd libphidget-*
./configure
make
sudo make install
sudo cp udev/99-phidgets.rules /etc/udev/rules.d
cd

# merge rosinstall files
sudo pip install pyuarm
cd ~/catkin_ws/src

wget https://raw.githubusercontent.com/KTH-RAS/ras_install/test_2016/rosinstall/ras.rosinstall
wstool merge ras.rosinstall

wstool update
rosdep install --skip-keys=librealsense --from-paths -i ras_realsense/realsense_camera/src/
cd ~/catkin_ws/src/ras_rplidar_ros && ./scripts/create_udev_rules.sh
cd ~/catkin_ws
source ~/.bashrc
catkin_make
source ~/catkin_ws/devel/setup.bash

# install IMU
sudo apt-get install ros-indigo-imu-filter* -y

# add user to dialout group
u=$USER
sudo adduser $u dialout
sudo adduser $u audio
sudo adduser $u video
