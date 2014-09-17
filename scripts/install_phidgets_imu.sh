cd ~/catkin_ws/src
wget https://raw.githubusercontent.com/KTH-RAS/ras_install/hydro-2014/rosinstall/imu.rosinstall

wstool merge imu.rosinstall -y
wstool update phidgets_drivers imu_tools 

cd ..
catkin_make

source ~/.bashrc
rospack profile

rosrun phidgets_api setup-udev.sh
