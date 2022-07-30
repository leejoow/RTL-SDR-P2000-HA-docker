ARG BUILD_FROM=debian:bullseye
FROM debian:bullseye

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3042
RUN apt-get update && apt-get install -y \
	build-essential \
	cmake \
	unzip \
	pkg-config \
	libusb-1.0-0-dev \
	git \
	qt5-qmake \
	libpulse-dev \
	libx11-dev \
	python3-pip

RUN cd && \ 
    git clone git://git.osmocom.org/rtl-sdr.git && \
    cd rtl-sdr && \
    mkdir build;cd build && \
    cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON && \
    make && \
    make install && \
    ldconfig
	
RUN cd && \
    git clone https://github.com/Zanoroy/multimon-ng.git && \
    cd multimon-ng && \
    mkdir build;cd build && \
    qmake -qt=qt5 ../multimon-ng.pro && \
    make && \
    make install
	
RUN	pip3 install paho.mqtt && \
    pip3 install opencage && \
    pip3 install geopy
	
RUN cd && \
    git clone https://github.com/cyberjunky/RTL-SDR-P2000Receiver-HA.git

COPY config.ini /root/RTL-SDR-P2000Receiver-HA

CMD ["/root/RTL-SDR-P2000Receiver-HA/p2000.py"]
#CMD ["rtl_test"]
#CMD ["rtl_fm -f 169.65M -M fm -s 22050 | multimon-ng -a FLEX -t raw -"]