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

Распаковать `payload.bin` можно с помощью утилиты [payload-dumper-go](https://github.com/ssut/payload-dumper-go):

```shell
payload-dumper-go payload.bin
```

Состав `payload.bin`:

```shell
abl.img            # ELF 32-bit LSB executable, ARM
aop.img            # ELF 32-bit LSB executable, ARM
bluetooth.img      # DOS/MBR boot sector
boot.img           # Android bootimg
cpucp.img          # ELF 32-bit LSB executable, UCB RISC-V, RVC, soft-float ABI
devcfg.img         # ELF 64-bit LSB executable, ARM
dsp.img            # Linux rev 1.0 ext4 filesystem data
dtbo.img           # data
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
