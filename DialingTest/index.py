# -*- coding: utf8 -*-
import json
import logging
import requests
from email.mime.text import MIMEText
from email.header import Header
import smtplib


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


