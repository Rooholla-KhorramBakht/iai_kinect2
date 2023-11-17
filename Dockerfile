FROM ros:noetic-perception
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
# Install dependencies
RUN apt update && apt install -y git libusb-1.0-0-dev libturbojpeg0-dev libopenni2-dev 
WORKDIR /root
RUN git clone https://github.com/OpenKinect/libfreenect2.git && cd libfreenect2 && mkdir build && cd build && cmake .. && make && make install
WORKDIR /root
RUN . /opt/ros/noetic/setup.bash && mkdir -p catkin_ws/src && cd catkin_ws/src && git clone https://github.com/Rooholla-KhorramBakht/iai_kinect2.git && cd .. && catkin_make -DCMAKE_BUILD_TYPE="Release" && . devel/setup.bash
RUN echo "source /root/catkin_ws/devel/setup.bash" >> ~/.bashrc
RUN echo "source /root/catkin_ws/devel/setup.bash && roslaunch kinect2_bridge kinect2_bridge.launch" >> /root/start.sh && chmod +x start.sh
CMD  /root/start.sh