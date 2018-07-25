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
SECRET_KEY = os.getenv('secretkey') #'uxxlbNyQo4EMJ5jPGA7sUvHWaSAlFZlm'
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
