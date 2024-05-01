# docker build -f ./openwrtbuilder.dockerfile -t openwrt-builder .
# docker run -it --rm -v /path/to/openwrt:/work openwrt-builder
# docker system prune

FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/debian.sources \
    && apt-get update \
    && apt-get full-upgrade -y \
    && apt-get install -y \
        ack antlr3 asciidoc autoconf automake autopoint bash-completion binutils bison build-essential \
        bzip2 ccache clang cmake cpio curl device-tree-compiler ecj fastjar flex gawk gettext gcc-multilib \
        g++-multilib git gnutls-dev gperf haveged help2man intltool lib32gcc-s1 libc6-dev-i386 libelf-dev \
        libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5 \
        libncursesw5-dev libpython3-dev libreadline-dev libssl-dev libtool lld llvm lrzsz mkisofs msmtp \
        nano ninja-build p7zip-full patch pkgconf python-is-python3 python3-pip python3-ply python3-docutils \
        python3-pyelftools qemu-utils re2c rsync scons squashfs-tools subversion sudo swig texinfo \
        uglifyjs unzip vim wget xmlto xxd zlib1g-dev \
    && apt-get update \
    && apt-get autoclean -y \
    && apt-get autopurge -y \
    && useradd -m mom \
    && mkdir -p /etc/sudoers.d \
    && echo 'mom ALL=NOPASSWD: ALL' > /etc/sudoers.d/mom \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* /run/shm/* /dev/shm/*

# COPY ~/.gnupg /home/mom/
USER mom
WORKDIR /work

CMD ["/bin/bash"]
