# Arch 安装配置

## 一.基本安装
## 1.下载镜像

- arch镜像下载地址
  - [http://mirrors.163.com/archlinux/iso/](http://mirrors.163.com/archlinux/iso/)

## 2. 刻录镜像到U盘

- Linux 下使用命令行将 iso 文件刻录到 u 盘

```bash
#查看 U 盘的路径。
sudo fdisk -l

Disk /dev/sda：125 GiB，134217728000 字节，262144000 个扇区
磁盘型号：UDisk   
单元：扇区 / 1 * 512 = 512 字节
扇区大小(逻辑/物理)：512 字节 / 512 字节
I/O 大小(最小/最佳)：512 字节 / 512 字节
磁盘标签类型：dos
磁盘标识符：0x00000000

设备       启动    起点    末尾    扇区 大小 Id 类型
/dev/sda1  *         64 6300795 6300732   3G  0 空
/dev/sda2       6300796 6308987    8192   4M ef EFI (FAT-12/16/32)


#if 后面是 Arch 镜像文件的路径 of 后面是 U 盘的路径 
#bs=4M 指定一个较为合理的文件输入输出块大小。
#status=progress 用来输出刻录过程总的信息。
#oflag=sync 用来控制写入数据时的行为特征。确保命令结束时数据及元数据真正写入磁盘，而不是刚写入缓存就返回。
sudo dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync
#等待刻录完成。
```

## 3.以 U 盘的形式启动电脑

- 每个电脑进入 BIOS 的方式不同，根据自己的实际情况 自行 Google 。
## 4.检测是否以 UEFI 模式启动
```bash
 ls /sys/firmware/efi/efivars
```
若有目录显示出来，则是以 UEFI 模式启动的。
## 5.连接网络
wifi连接:
```bash 
#进入无线连接交互模式
iwctl  
#列出网卡名称
device list 
#扫描网络
station wlan0 scan 
#获取网络名称列表
station wlan0 get-networks 
 #进行连接 输入密码
station wlan0 connect [ WIFI名称 ]
# 输入密码
*********
exit #退出
```
## 6.测试网络
```bash
ping www.baidu.com
```
若有数据返回，则说明联网成功了，`Ctrl+c`结束当前命令
## 7.更新系统时钟
```bash
#将系统时间与网络时间同步
timedatectl set-ntp true 
 #查看同步状态
timedatectl status
System clock synchronized: yes                       
              NTP service: active                    
          RTC in local TZ: no 
```
`System clock synchronized` 为 `yes` 和 `NTP service` 为 `active` 则表示同步成功。
#### 8.更换国内镜像源，提升下载速度
```bash
vim /etc/pacman.d/mirrorlist                
## Arch Linux repository mirrorlist
## Generated on 2020-12-05
#阿里云镜像源
Server = https://mirrors.aliyun.com/archlinux/$repo/os/$arch 
#中科大镜像源
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch 
#网易镜像源
Server = https://mirrors.163.com/archlinux/$repo/os/$arch 
## Worldwide
...
```
将以上三个镜像源添加到文件最前面, `j`将光标移动到空行,`i`进入插入模式，输入镜像源，`<Esc>` , 返回正常模式`:wq`(冒号)wq 保存退出。
## 9. 分区
- 根目录: 10G `系统目录 使用镜像源下载的软件都会放在系统目录下，若需要下载比较多的软件，建议多分一点。`
- EFI 目录: 500M 的引导目录
- swap 分区: `交换分区,一般为运行内存大小的一半，如果内存超过8G ，建议分为内存大小+2G 的大小`
- home 目录: 越大越好。`/home` `存放自己下载的软件，资料等，相当于 WIN 中的文件盘`
```bash
#查看分区
fdisk -l 

设备                起点       末尾       扇区  大小 类型
/dev/nvme0n1p1      2048    1026047    1024000  500M EFI 系统
/dev/nvme0n1p2   1026048   38774783   37748736   18G Linux swap
/dev/nvme0n1p3  38774784  862955519  824180736  393G Linux 文件系统
/dev/nvme0n1p4 862955520 1953525134 1090569615  520G Linux home

# 进入磁盘进行分区
#如果是固态硬盘会显示nvme... 如果是普通硬盘，则会是sda...
cfdisk /dev/nvme0n1 
----------------------------
新建分区(NEW) 
输入分区大小：500M <Enter>
类型(TYPE) EFI System
----------------------------
新建分区(NEW)
输入分区大小：8G <Enter>
类型(TYPE) swap
----------------------------
新建分区(NEW) 
输入分区大小：50G <Enter>
类型(TYPE) Linux System
----------------------------
新建分区(NEW)
输入分区大小：200G <Enter>
类型(TYPE) Linux home
----------------------------
写入(WRITE)
确认(yes)
退出(EXIT)
```
## 10.格式化分区
```bash
#查看分区
fdisk -l 

设备                起点       末尾       扇区  大小 类型
/dev/nvme0n1p1      2048    1026047    1024000  500M EFI 系统
/dev/nvme0n1p2   1026048   38774783   37748736   18G Linux swap
/dev/nvme0n1p3  38774784  862955519  824180736  50G Linux 文件系统
/dev/nvme0n1p4 862955520 1953525134 1090569615  200G Linux home

#将根目录和 home 目录格式化成ext4
mkfs.ext4 /dev/nvme0n1p3
mkfs.ext4 /dev/nvme0n1p4
#格式化 EFI 分区
mkfs.vfat /dev/nvme0n1p1
#格式化 swap 分区
mkswap -f /dev/nvme0n1p2 
swapon /dev/nvme0n1p2 
```
## 11.挂载分区
```bash
mount /dev/nvme0n1p3 /mnt
mkdir /mnt/home
mount /dev/nvme0n1p4  /mnt/home
mkdir -p /mnt/boot/EFI
mount /dev/nvme0n1p1  /mnt/boot/EFI
```
## 12.安装系统
```bash
# base linux linux-firmware 基本的linux系统
# dhcpcd iwd 用来联网
# vim sudo  vim 编辑器  sudo 用来提权
# grub efibootmgr 引导程序
pacstrap  /mnt  base linux linux-firmware dhcpcd iwd  vim sudo grub efibootmgr 
# genfstab 生成磁盘分区文件
genfstab -U /mnt >> /mnt/etc/fstab
# 查看文件是否生成成功
cat /mnt/etc/fstab

# /dev/nvme0n1p3
UUID=a8ce7c96-2a61-4d2b-8cb5-1644b36f5374       /               ext4            rw,relatime    0 1

# /dev/nvme0n1p1
UUID=96EF-351F          /boot/EFI       vfat            rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro   0 2

# /dev/nvme0n1p4
UUID=0e5f96c6-427f-4437-b2a0-b25da92d6033       /home           ext4            rw,relatime    0 2

# /dev/nvme0n1p2
UUID=9a6fd4c4-4235-4658-b46a-2862e2c9f24c       none            swap            defaults       0 0

```

## 系统的基本配置

1. 切换到刚刚安装的系统
```bash
arch-chroot /mnt
```
2. 开启联网服务
```bash 
#网线
systemctl enable dhcpcd
systemctl start dhcpcd
# wifi 
systemctl enable iwd
systemctl start iwd
```
3. 编辑 pacman.conf 设置 archlinuxcn 源

```bash
vim /etc/pacman.conf
```
- 在最后面添加
```conf
[multilib]
Include = /etc/pacman.d/mirrorlist

# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
[archlinuxcn]
SigLevel = Optional TrustAll
Server =  https://mirrors.aliyun.com/archlinuxcn/$arch 
```
4. 设置时区

```bash
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```
5. 同步系统时间

```bash
hwclock --systohc
```
6. 设置语言
```bash
#编辑 /etc/locale.gen
vim /etc/locale.gen
#搜索 en_US.UTF-8 UTF-8 和 zh_CN.UTF-8 UTF-8
#取消它们的注释
# 执行 logale.gen 生成编码
locale-gen
```

7. 创建 locale.conf 文件
```bash
echo "LANG=en_US.UTF-8" > /etc/loacle.conf
```
8. 创建 hosts
```hosts
vim /etc/hosts
#写入
127.0.0.1	localhost
::1		localhost
127.0.1.1	[自定义主机名].localdomain  [自定义主机名]
```
9. 设置 root 密码

```bash
passwd root
# 输入密码
# 确认密码
```

10 安装 ucode 
```bash
#  Intel cpu  安装 intel-ucode 
pacman -S intel-ucode

# AMD cpu 安装 amd-ucode
#pacman -S amd-ucode
```

11 配置引导程序

```bash

grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg
```

12 退出系统，并重启

```bash

# 退出系统
exit 

# 卸载 mount 
umount -R /mnt

reboot
```


## 创建用户 配置图形化界面


-  配置ssh

```bash
sudo pacman -S openssh
ssh-keygen -t rsa -C "your_email@example.com"
```
