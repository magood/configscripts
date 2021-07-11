#!/bin/bash
#Environment setup notes
#starting from Jetpack 3.2 developer preview as base

git config --global user.email "matthewcgood@gmail.com"
git config --global user.name "Matthew Good"

sudo apt-get install python-pip python-dev build-essential
pip install numpy
pip install --upgrade pip
#now cv2 imports in python2.

#resource for opencv build: https://jkjung-avt.github.io/opencv3-on-tx2/
#note: You won't have to remove opencv4tegra (this was a 2.4 based version on previous L4T versions). If you keep CMAKE_INSTALL_PREFIX set to /usr, make install should install in place (you might also clean before by hand /usr/include/opencv* and /usr/lib/lib_opencv*)
#other refs: https://jkjung-avt.github.io/opencv3-on-tx2/


sudo apt autoremove
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install g++-5 cpp-5 gcc-5 -y #appears to already be here...
sudo apt-get install build-essential make cmake cmake-curses-gui \
                       g++ libavformat-dev libavutil-dev \
                       libswscale-dev libv4l-dev libeigen3-dev \
                       libglew-dev libgtk2.0-dev -y
sudo apt-get install libdc1394-22-dev libxine2-dev \
                       libgstreamer1.0-dev \
                       libgstreamer-plugins-base1.0-dev -y
sudo apt-get install libjpeg8-dev libjpeg-turbo8-dev libtiff5-dev \
                       libjasper-dev libpng12-dev libavcodec-dev -y
sudo apt-get install libxvidcore-dev libx264-dev libgtk-3-dev \
                       libatlas-base-dev gfortran -y
sudo apt-get install qt5-default -y
sudo apt-get install python3-dev python3-pip python3-tk -y
sudo pip3 install numpy
sudo pip3 install matplotlib
sudo apt-get install nano -y
### Modify matplotlibrc (line #41) as 'backend      : TkAgg'
sudo vim /usr/local/lib/python3.5/dist-packages/matplotlib/mpl-data/matplotlibrc
pip3 install --upgrade pip
# Also install dependencies for python2
sudo apt-get install python-dev python-pip python-tk -y
pip2 install --upgrade pip
sudo pip2 install numpy
sudo pip2 install matplotlib
### Modify matplotlibrc (line #41) as 'backend      : TkAgg'
sudo nano /usr/local/lib/python2.7/dist-packages/matplotlib/mpl-data/matplotlibrc
### Download opencv-3.4.0 source code
mkdir -p ~/src
cd ~/src
wget https://github.com/opencv/opencv/archive/3.4.0.zip \
       -O opencv-3.4.0.zip
unzip opencv-3.4.0.zip
### Apply the following patch to fix the opengl compilation problems
### https://devtalk.nvidia.com/default/topic/1007290/jetson-tx2/building-opencv-with-opengl-support-/post/5141945/#5141945
### Or more specifically, comment out lines #62~66 and line #68 in
### the following .h file (with double-slashes //). Leave the #include <GL/gl.h>.
### And then fix the symbolic link of libGL.so.
sudo nano /usr/local/cuda-9.0/include/cuda_gl_interop.h
cd /usr/lib/aarch64-linux-gnu/
sudo ln -sf tegra/libGL.so libGL.so
### Build opencv (CUDA_ARCH_BIN="6.2" for TX2, or "5.3" for TX1)
cd ~/src/opencv-3.4.0
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D WITH_CUDA=ON -D CUDA_ARCH_BIN="6.2" -D CUDA_ARCH_PTX="" \
        -D WITH_CUBLAS=ON -D ENABLE_FAST_MATH=ON -D CUDA_FAST_MATH=ON \
        -D ENABLE_NEON=ON -D WITH_LIBV4L=ON -D BUILD_TESTS=OFF \
        -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF \
        -D WITH_QT=ON -D WITH_OPENGL=ON ..
make -j4
sudo make install
