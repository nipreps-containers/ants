FROM ubuntu:focal-20210416

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
                        build-essential \
                        ca-certificates \
                        cmake \
                        gcc \
                        git \
                        make \
                        zlib1g \
                        zlib1g-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


WORKDIR /opt/ants
ARG VERSION
RUN git config --global url."https://".insteadOf git:// \
    && git clone https://github.com/ANTsX/ANTs.git --branch ${VERSION}

WORKDIR /opt/ants/build
RUN mkdir /opt/ants/install \
    && cmake -DCMAKE_INSTALL_PREFIX=/opt/ants/install -DBUILD_TESTING=OFF ../ANTs 2>&1 | tee cmake.log \
    && make -j 4 2>&1 | tee build.log

WORKDIR /opt/ants/build/ANTS-build
RUN make install 2>&1 | tee install.log
