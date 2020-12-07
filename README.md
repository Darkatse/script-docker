## 特别声明: 
* 本仓库中的script-docker项目仅仅是为研究脚本运行容器化方式而成，原项目中涉及的任何解锁和解密分析脚本均与darkatse无关。本项目仅用于测试和学习研究，禁止用于商业用途，不能保证其合法性，准确性，完整性和有效性，请根据情况自行判断.

* 本项目内所有资源文件，禁止任何公众号、自媒体进行任何形式的转载、发布。

* darkatse对任何脚本问题概不负责，包括但不限于由任何脚本错误导致的任何损失或损害.

* 间接使用本项目的任何用户，包括但不限于建立VPS或在某些行为违反国家/地区法律或相关法规的情况下进行传播, darkatse 对于由此引起的任何隐私泄漏或其他后果概不负责.

* 请勿将script-docker项目的任何内容用于商业或非法目的，否则后果自负.

* 如果任何单位或个人认为该项目的脚本可能涉嫌侵犯其权利，则应及时通知并提供身份证明，所有权证明，我们将在收到认证文件后删除相关脚本.

* 任何以任何方式查看此项目的人或直接或间接使用该script-docker项目的任何脚本的使用者都应仔细阅读此声明。darkatse 保留随时更改或补充此免责声明的权利。一旦使用并复制了任何相关脚本或script-docker项目的规则，则视为您已接受此免责声明.

 **您必须在下载后的24小时内从计算机或手机中完全删除以上内容.**  </br>
> ***您使用或者复制了本仓库且本人制作的任何脚本，则视为`已接受`此声明，请仔细阅读*** 
  
  
## script-docker
基于docker容器化技术自动化运行脚本，一个容器内可以添加多种不同的仓库，理论上兼容一切基于node/python的GitHub action工作流  
优点  
*  使用容器化技术运行，方便可靠，便于迁移，节省资源
*  一个docker中可执行多个不同仓库，配置灵活
*  每个docker之间互相隔离，天然支持多线程/多账号运行
*  定时同步上游更改，无需担心脚本过时

### 安装依赖
安装docker
```sh
curl -fsSL https://get.docker.com | bash -s docker
#在国内的话请用阿里云镜像
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```
安装git和docker-compose

直接安装
```sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Debian & Ubuntu
```sh
sudo apt update && sudo apt install git docker-compose
```

CentOS
```sh
sudo yum install git docker-compose
```
### 下载
```sh
git clone https://github.com/Darkatse/script-docker
cd script-docker
```

###  配置多仓库环境
* 在scripts文件夹下新建文件，填入你想要执行的仓库地址，格式参照example
* 修改env/env*文件，填入你想要执行的仓库文件名并写入必要的secret值，详细要求参照原仓库要求
* 如果想要推送可以修改env/all文件，注意这个文件的内容对所有docker都生效

### 启动
```sh
docker-compose up --build --force-recreate -d script-docker-1
```
请确保最后的数字与之前编写的环境文件序号一致

### 修改
如果想要对已经建立的docker进行修改，可以执行以下命令进入docker
```sh
docker exec -it script-docker-1 /bin/bash
```
如果发现无文本编辑器可用，请执行
```sh
apt update && apt install nano -y
```
完成编辑后敲入exit即可退出  
或者可以选择重新生成docker，只需重新执行"启动"一栏中的命令即可

### 多账号
使用多容器的方式，好处：
1. 脚本并行
2. 每个账号可以有不同的配置，比如配置微信推送，配置不同的仓库
#### 配置
添加第二个配置：以上所有操作中的`1`替换成`2`, 然后重复之前所有操作。  
超过五个账号需要手动创建./env/env6，修改./docker-compose.yml文件
#### 配置文件说明
所有账号共享的参数需要配置./env/all, 每个账号独立参数需要配置./env/env*，  
每个账号配置的参数会覆盖共享参数，每个账号未配置参数的继承共享的参数

### 其他
- 查看log
```sh
docker-compose logs
```
- 停止
```sh
docker-compose down
```
