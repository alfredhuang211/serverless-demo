# 小程序 demo 使用说明


## 项目组成

项目由两部分组成：client 和 faas-node-server，其中 client 为小程序端代码，faas-node-server 为 SCF 端代码。

## 运行概要

小程序 demo 通过使用小程序发起请求，由 API 网关中的 API 接收请求，并触发云函数的执行，云函数完成逻辑处理，数据库操作后返回响应给到小程序。

demo 通过实现用户登录、session 记录功能，使用 API 网关、云函数、CDB 云数据库，完成为小程序提供 API，演示可落地方案。

在这个过程中，用到的云产品会包括：

* API网关
* SCF 云函数
* COS 对象存储
* CDB 云数据库

在使用这些产品的过程中，我们保证所有使用到的均处于一个地域下，例如上海地域。在创建 API 服务，创建云函数，创建对象存储 bucket，创建云数据库实例时，都选择到同一个地域下操作。

## 运行方法

### 1. 准备数据库

通过在腾讯云控制台选择关系型数据库，选取好地域，例如上海区，使用 MySQL 创建实例后，我们需要进行：

1. 数据库初始化
2. 数据库外网开放

#### 数据库初始化

在数据库实例初始化完成可登录后，我们要记住数据库的登录用户名和密码，或额外配置的可操作指定库的用户名及密码，例如记录为：root abc123！@#

通过 PMA 工具进入数据库后，首先创建 DB，可将 DB 命名为 cAuth 。接下来，我们可以使用 faas-node-server 代码目录内的 /tools/init.sql 脚本，完成数据库的表初始化。 脚本将会在数据库内创建 cSessionInfo 表，用于存储后续的用户登录 session 信息。

#### 数据库外网开放

通过在控制台配置实例开启外网访问地址，获得数据库的外网连接地址和端口，例如：sh-cdb-iree027z.sql.tencentcdb.com:63374

### 2. 准备云函数


#### 配置修改

在创建函数，上传代码前，我们首先要完成配置信息修改。通过编辑器打开 faas-node-server 代码目录下的 /config.js 文件，对里面的配置项根据项目实际情况进行修改，修改内容包括：

* appID：小程序 App ID
* APPSecret：小程序 App Secret
* mysql.sh.host：数据库外网连接地址，例如 sh-cdb-iree027z.sql.tencentcdb.com
* mysql.sh.port：数据库外网连接端口，例如 63374
* mysql.sh.db：数据库名，例如 cAuth
* mysql.sh.user：数据库登录用户名，例如 root
* mysql.sh.pass：数据库登录密码，例如 abc123！@#

#### 打包及创建函数

修改完成配置后，进入 faas-node-server 目录，选择全部文件，然后进行压缩操作，生成 zip 格式压缩包，确保压缩包根目录下包含了 index.js 的文件，而不是 faas-node-server 文件夹。压缩包命名假定为 faas-node-server.zip。

在控制台中切换至对象存储，创建一个和数据库同地域的对象存储 Bucket，或直接利用一个已经创建好的 Bucket，利用文件上传操作，将打包好的压缩包上传至 Bucket 根目录。

控制台切换至云函数，创建一个和数据库同地域的云函数，函数名假定为 faas-server，选择 runtime 为 nodejs 6.10。在编辑函数代码的页面，选择通过 COS 上传代码，bucket 列表中选择上一步选择使用的 bucket，对象输入框输入 /fass-node-server.zip。确认完成函数创建。

### 3. 准备 API

在控制台切换到 API 网关服务后，选择一个和上一步中云函数相同的地域，创建 API 服务。

创建完成 API 服务后，切换至服务内的 API 管理，新建 API。API 可命名为 login，路径为 /login，请求方法为 GET，勾选免鉴权，进入下一步。

在后端配置中，选择后端类型为云函数，从函数列表中选择上一步创建的函数 faas-server，继续下一步并完成 API 创建。

API 完成创建后，切换至服务的服务信息页面，发布服务，并选择发布环境。

发布成功后，切换至服务的环境管理页面，记录发布环境的访问路径，例如 service-9wuncko7-1251762227.ap-shanghai.apigateway.myqcloud.com/release

### 4. 准备及调试运行小程序

使用小程序开发者工具，导入项目，并导入 client 文件夹内的代码。

修改 client 文件夹下的 config.js，将 host 变量修改为在准备 API 章节所记录的访问路径，例如 http://service-9wuncko7-1251762227.ap-shanghai.apigateway.myqcloud.com/release

在开发者工具的项目详情页面，勾选 “不校验合法域名...” 选项，确保在调试模式的情况下，可以使用 http 的域名。

保存完成后，可以通过开发者工具的模拟器，点击界面中的 “点击登录” 按钮，查看授权和登录情况。

账号登录后，也可以进入控制台数据库中，查看数据库中新增加的用户 session 记录。


## 总结

此 Demo 仅为演示使用 API网关 + 云函数 + 云数据库 实现小程序后端。更多功能实现可基于此 demo 进行实现开发。
