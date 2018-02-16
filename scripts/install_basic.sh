sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" >> /etc/apt/sources.list.d/ros-latest.list'

sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0xB01FA116

sudo apt-get update -y
sudo apt-get install ros-kinetic-desktop-full -y

sudo rosdep init -y
rosdep update -y


# setup environment
source /opt/ros/kinetic/setup.bash
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

# install build-essential
sudo apt-get install build-essential

# install editors/ ssh
sudo apt-get install ssh emacs qtcreator vim git -y

# install ros packages and other dependencies
sudo apt-get install ros-kinetic-sound-play ros-kinetic-rqt-graph ros-kinetic-rqt-gui ros-kinetic-rqt-plot ros-kinetic-kobuki-soft ros-kinetic-kobuki-keyop ros-kinetic-roscpp-tutorials ros-kinetic-librealsense ros-kinetic-rgbd-launch ros-kinetic-cmake-modules ros-kinetic-camera-info-manager -y

sudo apt-get install libboost-random1.58-dev openjdk-7-jre ipython -y

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

cd ~/catkin_ws/src

wget https://raw.githubusercontent.com/KTH-RAS/ras_install/kinetic-2018/rosinstall/ras_basic.rosinstall
wstool merge ras_basic.rosinstall
wstool update
