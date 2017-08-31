#!/bin/bash

# install ros
touch 10periodic
echo 'APT::Periodic::Update-Package-Lists "0";' >> 10periodic
echo 'APT::Periodic::Download-Upgradeable-Packages "0";' >> 10periodic
echo 'APT::Periodic::AutocleanInterval "0";' >> 10periodic

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116

sudo apt-get update -y
sudo apt-get install ros-indigo-desktop-full -y

sudo rosdep init -y
rosdep update -y


# setup environment
source /opt/ros/indigo/setup.bash
echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc
source ~/.bashrc

# install editors/ ssh
sudo apt-get install ssh emacs qtcreator vim git -y

# install ros packages and other dependencies
sudo apt-get install ros-indigo-sound-play ros-indigo-rqt-graph ros-indigo-rqt-gui ros-indigo-rqt-plot ros-indigo-kobuki-soft ros-indigo-kobuki-keyop ros-indigo-roscpp-tutorials ros-indigo-librealsense ros-indigo-rgbd-launch ros-indigo-cmake-modules ros-indigo-camera-info-manager -y

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
source ~/catkin_ws/devel/setup.bash
source ~/.bashrc

# install realsense drivers
cd
mkdir Dev
cd ~/Dev
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
git checkout -b b0.9.2 v0.9.2
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
udevadm trigger
./scripts/patch-uvcvideo-ubuntu-mainline.sh
sudo modprobe uvcvideo

# install phidget drivers
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/indigo-2017/scripts/install_phidgets.sh
sh ./install_phidgets.sh

# create udev rule for arm
touch ttyUSB.rules
echo 'KERNEL=="ttyUSB*", MODE="0666"' >> ttyUSB.rules
sudo mv ttyUSB.rules /etc/udev/rules.d

# merge rosinstall files
sudo pip install pyuarm
cd ~/catkin_ws/src

wget https://raw.githubusercontent.com/KTH-RAS/ras_install/indigo-2017/rosinstall/ras.rosinstall
wstool merge ras.rosinstall
wstool update

rosdep install --skip-keys=librealsense --from-paths -i ras_realsense/realsense_camera/src/
cd ~/catkin_ws
source ~/.bashrc
catkin_make
source ~/catkin_ws/devel/setup.bash
cd ~/catkin_ws/src/ras_rplidar/scripts
sudo mv rplidar.rules /etc/udev/rules.d
sudo service udev reload
sudo service udev restart

# install IMU
sudo apt-get install ros-indigo-phidgets-imu ros-indigo-imu-filter* -y

# add user to dialout group
u=$USER
sudo adduser $u dialout
sudo adduser $u audio
sudo adduser $u video
