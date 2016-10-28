#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_MIUI.sh
. ~/gcc-4.9-uber_aarch64.sh
#. ~/gcc-5.x-uber_aarch64.sh
#. ~/gcc-6.x-uber_aarch64.sh
#. ~/gcc-7.x-uber_aarch64.sh

export ARCH=arm64

echo ""
echo " Cross-compiling AGNi pureMIUI-MM kernel ..."
echo ""
echo "Cleanup..."
echo ""

cd $KERNELDIR/

if [ ! -f $KERNELDIR/.config ];
then
make agni_kenzo_defconfig
fi

mv .git .git-halt
rm $KERNELDIR/arch/arm/boot/dts/*.dtb
make -j3 || exit 1
mv .git-halt .git

rm -rf $KERNELDIR/BUILT_kenzo
mkdir -p $KERNELDIR/BUILT_kenzo/system/lib/modules/pronto

find -name '*.ko' -exec mv -v {} $KERNELDIR/BUILT_kenzo/system/lib/modules/ \;
cp $KERNELDIR/arch/arm64/boot/Image $KERNELDIR/BUILT_kenzo/
mv $KERNELDIR/BUILT_kenzo/system/lib/modules/wlan.ko $KERNELDIR/BUILT_kenzo/system/lib/modules/pronto/pronto_wlan.ko

echo ""
echo " BUILT_kenzo is ready."

echo ""
echo "Generating Device Tree images ..."
chmod +x $KERNELDIR/scripts/dtbtool_agni
cd $KERNELDIR;
# Goodix X
$KERNELDIR/scripts/dtbtool_agni -s 2048 -o $KERNELDIR/BUILT_kenzo/dt.img -p $KERNELDIR/scripts/dtc/ $KERNELDIR/arch/arm/boot/dts/
# Goodix V
git apply goodix.patch && echo "   Goodix Patch applied ..."
mv .git .git-halt
rm $KERNELDIR/arch/arm/boot/dts/*.dtb
make -j3 || exit 1
mv .git-halt .git
$KERNELDIR/scripts/dtbtool_agni -s 2048 -o $KERNELDIR/BUILT_kenzo/dt_goodix.img -p $KERNELDIR/scripts/dtc/ $KERNELDIR/arch/arm/boot/dts/
git apply -R goodix.patch && echo "   Goodix Patch Cleaned UP."
rm $KERNELDIR/arch/arm/boot/dts/*.dtb
rm $KERNELDIR/arch/arm64/boot/Image
rm $KERNELDIR/arch/arm64/boot/Image.gz

echo ""
echo "AGNi pureMIUI-MM has been built for kenzo !!!"

