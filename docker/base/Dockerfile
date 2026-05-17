# Custos ROS2 base image
# Targets ROS2 Lyrical (LTS, released 2026-05-22) on Ubuntu 26.04.
#
# Build args allow downstream consumers to override for Tier 3 (Ubuntu 24.04)
# during Lyrical's early-life window. See ADR 0011.

ARG UBUNTU_VERSION=26.04
FROM ubuntu:${UBUNTU_VERSION}

ARG ROS_DISTRO=lyrical
ENV ROS_DISTRO=${ROS_DISTRO}
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Base toolchain + ROS2 apt source
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl gnupg lsb-release locales \
        build-essential git python3-pip python3-colcon-common-extensions \
        python3-rosdep python3-vcstool \
    && locale-gen en_US.UTF-8 \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
        | gpg --dearmor -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" \
        > /etc/apt/sources.list.d/ros2.list \
    && rm -rf /var/lib/apt/lists/*

# ROS2 base meta-package
RUN apt-get update && apt-get install -y --no-install-recommends \
        ros-${ROS_DISTRO}-ros-base \
        ros-${ROS_DISTRO}-rmw-cyclonedds-cpp \
    && rm -rf /var/lib/apt/lists/*

# rosdep init (idempotent — silently succeed if already initialized in a layer)
RUN rosdep init || true
USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Default entrypoint sources ROS env then exec's the command
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
