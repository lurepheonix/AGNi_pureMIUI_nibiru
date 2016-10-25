#!/bin/sh
export KERNELDIR=`readlink -f .`
cd $KERNELDIR;

TEMP_DIR=$KERNELDIR/../TEMP_KENZO_BUILDS_RUN_STORE
mkdir -p $TEMP_DIR
rm -rf BUILT_kenzo BUILT_kenzo-cm-mm .config

echo "-----------------------------------------------------------------------"
echo " "
echo "          BATCH MODE: Building all AGNi MM variants..."
# AGNI pureMIUI-MM
./build_kernel_kenzo.sh
mv -f $KERNELDIR/BUILT_kenzo $TEMP_DIR
rm .config

echo "-----------------------------------------------------------------------"
echo " "

# AGNI pureCM-MM
./build_kernel_kenzo_cm_mm.sh
mv -f $KERNELDIR/BUILT_kenzo-cm-mm $TEMP_DIR
rm .config

mv -f $TEMP_DIR/* $KERNELDIR
rm -rf $TEMP_DIR
echo " "
echo "          BATCH MODE: Built all AGNi MM variants !!!"
echo "-----------------------------------------------------------------------"

