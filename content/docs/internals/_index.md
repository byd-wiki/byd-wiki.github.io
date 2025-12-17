---
title: FW internals
weight: 20
next: /doc/internals/sdk
---

## Исследование прошивок BYD

Прошивки поставляются в виде zip-архива и именуются по следующему алгоритму:

`Di5.0_23.1.22.2505209.1_0.zip`

- `Di5.0` - версия DiLink
- `23` - чипсет (основная версия)
- `1.22` - чипсет (доп. версия)
- `2505` - дата прошивки в формате *ГГММ* (год, месяц)
- `209.1` - версия прошивки

Содержимое архива с прошивкой:

{{< filetree/container >}}
  {{< filetree/folder name="META-INF" >}}
    {{< filetree/folder name="com" >}}
        {{< filetree/folder name="android" >}}
            {{< filetree/file name="otacert" >}}
        {{< /filetree/folder >}}
    {{< /filetree/folder >}}
  {{< /filetree/folder >}}
  {{< filetree/folder name="anc" >}}
    {{< filetree/file name="anc_*.xcd" >}}
    {{< filetree/file name="anc_*.xcd.txt" >}}
  {{< /filetree/folder >}}
  {{< filetree/file name="config" >}}
  {{< filetree/file name="dspres_*.xcd" >}}
  {{< filetree/file name="dspres_*.xcd.txt" >}}
  {{< filetree/file name="mcu_*.xcd" >}}
  {{< filetree/file name="mcu_*.xcd.txt" >}}
  {{< filetree/file name="metadata" >}}
  {{< filetree/file name="update.zip" >}}
{{< /filetree/container >}}

Содержимое файла update.zip:

{{< filetree/container >}}
  {{< filetree/folder name="META-INF" >}}
    {{< filetree/folder name="com" >}}
        {{< filetree/folder name="android" >}}
            {{< filetree/file name="metadata" >}}
            {{< filetree/file name="metadata.pb" >}}
            {{< filetree/file name="otacert" >}}
        {{< /filetree/folder >}}
    {{< /filetree/folder >}}
  {{< /filetree/folder >}}
  {{< filetree/file name="apex_info.pb" >}}
  {{< filetree/file name="care_map.pb" >}}
  {{< filetree/file name="payload.bin" >}}
  {{< filetree/file name="payload_properties.txt" >}}
{{< /filetree/container >}}


## payload.bin

Распаковать `payload.bin` можно с помощью утилиты [payload-dumper-go](https://github.com/ssut/payload-dumper-go) или других (см. ниже).

Состав `payload.bin`:

```shell
abl.img            # ELF 32-bit LSB executable, ARM
aop.img            # ELF 32-bit LSB executable, ARM
bluetooth.img      # DOS/MBR boot sector
boot.img           # Android bootimg
cpucp.img          # ELF 32-bit LSB executable, UCB RISC-V, RVC, soft-float ABI
devcfg.img         # ELF 64-bit LSB executable, ARM
dsp.img            # Linux rev 1.0 ext4 filesystem data
dtbo.img           # Device tree blob for overlay
featenabler.img    # ELF 64-bit LSB shared object, ARM
hyp.img            # ELF 64-bit LSB shared object, ARM
imagefv.img        # ELF 32-bit LSB executable, ARM
keymaster.img      # ELF 64-bit LSB shared object, ARM
modem.img          # DOS/MBR boot sector
multiimgoem.img    # ELF 32-bit LSB no file type, ARM
odm.img            # Linux rev 1.0 ext2 filesystem data
product.img        # Linux rev 1.0 ext2 filesystem data
qupfw.img          # ELF 32-bit LSB executable, QUALCOMM DSP6
shrm.img           # ELF 32-bit LSB executable, Tensilica Xtensa
system_ext.img     # Linux rev 1.0 ext2 filesystem data
system.img         # Linux rev 1.0 ext2 filesystem data
tz.img             # ELF 64-bit LSB executable, ARM
uefisecapp.img     # ELF 32-bit LSB shared object, ARM
vbmeta.img         # data
vbmeta_system.img  # data
vendor_boot.img    # data
vendor.img         # Linux rev 1.0 ext2 filesystem data
xbl_config.img     # ELF 64-bit LSB executable, AT&T WE32100
xbl.img            # ELF 64-bit LSB executable, ARM
```

Подробнее про флеш-память и файловую систему Android см. по ссылке: [Справочник по флеш-памяти на Android](https://4pda.to/forum/index.php?showtopic=1082241).

Универсальные утилиты для распаковки `payload.bin` и разделов (`*.img`) внутри него: 
- avbroot - https://github.com/chenxiaolong/avbroot
- Android_boot_image_editor - https://github.com/cfig/Android_boot_image_editor

Распаковка `*.img` - [7-zip](https://www.7-zip.org/).


## Распаковка прошивки

Приведенный ниже скрипт позволяет полностью распаковать прошивку. Для работы требуется установить [7-zip](https://www.7-zip.org/), положить исполняемый файл [avbroot](https://github.com/chenxiaolong/avbroot) и файл с прошивкой (`*.zip`) рядом со скриптом.

Скачать скрипт: [byd_unpack.sh](./byd_unpack.sh)

Запуск: `bash byd_unpack.sh FIRMWARE_FILE.zip`

{{% details title="Листинг byd_unpack.sh" closed="true" %}}
```bash
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

rm -f ${FW_DIR}/{update.zip,payload.bin,payload.toml,abl.img,aop.img,bluetooth.img,cpucp.img,devcfg.img,dtbo.img,featenabler.img,hyp.img,imagefv.img,keymaster.img,modem.img,multiimgoem.img,qupfw.img,shrm.
img,tz.img,uefisecapp.img,vbmeta*.img,xbl_config.img,xbl.img}

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
```
{{% /details %}}


### Сравнение прошивок

Пример команд для получения списка измененных файлов:

```bash
# список измененных приложений (*.apk) - в файл diff_apk.txt
# DIR1, DIR2 - папки с распакованными прошивками
diff -qrN -x "*.sha256" -x "*.rcc" -x "*.odex" -x "*.vdex" -x "*.ko" -x "*.so" -x "*.bin" DIR1/ DIR2/ | grep .apk | awk '{{ print $4 }}' > diff_apk.txt

# список других измененных файлов (кроме приложений) - в файл diff_other.txt
diff -qrN -x "*.sha256" -x "*.rcc" -x "*.odex" -x "*.vdex" -x "*.ko" -x "*.so" -x "*.bin" -x "*.apk" DIR1/ DIR2/ | awk '{{ print $4 }}' > diff_other.txt
```
