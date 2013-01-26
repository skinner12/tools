#!/tmp/busybox sh
cd /tmp
mkdir ramdisk
cd ramdisk
/tmp/busybox gzip -dc ../boot.img-ramdisk.gz | /tmp/busybox cpio -i
if [ -z `/tmp/busybox grep init.d init.rc` ]; then
echo '' >>init.rc
echo '# Execute files in /etc/init.d before booting' >>init.rc
echo 'service userinit /system/xbin/busybox run-parts /system/etc/init.d' >>init.rc
echo '    oneshot' >>init.rc
echo '    class late_start' >>init.rc
echo '    user root' >>init.rc
echo '    group root' >>init.rc
fi

if [ -z `/tmp/busybox grep mtp init.herring.usb.rc` ]; then
/tmp/busybox echo -e "\non property:sys.usb.config=mtp\n"\
"     write /sys/class/android_usb/android0/enable 0\n"\
"     write /sys/class/android_usb/android0/idVendor 04e8\n"\
"     write /sys/class/android_usb/android0/idProduct 685c\n"\
"     write /sys/class/android_usb/android0/functions \$sys.usb.config\n"\
"     write /sys/class/android_usb/android0/enable 1\n"\
"     setprop sys.usb.state \${sys.usb.config}\n\n"\
"on property:sys.usb.config=mtp,adb\n"\
"     write /sys/class/android_usb/android0/enable 0\n"\
"     write /sys/class/android_usb/android0/idVendor 04e8\n"\
"     write /sys/class/android_usb/android0/idProduct 6860\n"\
"     write /sys/class/android_usb/android0/functions \$sys.usb.config\n"\
"     write /sys/class/android_usb/android0/enable 1\n"\
"     start adbd\n"\
"     setprop sys.usb.state \${sys.usb.config}\n\n"\
"on property:sys.usb.config=ptp\n"\
"     write /sys/class/android_usb/android0/enable 0\n"\
"     write /sys/class/android_usb/android0/idVendor 04e8\n"\
"     write /sys/class/android_usb/android0/idProduct 6865\n"\
"     write /sys/class/android_usb/android0/functions \$sys.usb.config\n"\
"     write /sys/class/android_usb/android0/enable 1\n"\
"     setprop sys.usb.state \${sys.usb.config}\n\n"\
"on property:sys.usb.config=ptp,adb\n"\
"     write /sys/class/android_usb/android0/enable 0\n"\
"     write /sys/class/android_usb/android0/idVendor 04e8\n"\
"     write /sys/class/android_usb/android0/idProduct 6866\n"\
"     write /sys/class/android_usb/android0/functions \$sys.usb.config\n"\
"     write /sys/class/android_usb/android0/enable 1\n"\
"     start adbd\n"\
"     setprop sys.usb.state \${sys.usb.config}\n\n" >> init.herring.usb.rc
fi 
/tmp/busybox sed -i 's/msm_camera\/\*.*system.*system/msm_camera\/\*         0660   system     camera/g' ./ueventd.rc
/tmp/busybox sed -i 's/ro.allow.mock.location=0/ro.allow.mock.location=1/g' ./default.prop
/tmp/busybox sh -c "/tmp/busybox find . | /tmp/busybox cpio -o -H newc | /tmp/busybox gzip > ../boot.img-ramdisk-new.gz"
cd ../
