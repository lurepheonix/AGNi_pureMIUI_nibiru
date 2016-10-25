#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_CM.sh
. ~/gcc-4.9-uber_aarch64.sh
#. ~/gcc-5.x-uber_aarch64.sh
#. ~/gcc-6.x-uber_aarch64.sh
#. ~/gcc-7.x-uber_aarch64.sh

export ARCH=arm64
mv .git .git-halt

echo ""
echo " Cross-compiling AGNi pureCM-MM kernel ..."
echo ""
cd $KERNELDIR/
rm $KERNELDIR/arch/arm64/boot/Image
rm $KERNELDIR/arch/arm64/boot/Image.gz
rm $KERNELDIR/arch/arm64/boot/Image.gz-dtb
rm $KERNELDIR/arch/arm/boot/dts/*.dtb

if [ ! -f $KERNELDIR/.config ];
then
make agni_kenzo-cm_defconfig
fi

make -j3 || exit 1

rm -rf $KERNELDIR/BUILT_kenzo-cm-mm
mkdir -p $KERNELDIR/BUILT_kenzo-cm-mm/system/lib/modules/

find -name '*.ko' -exec mv -v {} $KERNELDIR/BUILT_kenzo-cm-mm/system/lib/modules/ \;
cp $KERNELDIR/arch/arm64/boot/Image $KERNELDIR/BUILT_kenzo-cm-mm/

echo ""
echo " BUILT_kenzo-cm-mm is ready."

mv .git-halt .git

echo ""
echo "Generating Device Tree image (dt.img) ..."
chmod +x $KERNELDIR/scripts/dtbtool_agni
mv $KERNELDIR/arch/arm/boot/dts/msm8956-mtp-kenzo_cm_led.dtb $KERNELDIR/arch/arm/boot/dts/msm8956-mtp-kenzo_cm_led.dtb.bak
$KERNELDIR/scripts/dtbtool_agni -s 2048 -o $KERNELDIR/BUILT_kenzo-cm-mm/dt.img -p $KERNELDIR/scripts/dtc/ $KERNELDIR/arch/arm/boot/dts/
rm $KERNELDIR/arch/arm/boot/dts/msm8956-mtp-kenzo_cm.dtb
mv $KERNELDIR/arch/arm/boot/dts/msm8956-mtp-kenzo_cm_led.dtb.bak $KERNELDIR/arch/arm/boot/dts/msm8956-mtp-kenzo_cm_led.dtb
$KERNELDIR/scripts/dtbtool_agni -s 2048 -o $KERNELDIR/BUILT_kenzo-cm-mm/dt-cm.img -p $KERNELDIR/scripts/dtc/ $KERNELDIR/arch/arm/boot/dts/
echo "AGNi pureCM-MM has been built for kenzo !!!"


