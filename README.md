# Openwrt preset schemes.

- Simple.
- Pro.
- Less is more.

## Usage:

### Docker (recommended):

1.
Install and run some Docker-like shit.

2.
```shell
git clone https://github.com/KFERMercer/openwrt-preset.git --depth=1
```

3.
```shell
<sudo or not> docker build -f openwrt-preset/<openwrt>/<branch>/buildbot.dockerfile -t openwrt-buildbot .
```

4.
```shell
docker run -it --rm \
-e COREUSE=$(nproc) \
-v /path/to/workdir:/work \
openwrt-buildbot
```

### Host:

0.
[Get dependencies.](https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem)

1.
```shell
git clone <openwrt> --depth=1 -b <branch> && cd <openwrt>

./scripts/feeds update -a
```

2.
```shell
git clone https://github.com/KFERMercer/openwrt-preset.git --depth=1
```

3.
```shell
patch -p1 -N --verbose --reject-file=/dev/null < ./openwrt-preset/<openwrt>/<branch>/patches/*.patch
```

4.
```shell
./scripts/feeds install -a
```

5.
```shell
cp ./<me>/<openwrt>/<branch>/.config ./

make defconfig
```

6.
```shell
make -j$(nproc) || make -j1 V=s
```
