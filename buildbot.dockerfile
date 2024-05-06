FROM debian:latest

ARG DEBIAN_FRONTEND noninteractive

RUN \
    sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/debian.sources; \
    apt-get update; \
    apt-get full-upgrade -y; \
    apt-get install -y \
        ack antlr3 asciidoc autoconf automake autopoint bash-completion binutils bison build-essential \
        bzip2 ccache clang cmake cpio curl device-tree-compiler ecj fastjar flex gawk gettext gcc-multilib \
        g++-multilib git gnutls-dev gperf haveged help2man intltool lib32gcc-s1 libc6-dev-i386 libelf-dev \
        libglib2.0-dev libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5 \
        libncursesw5-dev libpython3-dev libreadline-dev libssl-dev libtool lld llvm lrzsz mkisofs msmtp \
        nano ninja-build p7zip-full patch pkgconf python-is-python3 python3-pip python3-ply python3-docutils \
        python3-pyelftools qemu-utils re2c rsync scons squashfs-tools subversion sudo swig texinfo \
        uglifyjs unzip vim wget xmlto xxd zlib1g-dev zstd; \
    apt-get update; \
    apt-get autoclean -y; \
    apt-get autopurge -y; \
    useradd -m mom; \
    mkdir -p /etc/sudoers.d; \
    echo 'mom ALL=NOPASSWD: ALL' > /etc/sudoers.d/mom; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/* /run/shm/* /dev/shm/*

# COPY ~/.gnupg /home/mom/
USER mom
WORKDIR /work

ENV OPENWRT_REPO    "https://github.com/immortalwrt/immortalwrt.git"
ENV OPENWRT_BRANCH  "openwrt-23.05"
ENV PRESET_REPO     "https://github.com/KFERMercer/openwrt-preset.git"
ENV PRESET_ARCH     "x86_64"
ENV COREUSE         "$(nproc)"
ENV DEVMOD          "0"
ENV SHELL           "/bin/bash"

CMD  \
    [ -d $(basename "${PRESET_REPO%.git}") ] || git clone ${PRESET_REPO} --depth=1 || exit 1; \
    [ -d $(basename "${OPENWRT_REPO%.git}") ] || git clone ${OPENWRT_REPO} --depth=1 -b ${OPENWRT_BRANCH} || exit 1; \
    [ "${COREUSE}" -gt 0 ] 2>/dev/null || COREUSE=$(nproc); \
    if [ ${DEVMOD} -eq 0 ]; then \
        cd $(basename "${OPENWRT_REPO%.git}") || exit 1; \
        ./scripts/feeds update -a || exit 1; \
        for i in $(ls /work/$(basename "${PRESET_REPO%.git}")/$(basename "${OPENWRT_REPO%.git}")/${OPENWRT_BRANCH}/patches/); do \
            patch -p1 -N --verbose --reject-file=/dev/null < /work/$(basename "${PRESET_REPO%.git}")/$(basename "${OPENWRT_REPO%.git}")/${OPENWRT_BRANCH}/patches/$i || exit 1; \
        done; \
        ./scripts/feeds install -a || exit 1; \
        cat /work/$(basename "${PRESET_REPO%.git}")/$(basename "${OPENWRT_REPO%.git}")/${OPENWRT_BRANCH}/${PRESET_ARCH}.config > ./.config || exit 1; \
        make defconfig || exit 1; \
        make download -j8 V=s && make -j${COREUSE} || make -j${COREUSE} || make -j${COREUSE} || make -j1 V=s || exit 1; \
        exit 0; \
    else \
        ${SHELL} || exit 1; \
    fi; \
    exit 0
