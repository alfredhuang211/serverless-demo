# 使用 SCF 无服务器云函数定时备份数据库

最近有客户询问到使用云函数进行数据库导出备份时的一些问题，在此也进行一下总结，描述如何使用云函数来进行数据库备份。

数据库备份通常是 DBA 每天要进行的工作。对数据库进行备份，可以在数据错误，数据库异常等有需要时及时进行数据回滚。最常用的方式，就是使用 crontab 定时任务，每日调用备份脚本进行数据库备份。而在备份脚本中，通常最方便使用的，就是 mysqldump 工具，导出表结构及表数据。

接下来，我们将利用云函数，实现数据库备份能力，然后通过配置定时触发器，确保备份函数可以按需每天、或按指定间隔时间运行。

## mysqldump 准备

常用来导出数据库备份数据的的 mysqldump 工具，在云函数中也同样能使用；但是由于云函数环境并未内置 mysqldump，因此我们要自行打包工具。

通过 [mysql 社区版下载地址](https://dev.mysql.com/downloads/mysql/)，我们选择操作系统为 `Linux - geneic`，选择操作系统版本为 `（x86，64-bit）`，下载 tar.gz 压缩包并存储在本地。下载完成后，解压压缩包，可以看到解压后的文件夹内包含有 bin、lib 等目录；而我们要找到的 mysqldump 工具就在 bin 目录下。同时可以看到 bin 目录下还有 libcrytpo.so.1.0.0 和 libssl.so.1.0.0 两个动态库。这两个库也是工具在运行时所要依赖的库，但在 bin 下的这两个文件实际为文件链接，实际指向分别是 ../lib/libcrypto.so.1.0.0 和 ../lib/libssl.so.1.0.0，因此这两个真实文件是在 lib 目录下。因此，为了确保
mysqldump 工具可以运行成功，我们将 bin 目录下的 mysqldump 文件拷贝到我们提前准备的项目根目录下，同时将 lib 目录下的 libcrypto.so，libcrypto.so.1.0.0，libssl.so，libssl.so.1.0.0 四个文件也拷贝到项目根目录下。

由于拷贝出来的 mysqldump 和 so 动态库文件是 Linux 版本，如果需要验证可用性，我们可以将准备好的项目目录拷贝到一台 Linux 服务器上，通过运行 mysqldump 命令验证工具的可用性。

```
./mysqldump -h {host} -P {port} -u{user} -p{password} {dbName} > dump.sql
```

使用如上命令，就可以将数据库内某一个具体的库导出到对应的 sql 文件内，我们可以通过命令运行时的输出，和导出文件的内容，判断是否运行成功。

## 云函数准备

接下来，我们来准备好需要定时运行的云函数。此处云函数的主要功能，就是在每一次运行时，调用上一步骤中我们准备好的 mysqldump 工具，来连接远程数据库并在本地生成 dump 文件。由于云函数的本地环境中不提供持久存储，生成的 dump 文件，需要上传到对象存储中做持久化，并在所需要的时候可以下载使用。

我们在这里使用 python 2.7 作为开发语言，在项目根目录下创建 index.py 文件，并在文件内输入如下内容并保存。

```
#coding=utf-8

import os
from qcloud_cos import CosConfig
from qcloud_cos import CosS3Client
import sys
import logging
import time

logging.basicConfig(level=logging.INFO, stream=sys.stdout)


DB_HOST = os.getenv('dbhost') #'sh-cdb-irye027y.sql.tencentcdb.com'
DB_PORT = os.getenv('dbport') #'63374'
DB_USER = os.getenv('dbuser') #'root'
DB_USER_PASSWORD = os.getenv('dbpwd') #'abc123!@#'
DB_NAME = os.getenv('dbname') #'cAuth'

BACKUP_PATH = '/tmp'

SECRET_ID = os.getenv('secretid') #'AKIDQm6iUh2NJ6jL41tVUis9KpY5Rgv49zyC'
SECRET_KEY = os.getenv('secretkey') #'xxxlbNyQo4EMJ5jPGA7sUvHWaSAlxxxxx'
REGION = os.getenv('cosregion') #'ap-shanghai'
BACKUP_BUCKET = os.getenv('cosbucket') #"dbbackup-1253970226"

config = CosConfig(Secret_id=SECRET_ID, Secret_key=SECRET_KEY, Region=REGION, Token="")
client = CosS3Client(config)


def backup2cos(file, bucket, key):
    response = client.put_object_from_local_file(
        Bucket=bucket,
        LocalFilePath=file,
        Key=key,
    )
    print(response)
    return response

def main_handler(event, context):
    timestr = time.strftime('%Y%m%d-%H%M%S', time.localtime(time.time()))
    db = DB_NAME
    filename = db+"-"+timestr+".sql"
    filepath = BACKUP_PATH+os.sep+filename
    print "Start Backup"
    dumpcmd = "./mysqldump -h " + DB_HOST + " -P " + DB_PORT + " -u" + DB_USER + " -p'" + DB_USER_PASSWORD + "' " + db + " > " + filepath
    print dumpcmd
    print os.popen(dumpcmd).read()
    print "Backup script completed"
    print "Your backups has been created in '" + filepath + "' file"
    print os.popen('ls -l /tmp').read()
    print "finish backup"
    print "start send to cos"
    backup2cos(filepath,BACKUP_BUCKET,"/"+filename)
    print "finish send to cos"

if __name__ == "__main__":
    main_handler("","")

```

在代码中，我们使用到了 COS 的 v5 版本 sdk 进行备份后的文件上传操作，因此我们需要安装好依赖便于脚本调用。我们可以在项目根目录通过执行 `pip install cos-python-sdk-v5 -t .` 命令，来将 cos 的 python sdk 以及相关依赖安装到项目目录中。

## 云函数打包及创建

在我们完成以上几部操作以后，我们在项目目录里有了 mysqldump 工具及依赖的 so 库，有了 cos sdk 及依赖包，以及我们的入口函数文件 index.py。接下来我们就需要将项目文件打包为 zip 格式以便上传至云函数，完成函数创建。

### 部署包打包

由于项目目录下的 mysqldump 工具作为二进制程序，需要在云函数的环境中运行，因此需要具有可执行权限，需要在 Linux 或 Mac 环境下为此文件赋予可执行权限后再打包，因此建议在 Linux 或 Mac 环境下执行打包。

我们可以将项目目录放置到 Linux 或 Mac 环境下后，通过在项目目录下执行 `chmod +x mysqldump` 命令，为 mysqldump 工具附加上可执行权限。

完成附加权限后，可以继续在根目录下通过执行 `zip mysqldump.zip *` 命令，将所有文件打包到 mysqldump.zip 内，生成可以用于创建函数的 zip 包。

### 创建及配置函数

通过如上步骤创建的 zip 包，由于体积稍大，需要通过对象存储 COS 的方式上传。因此我们先准备好 COS 的存储桶。我们需要在特定地域创建两个存储桶，一个用于上传及更新函数代码使用，一个用于存储备份的 mysql dump 文件。两个存储桶分别命名为 codefile 和 dbbackup。

然后我们将上一步创建的 zip 包，上传到 codefile 根目录中，作为函数创建时的代码来源。

接下来。我们开始创建函数，在特定地域下创建名为 mysqldump 的函数，运行环境选择为 python2.7，超时时间可配置为 60 秒。接下来上传代码的位置，选择为从 COS 上传代码，选择 codefile 存储桶，并指定代码文件为 /mysqldump.zip，同时入口函数为 index.main_handler，与 index.py 文件中的 main_handler 函数对应。

同时，由于我们代码中的数据库相关配置，COS 读写相关配置，均从环境变量中读取的，因此我们也需要对函数配置上所需的环境变量，配置包括 dbhost，dbport，dbuser，dbpwd，dbname，secretid，secretkey，cosregion，cosbucket 的环境变量对应的值，使用具体的数据连接信息以及对应的 COS 读写认证相关的信息。

配置完成后，我们就完成了函数的创建。

### 测试及启动函数

完成函数创建后，我们就可以来测试下函数的运行情况，并完成最终的定时触发配置。

通过控制台右上角的测试按键，我们可以直接触发函数的运行。通过函数的输出日志，我们可以查看代码的运行情况，检查 dump 文件是否生成正常，是否成功上传到 COS 存储桶中。同时我们也可以到对应的备份存储桶中，查看生成的文件，检查是否数据正确，备份正常。

确认函数测试运行正常后，我们就可以在触发器中，为函数新增一个定时触发器了。我们可以根据自身需要，配置为每天，或每12小时，或每月的指定时间运行。定时触发器可以按 crontab 格式编写触发时间，既可以按一定时间周期，也可以指定具体时间运行。

## 总结

在这里，我们通过使用 mysqldump 工具，以及对象存储 COS 的 sdk，实现了数据库的按时备份能力。通过使用云函数，我们无需使用虚拟机以及配置 crontab 脚本，就可以实现高可靠的定时运维能力。云函数，以及云函数的定时触发器，在运维过程中可以被广泛使用，实现例如备份、检查、告警、同步等各种能力，这篇文章，仅为大家提供了一种实现的思路，欢迎大家可以在这个思路上继续扩展，并分享在运维过程中使用云函数的经验。