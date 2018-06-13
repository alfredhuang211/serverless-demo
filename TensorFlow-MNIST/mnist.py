#!/usr/bin/env python2.7

import os
import sys
import base64
import urllib
import tensorflow as tf
import numpy as np
import utils
import json

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

# Load model
cur_dir = os.getcwd()
model_dir = cur_dir+"/export/4"
sess = tf.Session(graph=tf.Graph())
meta_graph_def = tf.saved_model.loader.load(sess, [tf.saved_model.tag_constants.SERVING], model_dir)
x = sess.graph.get_tensor_by_name('x:0')
y = sess.graph.get_tensor_by_name('y:0')

def run(event):
    local_path = ""
    if event['image_base64'] != "":
        data=base64.b64decode(event['image_base64'])
        local_path = '/tmp/test_image.xxx'
        file=open(local_path,'wb')
        file.write(data)
        file.close()
    elif event['image_url'] != "":
        img_url = event['image_url']
        filename = urllib.unquote(img_url).decode('utf8').split('/')[-1]
        local_path = os.path.join('/tmp/', filename)
        if not utils.download_image(event['image_url'], local_path):
            return False, -1
    else:
        print('Please specify a image.')

    try:
        x_ = utils.get_image_array(local_path)
        predict = tf.argmax(y, 1)
        res = sess.run(predict, feed_dict={x: x_})[0] 
        return True, sess.run(predict, feed_dict={x: x_})[0]
    except Exception as e:
        print(e)
        return False, -1

def demo(event, context):
    res, num = run(event)
    print num
    return num
        
def apigw_interface(event, context):
    if 'requestContext' not in event.keys():
        return {"errMsg":"request not from api gw"}
    body_str = event['body']
    body_info = json.loads(body_str)
    res, num = run(body_info)
    return {"result":num}

