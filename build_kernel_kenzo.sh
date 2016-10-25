#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_MIUI.sh
. ~/gcc-4.9-uber_aarch64.sh
#. ~/gcc-5.x-uber_aarch64.sh
#. ~/gcc-6.x-uber_aarch64.sh
#. ~/gcc-7.x-uber_aarch64.sh

export ARCH=arm64
mv .git .git-halt

echo ""
echo " Cross-compiling AGNi pureMIUI-MM kernel ..."
echo ""
cd $KERNELDIR/
rm $KERNELDIR/arch/arm64/boot/Image
rm $KERNELDIR/arch/arm64/boot/Image.gz
rm $KERNELDIR/arch/arm64/boot/Image.gz-dtb
rm $KERNELDIR/arch/arm/boot/dts/*.dtb

if [ ! -f $KERNELDIR/.config ];
then
make agni_kenzo_defconfig
fi

make -j3 || exit 1

rm -rf $KERNELDIR/BUILT_kenzo
mkdir -p $KERNELDIR/BUILT_kenzo/system/lib/modules/pronto

find -name '*.ko' -exec mv -v {} $KERNELDIR/BUILT_kenzo/system/lib/modules/ \;
cp $KERNELDIR/arch/arm64/boot/Image.gz-dtb $KERNELDIR/BUILT_kenzo/
mv $KERNELDIR/BUILT_kenzo/system/lib/modules/wlan.ko $KERNELDIR/BUILT_kenzo/system/lib/modules/pronto/pronto_wlan.ko

echo ""
echo " BUILT_kenzo is ready."

mv .git-halt .git

echo ""
echo "AGNi pureMIUI-MM has been built for kenzo !!!"


