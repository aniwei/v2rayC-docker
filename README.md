# v2rayClient-Docker
### 基于docker封装的v2ray客户端

⚜整合privoxy和v2ray到一个容器内,适合Liunx部署v2ray客户端,通过privoxy将ftp,https等流量转为socket流量,转发到v2ray客户端,达到代理的效果.尤其适合Linux字符界面部署.

✨构建日期:2019年12月31日,

🔊内部使用v2ray官方提供的脚本构建,所以每次使用此Dockerfile构建既为最新版v2ray.

镜像大小:69M 左右.

## 镜像用法

### 构建镜像

获取仓库:

`git clone https://github.com/amColinzzz/docker-images.git`

进入目录:

`cd docker-images/v2rayC-docker`

执行编译命令:

```shell
docker build . \
   -t icolin/v2rayc
```

### 获取镜像

`docker pull icolin/v2rayc`

### 复制配置文件

首次运行的时候,运行一个临时容器,并将配置文件复制到宿主机内:

```shell
#临时后台运行
docker run --name v2rayc \
  -itd \
  icolin/v2rayc \
  /bin/sh && \
#复制配置文件
docker cp v2rayc:/etc/v2ray /dockerData/v2rayc && \
docker cp v2rayc:/etc/privoxy /dockerData/privoxy && \
#删除临时容器
docker rm -f v2rayc
```

### 正式运行容器

将宿主机内的配置文件修改好以后,可以执行正式运行容器的命令,注意,这里的网络使用的宿主机网络;

```shell
docker run --name v2rayc \
    --network=host \
    --restart=always \
    -v /dockerData/v2rayc:/etc/v2ray \
    -v /dockerData/privoxy:/etc/privoxy \
    -d \
    icolin/v2rayc
```

容器运行之后,privoxy监听8118端口,v2ray监听1080端口(socks),这里要做的就是将终端命令全部转发到8118端口,而privoxy代理的8118端口会将所有流量转为socks协议并转发到v2ray坚挺的1080端口.

### 配置环境变量

配置终端代理,这里使用的是永久生效的方法,如果要取消终端代理,手动编辑~/.bashrc,删除下面内容即可.

```shell
echo -e \
"export http_proxy="http://127.0.0.1:8118"\n"\
"export https_proxy="http://127.0.0.1:8118"\n"\
"export ftp_proxy="http://127.0.0.1:8118"\n"\
>> ~/.bashrc \
&& source ~/.bashrc
```

