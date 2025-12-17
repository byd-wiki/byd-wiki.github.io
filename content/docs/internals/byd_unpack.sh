#!/usr/bin/env bash
if [ -n "$1" ]; then
    FW_FILE=$1
else
    echo "Usage: ./byd_unpack.sh FIRMWARE_FILE.zip"
    exit 0
fi

FW_DIR=$(basename $FW_FILE .zip)

mkdir -p ${FW_DIR}/{product,system,system_ext,vendor/dsp,odm/etc}
7z x ${FW_FILE} -o${FW_DIR} -bso0 update.zip
7z x ${FW_DIR}/update.zip -o${FW_DIR} -bso0 payload.bin
./avbroot payload unpack -i $FW_DIR/payload.bin --output-images $FW_DIR --quiet

rm -f ${FW_DIR}/{update.zip,payload.bin,payload.toml,abl.img,aop.img,bluetooth.img,cpucp.img,devcfg.img,dtbo.img,featenabler.img,hyp.img,imagefv.img,keymaster.img,modem.img,multiimgoem.img,qupfw.img,shrm.img,tz.img,uefisecapp.img,vbmeta*.img,xbl_config.img,xbl.img}

if [ -f "${FW_DIR}/boot.img" ]; then
    ./avbroot boot unpack --input ${FW_DIR}/boot.img --output-header ${FW_DIR}/boot.toml --no-output-kernel --output-ramdisk-prefix ${FW_DIR}/boot_ramdisk.img. --quiet
    7z x -y ${FW_DIR}/boot_ramdisk.img.0 -o${FW_DIR} -aos -bso0
    7z x -y ${FW_DIR}/boot_ramdisk.img -o${FW_DIR} -aos -bso0
    rm -f ${FW_DIR}/{boot.*,boot_ramdisk.img.0,boot_ramdisk.img}
fi

if [ -f "${FW_DIR}/odm.img" ]; then
    ./avbroot avb unpack --input ${FW_DIR}/odm.img --output-info ${FW_DIR}/odm.toml --output-raw ${FW_DIR}/odm.raw --quiet
    7z x -y ${FW_DIR}/odm.raw -o${FW_DIR}/odm -aos -bso0
    rm -f $FW_DIR/odm.{img,raw,toml}
fi

if [ -f "${FW_DIR}/product.img" ]; then
    ./avbroot avb unpack --input ${FW_DIR}/product.img --output-info ${FW_DIR}/product.toml --output-raw ${FW_DIR}/product.raw --quiet
    7z x -y ${FW_DIR}/product.raw -o${FW_DIR}/product -aos -bso0
    rm -f ${FW_DIR}/product.{img,raw,toml}
fi

if [ -f "${FW_DIR}/system.img" ]; then
    ./avbroot avb unpack --input ${FW_DIR}/system.img --output-info ${FW_DIR}/system.toml --output-raw ${FW_DIR}/system.raw --quiet
    7z x -y ${FW_DIR}/system.raw -o${FW_DIR}/system -aos -bso0
    rm -f ${FW_DIR}/system.{img,raw,toml}
fi

if [ -f "${FW_DIR}/system_ext.img" ]; then
    ./avbroot avb unpack --input ${FW_DIR}/system_ext.img --output-info ${FW_DIR}/system_ext.toml --output-raw ${FW_DIR}/system_ext.raw --quiet
    7z x -y ${FW_DIR}/system_ext.raw -o${FW_DIR}/system_ext -aos -bso0
    rm -f ${FW_DIR}/system_ext.{img,raw,toml}
fi

if [ -f "${FW_DIR}/vendor.img" ]; then
    ./avbroot avb unpack --input ${FW_DIR}/vendor.img --output-info ${FW_DIR}/vendor.toml --output-raw ${FW_DIR}/vendor.raw --quiet
    7z x -y ${FW_DIR}/vendor.raw -o${FW_DIR}/vendor -aos -bso0
    rm -f ${FW_DIR}/vendor.{img,raw,toml}
fi

if [ -f "${FW_DIR}/vendor_boot.img" ]; then
    ./avbroot boot unpack --input ${FW_DIR}/vendor_boot.img --output-header ${FW_DIR}/vendor_boot.toml --no-output-kernel --output-ramdisk-prefix ${FW_DIR}/vendor_boot_ramdisk.img. --quiet
    7z x -y ${FW_DIR}/vendor_boot_ramdisk.img.0 -o${FW_DIR} -aos -bso0
    7z x -y ${FW_DIR}/vendor_boot_ramdisk.img -o${FW_DIR} -aos -bso0
    rm -f ${FW_DIR}/{vendor_boot.*,vendor_boot_ramdisk.img.0,vendor_boot_ramdisk.img}
fi

if [ -f "${FW_DIR}/dsp.img" ]; then
    7z x -y ${FW_DIR}/dsp.img -o${FW_DIR}/vendor/dsp -aos -bso0
    rm -f ${FW_DIR}/dsp.img
fi
