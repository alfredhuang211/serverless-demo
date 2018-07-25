# 使用 SCF 无服务器云函数定时拨测站点并邮件告警

利用无服务器架构中提供的定时触发能力，在运维监控场景有很多种用处，例如定时备份、定时拨测、定时统计等。在互联网业务监控运维的场景下，我们通常可以利用定时拨测，检测系统或服务的健康状态，并在系统异常的情况下及时发出告警，避免造成业务中断。

接下来，我们就利用无服务器云函数实现一个简单的拨测脚本，可以定时拨测指定的业务服务，并在异常时发出邮件告警。我们同样通过 Python 来实现函数代码，利用 requests 库发出 http 请求来探查系统的工作情况，并在探查出问题的时候利用 python 自带的 smtplib 邮件发送库发出告警邮件。

## 代码准备

测试脚本比较简单，通过单文件就可以完成。我们可以通过将如下代码保存为 index.py 文件，或者直接将代码复制后粘贴到编辑窗口的方式完成函数创建。

```python
# -*- coding: utf8 -*-
import json
import logging
import requests
from email.mime.text import MIMEText
from email.header import Header
import smtplib
import os


logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
#logger.addHandler(logging.StreamHandler())

test_url_list = [
    "http://www.baidu.com",
    "http://www.qq.com",
    "http://cloud.tencent.com",
    "http://unkownurl.com"
]

email_server_config = {
    "server":"smtp.qq.com",
    "port":465,
    "user":"3473058547@qq.com",
    "pwd":os.getenv("EMAIL_PWD"),
    "fromAddr":"3473058547@qq.com"
}

email_notify_list = [
    "3473058547@qq.com"
]

def send_mail(toAddrList,subject,content):
    logger.info("send mail")
    try:
        receivers = toAddrList
        message = MIMEText(content, 'plain', 'utf-8')
        message['From'] = Header("自动拨测", 'utf-8')
        message['To'] = Header("异常通知接收", 'utf-8')
        message['Subject'] = Header(subject, 'utf-8')

        smtpObj = smtplib.SMTP_SSL(email_server_config["server"], email_server_config["port"])
        #smtpObj = smtplib.SMTP(email_server_config["server"], email_server_config["port"])
        smtpObj.login(email_server_config["user"],email_server_config["pwd"])
        smtpObj.sendmail(email_server_config["fromAddr"], receivers, message.as_string())
        logger.info("send success")
    except Exception as e:
        logger.warn(str(e))
        logger.warn(type(e))
        logger.warn("Error: send fail")

def test_url(url_list):
    errorinfo = []
    for url in url_list:
        resp = None
        try:
            resp = requests.get(url,timeout=3)
        except (requests.exceptions.Timeout, requests.exceptions.ConnectionError, requests.exceptions.ConnectTimeout) as e:
            logger.warn("request exceptions:"+str(e))
            errorinfo.append("Access "+ url + " timeout")
        else:
            if resp.status_code >= 400:
                logger.warn("response status code fail:"+str(resp.status_code))
                errorinfo.append("Access "+ url + " fail, status code:" + str(resp.status_code))
    if len(errorinfo) != 0:
        send_mail(email_notify_list,"拨测异常通知","\r\n".join(errorinfo))

def main_handler(event, context):
    test_url(test_url_list)
    

if __name__ == '__main__':
    main_handler("", "")

```

在这段代码里，我们需要拨测的地址放置在 test_url_list 列表中，并在拨测时，通过 GET 方法发起调用。在发起调用后，无论是 URL 访问超时，还是返回的 HTTP 状态码错误，均会记录 URL 拨测结果，并通过 Email 发送出来。而 Email 的发送配置，我们存储在 email_server_config 中，并且从环境变量中获取 Email server 的登录密码，避免在代码中暴露密码的泄露风险。同时，通知邮件的接收者，通过 email_notify_list 这个列表保存，向这个列表中添加更多的邮件地址，可以确保更多相关人员在拨测到异常时，接收到告警邮件。

同时，这段代码中的邮件服务器使用的是 QQ 邮箱。QQ 邮箱的 SMTP 邮件发送服务，可以在邮箱的设置-账号中开启，并且在开启 SMTP 服务后，可以通过申请授权码，作为邮箱的登录账号使用。

## 云函数配置

接下来，我们通过创建函数，配置触发，让拨测可以正常的运行起来。

### 创建及配置函数

首先我们来创建和配置函数。创建前，我们可以先选择合适的地域来部署函数，甚至可以选择为多地域同时部署，检验多地发起拨测时的联通性。选择好地域后，我们创建函数，输入函数名，选择运行环境为 Python 2。同时，函数的运行超时也需要一定程度的放大，例如设置为 60s，避免因为拨测时 URL 访问超时导致的函数运行超时，无法正常发出邮件。同时在创建函数时，我们也需要配置好函数的环境变量，设置 `EMAIL_PWD` 环境变量名，并填写通过邮箱配置获得的登录授权码，或登录密码。

在函数代码界面，可以通过把本地已经存储的 index.py 文件夹打包成 zip 包，然后上传的方式提交代码，也可以通过直接在代码编辑窗口粘贴如上代码的方式，完成代码提交和保存。

在配置触发器时，我们可以先跳过这个步骤，完成函数运行测试后再配置定时触发器启动函数。

### 测试及启动函数

完成函数创建后，我们可以通过 "测试" 案例触发函数，查看运行情况。拨测函数未处理函数入参，因此任何测试入参，或者无入参都可以触发函数。通过测试时的输出日志，我们可以查看拨测结果，邮件发送情况。

通过日志确认函数运行正确后，我们就可以根据需求配置上触发器，开始函数的定时拨测运行。最简单的可以通过选择每 5 分钟运行一次来进行拨测，如果有特殊的定时运行需求，也可以通过自行填写 cron 格式来选择合适的运行触发时间或周期。

## 总结

通过本节内容，我们实现了一个简单的 URL 拨测及邮件告警的定时运行脚本。本节内容的实现方式很简单，例如拨测的 URL 、邮件告警发送方，都是直接保存在代码中；URL 仅能通过 GET 方法进行拨测；仅支持通过 Email 发送告警等。此内容更多的是为大家提供使用 Serverless 架构或者使用云函数的一种思路，基于此思路，我们可以进行更多的扩展，例如增加非 HTTP 的拨测、增加短信告警能力、增加外部配置能力等。基于此思路，欢迎大家继续扩展并分享在运维过程中使用云函数的经验。

