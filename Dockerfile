FROM --platform=linux/amd64 zephyrprojectrtos/zephyr-build:latest

# Switch to root for installations
USER root

# Setup essentials
RUN apt-get update -y
RUN apt-get install -y git nano build-essential

# Install dependencies
RUN apt-get install -y gcc-multilib g++-multilib fftw3-dev

# Set-up Android Repo Tools
RUN apt-get install -y curl python3 && curl https://commondatastorage.googleapis.com/git-repo-downloads/repo > /bin/repo && chmod a+x /bin/repo
RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /

ENV BSIM_OUT_PATH=/bsim/
ENV BSIM_COMPONENTS_PATH=/bsim/components/

RUN mkdir -p /bsim
RUN chown -Rf user:user /bsim
RUN mkdir -p /zephyr
RUN chown -Rf user:user /zephyr

WORKDIR /bsim
USER user

ENV NRFX_BASE=/bsim/nrfx/
RUN git clone --branch=v2.4.0 https://github.com/NordicSemiconductor/nrfx.git /bsim/nrfx

# Synchronize BabbleSim repository
RUN repo init -u https://github.com/BabbleSim/manifest.git -m everything.xml -b master
RUN repo sync

# Build everything
RUN make everything -j 8

WORKDIR /zephyr

ENV ZEPHYR_BASE=/zephyr/zephyr

RUN west init
RUN west update

# Download and install nrfjprog
#WORKDIR /nrfjprog
#RUN wget https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/nRFCommandLineTools1021Linuxamd64tar.gz
#RUN tar -xvzf nRFCommandLineTools1021Linuxamd64tar.gz
#RUN dpkg --install nRF-Command-Line-Tools_10_2_1_Linux-amd64.deb



# Switch back to app directory
WORKDIR /app
