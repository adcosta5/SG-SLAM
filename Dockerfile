# Use the official ROS 2 Foxy image (based on Ubuntu 20.04)
FROM ros:foxy

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies including PCL, Boost, and other required packages
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    g++ \
    build-essential \
    libeigen3-dev \
    libboost-all-dev \
    libopencv-dev \
    libgoogle-glog-dev \
    libsuitesparse-dev \
    libpcl-dev \
    libfmt-dev \
    python3-colcon-common-extensions \
    ros-foxy-pcl-ros \
    ros-foxy-libpointmatcher \
    ros-foxy-rviz2 \
    ros-foxy-tf2-ros \
    ros-foxy-nav-msgs \
    ros-foxy-geometry-msgs \
    ros-foxy-sensor-msgs \
    && rm -rf /var/lib/apt/lists/*

# Copy data folders into the image
# COPY data_odometry_labels /ros_ws/data_odometry_labels
# COPY data_odometry_velodyne /ros_ws/data_odometry_velodyne


# Create a workspace directory
WORKDIR /ros_ws/src

# Clone and build GTSAM (first, since it's a dependency)
# RUN git clone https://github.com/borglab/gtsam.git && \
#     cd gtsam && \
#     mkdir build && \
#     cd build && \
#     cmake .. -DGTSAM_USE_SYSTEM_EIGEN=ON && \
#     make -j4 && \
#     make install

RUN git clone https://github.com/borglab/gtsam.git && \
    cd gtsam && \
    mkdir build && \
    cd build && \
    cmake .. \
        -DGTSAM_USE_SYSTEM_EIGEN=ON \
        -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF \
        -DGTSAM_BUILD_TESTS=OFF \
        -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF \
        -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install

# Clone SG-SLAM into the ROS workspace
# RUN git clone https://github.com/adcosta5/SG-SLAM.git

WORKDIR /ros_ws

# # Build the ROS workspace using colcon
# RUN . /opt/ros/foxy/setup.sh && \
#     MAKEFLAGS="-j4" colcon build --symlink-install

# # Set up the entry point with ROS 2 environment sourced
# CMD ["bash", "-c", ". /opt/ros/foxy/setup.sh && . /ros_ws/install/setup.sh && /bin/bash"]
