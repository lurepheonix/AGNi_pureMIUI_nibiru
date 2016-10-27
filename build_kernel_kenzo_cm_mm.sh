#!/bin/sh
export KERNELDIR=`readlink -f .`
. ~/AGNi_stamp_CM.sh
. ~/gcc-4.9-uber_aarch64.sh
#. ~/gcc-5.x-uber_aarch64.sh
#. ~/gcc-6.x-uber_aarch64.sh
#. ~/gcc-7.x-uber_aarch64.sh

export ARCH=arm64

echo ""
echo " Cross-compiling AGNi pureCM-MM kernel ..."
echo ""
echo "Cleanup..."
echo ""
rm drivers/leds/leds-aw2013.ko
rm drivers/leds/leds-aw2013_cm.ko

cd $KERNELDIR/

if [ ! -f $KERNELDIR/.config ];
then
make agni_kenzo-cm_defconfig
fi

mv .git .git-halt
rm $KERNELDIR/arch/arm/boot/dts/*.dtb
make -j3 || exit 1
mv .git-halt .git

rm -rf $KERNELDIR/BUILT_kenzo-cm-mm
mkdir -p $KERNELDIR/BUILT_kenzo-cm-mm/system/lib/modules/

find -name '*.ko' -exec mv -v {} $KERNELDIR/BUILT_kenzo-cm-mm/system/lib/modules/ \;
cp $KERNELDIR/arch/arm64/boot/Image $KERNELDIR/BUILT_kenzo-cm-mm/

echo ""
echo " BUILT_kenzo-cm-mm is ready."

echo ""
echo "Generating Device Tree images ..."
chmod +x $KERNELDIR/scripts/dtbtool_agni
cd $KERNELDIR;
# LED X 		Goodix X
mv .git .git-halt
rm $KERNELDIR/arch/arm/boot/dts/*.dtb
make -j3 || exit 1
mv .git-halt .git
$KERNELDIR/scripts/dtbtool_agni -s 2048 -o $KERNELDIR/BUILT_kenzo-cm-mm/dt.img -p $KERNELDIR/scripts/dtc/ $KERNELDIR/arch/arm/boot/dts/
# LED V 		Goodix X
git apply led.patch && echo "   LED Patch applied ..."
mv .git .git-halt
rm $KERNELDIR/arch/arm/boot/dts/*.dtb
make -j3 || exit 1
mv .git-halt .git
$KERNELDIR/scripts/dtbtool_agni -s 2048 -o $KERNELDIR/BUILT_kenzo-cm-mm/dt_led.img -p $KERNELDIR/scripts/dtc/ $KERNELDIR/arch/arm/boot/dts/
# LED X 		Goodix V
git apply -R led.patch && echo "   LED Patch removed ..."
git apply goodix.patch && echo "   Goodix Patch applied ..."
mv .git .git-halt
rm $KERNELDIR/arch/arm/boot/dts/*.dtb
make -j3 || exit 1
mv .git-halt .git
$KERNELDIR/scripts/dtbtool_agni -s 2048 -o $KERNELDIR/BUILT_kenzo-cm-mm/dt_goodix.img -p $KERNELDIR/scripts/dtc/ $KERNELDIR/arch/arm/boot/dts/
# LED V 		Goodix V
git apply led.patch && echo "   LED Patch applied ..."
mv .git .git-halt
rm $KERNELDIR/arch/arm/boot/dts/*.dtb
make -j3 || exit 1
mv .git-halt .git
$KERNELDIR/scripts/dtbtool_agni -s 2048 -o $KERNELDIR/BUILT_kenzo-cm-mm/dt_led_goodix.img -p $KERNELDIR/scripts/dtc/ $KERNELDIR/arch/arm/boot/dts/
git apply -R led.patch && echo "   LED Patch Cleaned UP."
git apply -R goodix.patch && echo "   Goodix Patch Cleaned UP."
rm $KERNELDIR/arch/arm/boot/dts/*.dtb
rm $KERNELDIR/arch/arm64/boot/Image
rm $KERNELDIR/arch/arm64/boot/Image.gz
rm $KERNELDIR/arch/arm64/boot/Image.gz-dtb

echo "AGNi pureCM-MM has been built for kenzo !!!"


