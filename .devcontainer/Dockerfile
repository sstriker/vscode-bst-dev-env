#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM mcr.microsoft.com/vscode/devcontainers/base:debian-10

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# This Dockerfile's base image has a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    #
    # Install C++ tools
    && apt-get -y install build-essential cmake cppcheck valgrind \
    # Install Python
    && apt-get -y install python3 python3-dev python3-pip \
    # Install pylint
    && pip3 --disable-pip-version-check --no-cache-dir install pylint \
    #
    # Install buildbox-common dependencies
    && apt-get -y install \
      attr cmake gcc g++ git googletest grpc++ pkg-config libssl-dev uuid-dev \
    && (cd /usr/src/googletest \
        && mkdir build \
        && cd build \
        && cmake .. \
        && make install) \
    #
    # Install buildbox-casd dependencies
    #
    # Install buildbox-fuse dependencies
    && apt-get install -y \
      cmake gcc g++ git  grpc++ libfuse3-dev libssl-dev pkg-config uuid-dev \
    #
    # Install buildbox-run-bubblewrap dependencies
    && apt-get -y install bubblewrap \
    #
    # Install buildbox-run-hosttools dependencies
    #
    # Install buildbox-run-userchroot dependencies
    #
    # Install buildbox-worker dependencies
    #&& apt-get -y install  libprotobuf-dev libgmock-dev protobuf-compiler-grpc \
    # Install BuildStream dependencies
    && apt-get -y install cython3 fuse bubblewrap \
    && apt-get -y install bzr git lzip patch python3-arpy python3-gi \
    && pip3  --disable-pip-version-check --no-cache-dir install virtualenv \
    # [Optional] Update UID/GID if needed
    && if [ "$USER_GID" != "1000" ] || [ "$USER_UID" != "1000" ]; then \
        groupmod --gid $USER_GID $USERNAME \
        && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
        && chown -R $USER_UID:$USER_GID /home/$USERNAME; \
    fi \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
