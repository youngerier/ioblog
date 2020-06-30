---
title: android-设备标识
date: 2020-06-18 20:38:32
tags: android
---
### IMEI （手机的身份证号码）
`Android 10 ` *获取不到*
`IMEI`(International Mobile Equipment Identity)是国际移动设备身份码的缩写,国际移动装备辨识码,是由15位数字组成的 `电子串号` ,它与每台移动电话机一一对应,而且该码是全世界唯一的。每一只移动电话机在组装完成后都将被赋予一个全球唯一的一组号码,这个号码从生产到交付使用都将被制造生产的厂商所记录。

有些设备的IMEI有两个,可以在拨号键盘输入 `*#06#` 查看。普通APP获取需要申请权限(): 

### 2.IMSI （SIM卡的身份证号码）
`IMSI` 是区别移动用户的标志,储存在 `SIM`卡中,可用于区别移动用户的有效信息。其总长度不超过15位,同样使用0～9的数字,例如460010280100023。其中MCC是移动用户所属国家代号,占3位数字,中国的 `MCC` 规定为 `460`,`MNC` 是移动网号码,最多由两位数字组成,用于识别移动用户所归属的移动通信网,MSIN是移动用户识别码,用以识别某一移动通信网中的移动用户,

```
android.os.Build.BRAND: 获取设备品牌
android.os.Build.MODEL : 获取手机的型号 设备名称。
android.os.Build.MANUFACTURER:获取设备制造商
android.os.Build.BOARD: 获取设备基板名称
android.os.Build.BOOTLOADER:获取设备引导程序版本号
android.os.Build.CPU_ABI: 获取设备指令集名称（CPU的类型）
android.os.Build.CPU_ABI2: 获取第二个指令集名称
android.os.Build.DEVICE: 获取设备驱动名称
android.os.Build.DISPLAY: 获取设备显示的版本包（在系统设置中显示为版本号）和ID一样
android.os.Build.FINGERPRINT: 设备的唯一标识。由设备的多个信息拼接合成。
android.os.Build.HARDWARE: 设备硬件名称,一般和基板名称一样（BOARD）
android.os.Build.HOST: 设备主机地址
android.os.Build.ID:设备版本号。
android:os.Build.PRODUCT: 整个产品的名称
android:os.Build.RADIO: 无线电固件版本号,通常是不可用的 显示unknown
android.os.Build.TAGS: 设备标签。如release-keys 或测试的 test-keys 
android.os.Build.TIME: 时间
android.os.Build.TYPE:设备版本类型  主要为"user" 或"eng".
android.os.Build.USER:设备用户名 基本上都为android-build
android.os.Build.VERSION.RELEASE: 获取系统版本字符串。如4.1.2 或2.2 或2.3等
android.os.Build.VERSION.CODENAME: 设备当前的系统开发代号,一般使用REL代替
android.os.Build.VERSION.INCREMENTAL: 系统源代码控制值,一个数字或者git hash值
android.os.Build.VERSION.SDK: 系统的API级别 一般使用下面大的SDK_INT 来查看
android.os.Build.VERSION.SDK_INT: 系统的API级别 数字表示
```