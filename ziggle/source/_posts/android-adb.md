---
title: android-adb
date: 2020-07-09 21:58:43
tags:
- adb
- android
---
`adb install [-l] [-r] [-s] <file>`

- EN push this package file to the device and install it
- CHS 给设备安装软件
   - (`-l` means forward-lock the app) #锁定该程序
   - (`-r` means reinstall the app, keeping its data) #重新安装该程序，保存数据
   - (`-s` means install on SD card instead of internal storage) #安装在SD卡内，而不是设备内部存储

`adb uninstall [-k] <package>`

- EN remove this app package from the device
- CHS 从设备删除程序包
 - (`-k` means keep the data and cache directories) #不删除程序运行所产生的数据和缓存目录(如软件的数据库文件)


### 清除adb logcat 缓存
``` 
 adb logcat -c 
```
### adb 输出指定包的日志 并重定向
```
adb -d logcat com.xx.mm:I *:* | Tee-Object login0713-03.log
```

### dx.bat 

cd MyApplication\app\build\intermediates\javac\debug\classes
build-tools\29.0.3\dx.bat --dex --output=./classes.dex .\com\example\myapplication\ExampleFunction.class

###　链接指定设备

adb connect [ip]
adb disconnect [ip]
adb -s shell 设备id[ip:port]