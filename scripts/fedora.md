# Debloat

```shell
sudo dnf remove libreoffice-core yelp abrt gnome-user-docs ibus-libzhuyin ibus-hangul ibus-anthy 
```

# Essential apps

```shell
sudo dnf install gnome-tweaks gnome-extensions-app rpmreaper p7zip-plugins
```

# rpmfusion

```shell
sudo dnf install https://mirrors.ustc.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install @multimedia
```

# flatpak

```shell
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
```

# copr

```shell
sudo dnf copr enable zhullyb/v2rayA
```

# Group apps

```shell
sudo dnf group install --with-optional virtualization
@"C Development Tools and Libraries"
```


# SElinux

```shell
sestatus
vi /etc/selinux/config
reboot
```


# Delete unused kernel

```shell
rpm -q kernel 查询
dnf inatall yum-utils
sudo package-cleanup --oldkernels --count=1 设定想保留的内核数量，自动删除多余内核
```

# Links

<https://littleboyharry.gitee.io/geekbook/>

<https://xsuchy.github.io/rpm-spec-wizard/>

<https://dl.fedoraproject.org/pub/alt/live-respins/>
