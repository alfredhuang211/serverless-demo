#!/usr/bin/env python2.7

import urllib2
import numpy as np
from PIL import Image

def download_image(img_url, local_file):
    ret = True
    try: 
      f = urllib2.urlopen(img_url)
      data = f.read()
      with open(local_file, "wb") as img:
          img.write(data)
    except Exception as e:
        print(e)
        ret = False
    return ret

def get_image_array(img_path):
    x_s = 28
    y_s = 28
    n0 = 0
    n255 = 0
    threshold = 100
    im = None
    im = Image.open(img_path)

    img = np.array(im.resize((x_s, y_s), Image.ANTIALIAS).convert('L'))

    for x in range(x_s):
      for y in range(y_s):
        if img[x][y] > threshold:
          n255 = n255 + 1
        else:
          n0 = n0 + 1

    if(n255 > n0) :
      for x in range(x_s):
        for y in range(y_s):
          img[x][y] = 255 - img[x][y]
          if(img[x][y] < threshold) :
            img[x][y] = 0

    arr = img.reshape((1, 784))
    arr = arr.astype(np.float32)
    arr = np.multiply(arr, 1.0 / 255.0)
    return arr


