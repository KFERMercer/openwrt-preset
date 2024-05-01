# Openwrt preset schemes.

- Simple.
- Pro.
- Less is more.

## Usage:

### Docker (recommended):

0. 
    Install and run some Docker-like shit.

1. 
    ```shell
    <sudo or not> docker build -t openwrt-buildbot https://raw.githubusercontent.com/KFERMercer/openwrt-preset/master/immortalwrt/openwrt-23.05/buildbot.dockerfile
    ```

2. 
    ```shell
    <sudo or not> docker run -it --rm \
    -e COREUSE=$(nproc) \
    -v /path/to/workdir:/work \
    openwrt-buildbot
    ```

### Host (if you're a dirty dog):

0. 
    [Get dependencies.](https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem)

1. 
    ```shell
    git clone https://github.com/immortalwrt/immortalwrt.git --depth=1 -b openwrt-23.05 && cd immortalwrt

    ./scripts/feeds update -a
    ```

2. 
    ```shell
    git clone https://github.com/KFERMercer/openwrt-preset.git --depth=1
    ```

3. 
    ```shell
    for i in $(ls ./openwrt-preset/immortalwrt/openwrt-23.05/patches/); do patch -p1 -N --verbose --reject-file=/dev/null < ./openwrt-preset/immortalwrt/openwrt-23.05/patches/$i; done
    ```

4. 
    ```shell
    ./scripts/feeds install -a
    ```

5. 
    ```shell
    cat ./openwrt-preset/immortalwrt/openwrt-23.05/x86_64.config > ./.config

    make defconfig
    ```

6. 
    ```shell
    make -j$(nproc) || make -j1 V=s
    ```
