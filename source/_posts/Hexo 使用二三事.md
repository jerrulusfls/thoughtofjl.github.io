---
title: Hexo 使用二三事
tags:
  - 经验
date: 2017/6/23

---


描述了一些 Hexo 使用时遇到的坑。
<!-- more -->


## Hexo init 卡死问题
其实写这篇文章的时候，命令`hexo init`已经执行了快4个小时了，然而并没有任何动静。于是我决定写一个解决此问题的记录，顺便熟悉一下新笔记本的键盘。

### 卡死的主要位置
1. landscape 主题的下载 （其实耐心等一下很快就过去了）
2. fetchMetadata（就是这里卡死了！）

### 策略
主要问题在于 `fetchmetadata` 一步需要从 npm 服务器上拉 npm 包回来，而由于众所周知的原因这步十分缓慢，因此可以将1、2两步分开操作，第2步用淘宝的国内 npm 源进行加速，很快就会有所缓解。

### 解决方法
首先进行命令 `hexo init blog --no-install`
构建完成后 `cd blog`
**重点** `npm install -g cnpm --registry=https://registry.npm.taobao.org`
然后再进行 `cnpm install`
就可以了

## Next 主题安装
在 `init` 过程中我们已经见识了国内访问 Github 之慢，因此在这里建议直接下载 Next 主体的源代码（zip格式），然后解压至 `themes\next` 文件夹下即可，此法可避免无谓等待。

## 站点配置文件中中文乱码
`_config.yml`文件中输入中文，构建完成后乱码。这个简单，是编码问题，将编码改为 `UTF-8` 即可解决。

## 主页直接输出全文而非摘要
可选方法
1. 自动分割（不推荐）：在主题配置文件中修改`auto_excerpt`项，将值改为`ture`即可
2. 手动分割（推荐）：在文章中需要作为摘要的部分后手动添加`<!-- more -->`（注意需要换行）

## 双标题问题
在写文章时不用# 直接将标题写在`title`里面就好了。

## 部署
虽然大部分人会直接选择`hexo deploy`，但出于某些奇怪的原因，我的 hexo 一直在报错。事实上生成的直接就是静态的 html 文件，只需要将它上传到 Github 或者是其他服务器就可以了，因此可以使用任何你熟悉的方法，如 FTP/Git 等。
在这里，我使用了 GitHub 的桌面客户端`GitHub Desktop`部署，反正界面是图形化的，用起来也很方便。
太刺激了，安装过程中可以把 i5 CPU 占满，风扇狂转，这客户端真的没问题？
> 附注：经过后来测试，在push时无法设定proxy，导致push卡死，且占CPU，推荐用自带GUI进行部署。

## Git clone 非常慢
原因众所周知，在这里只需要调整 Git 的`proxy`设定项即可
```
git config --global http.proxy 'socks5://127.0.0.1:1080'
git config --global https.proxy 'socks5://127.0.0.1:1080'
```
## Git clone 到非空目录
无论是 GUI 还是 Bash，在执行`git clone`时常常遇到错误`目录已存在`，提示`fatal: destination path '.' already exists and is not an empty directory.`
解决方法 [出自](http://www.oschina.net/question/54100_167919)
```
 进入非空目录，假设是 /workdir/proj1
 git clone --no-checkout https://git.oschina.NET/NextApp/platform.git tmp
 mv tmp/.git .   #将 tmp 目录下的 .git 目录移到当前目录
 rmdir tmp
 git reset --hard HEAD
```

## Git 提交时认证失败问题
在用 Git GUI 提交时一直失败，查询后发现问题在于认证失败。

### 认证过程
1. GitHub 网页登录认证（此步正常输入邮箱、账户密码）
2. OpenSSL 认证/ Git GUI 认证（此步先输入**用户名**，再输入**token**）

### 问题所在
在提交时 GitHub 采用全站 HTTPS，因此不可再使用传统的用户名/密码体系登录，而需要`token`作为登录凭据。

### 获取token
[参见](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)

## Next 主题不显示 updated 属性
设定如此。

## Date 属性一定要写上时间吗？
不一定。直接写日期也可以识别。