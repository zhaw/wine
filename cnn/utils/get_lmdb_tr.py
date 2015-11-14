import sys
sys.path.insert(0, '/usr/local/lib/python2.7/dist-packages')

import pandas
import scipy.io
import numpy as np
import Image as img
import lmdb
import caffe


# Get those pics with the same brand.
brand_file_map = {}
with open('utils/brand_train.csv') as f:
    d = pandas.read_csv(f).values
for rec in d:
    if type(rec[1]) != str and np.isnan(rec[1]):
        continue
    if rec[-1] == 'x':
        continue
    if rec[1] not in brand_file_map:
        brand_file_map[rec[1]] = []
    brand_file_map[rec[1]].append(str(rec[0]).strip('.jpg')+'.jpg')

truth_pair = []
for brand in brand_file_map:
    n = len(brand_file_map[brand])
    for i in xrange(n):
        for j in xrange(i+1, n):
            truth_pair.append([brand_file_map[brand][i], brand_file_map[brand][j]])
false_pair = []
p1 = np.random.randint(0,len(brand_file_map), 110000)
p2 = np.random.randint(0,len(brand_file_map), 110000)
pp1 = p1[p1!=p2]
pp2 = p2[p1!=p2]
bfml = brand_file_map.items()
for i in xrange(pp1.shape[0]):
    l1 = bfml[pp1[i]][1]
    l2 = bfml[pp2[i]][1]
    r1 = np.random.randint(len(l1))
    r2 = np.random.randint(len(l2))
    false_pair.append([l1[r1], l2[r2]])

# Make LMDB data.
truth_n = len(truth_pair)
falsehood_n = len(false_pair)
# truth_n /= 2
# falsehood_n /= 2
print truth_n, falsehood_n

X = np.zeros((int(truth_n*0.8),6,250,250), dtype=np.uint8)
Y = np.zeros(int(truth_n*0.8), dtype=np.int64)

for i in xrange(int(truth_n*0.8)):
    print i
    file_name1 = truth_pair[i][0]
    file_name2 = truth_pair[i][1]
    try:
        im1 = img.open('pics/train/%s'%file_name1)
        im2 = img.open('pics/train/%s'%file_name2)
    except:
        continue
    im1 = im1.resize([250,250])
    im2 = im2.resize([250,250])
    im1 = np.array(im1)
    im2 = np.array(im2)
    if len(im1.shape) == 3:
        im1 = im1[:,:,::-1]
        im1 = im1.transpose((2,0,1))
    else:
        continue
    if len(im2.shape) == 3:
        im2 = im2[:,:,::-1]
        im2 = im2.transpose((2,0,1))
    else:
        continue
    im1 = np.resize(im1, [3,250,250])
    im2 = np.resize(im2, [3,250,250])
    X[i,:3,:,:] = im1
    X[i,3:,:,:] = im2
    Y[i] = 1

X2 = np.zeros((int(falsehood_n*0.8),6,250,250), dtype=np.uint8)
Y2 = np.zeros(int(falsehood_n*0.8), dtype=np.int64)

for i in xrange(int(falsehood_n*0.8)):
    print i
    file_name1 = false_pair[i][0]
    file_name2 = false_pair[i][1]
    try:
        im1 = img.open('pics/train/%s'%file_name1)
        im2 = img.open('pics/train/%s'%file_name2)
    except:
        continue
    im1 = im1.resize([250,250])
    im2 = im2.resize([250,250])
    im1 = np.array(im1)
    im2 = np.array(im2)
    if len(im1.shape) == 3:
        im1 = im1[:,:,::-1]
        im1 = im1.transpose((2,0,1))
    else:
        continue
    if len(im2.shape) == 3:
        im2 = im2[:,:,::-1]
        im2 = im2.transpose((2,0,1))
    else:
        continue
    im1 = np.resize(im1, [3,250,250])
    im2 = np.resize(im2, [3,250,250])
    X2[i,:3,:,:] = im1
    X2[i,3:,:,:] = im2
    Y2[i] = 0

map_size = X.nbytes * 4
env = lmdb.open('wine_lmdb_tr', map_size=map_size)
with env.begin(write=True) as txn:
    for i in xrange(int(truth_n*0.8)):
        datum = caffe.proto.caffe_pb2.Datum()
        datum.channels = X.shape[1]
        datum.height = X.shape[2]
        datum.width = X.shape[3]
        datum.data = X[i].tobytes()
        datum.label = Y[i]
        str_id = '{:08}'.format(i)
        txn.put(str_id, datum.SerializeToString())
    for i in xrange(int(falsehood_n*0.8)):
        datum = caffe.proto.caffe_pb2.Datum()
        datum.channels = X2.shape[1]
        datum.height = X2.shape[2]
        datum.width = X2.shape[3]
        datum.data = X2[i].tobytes()
        datum.label = Y2[i]
        str_id = '{:08}'.format(i+truth_n)
        txn.put(str_id, datum.SerializeToString())
env.close()

X = np.zeros((truth_n-int(truth_n*0.8),6,250,250), dtype=np.uint8)
Y = np.zeros(truth_n-int(truth_n*0.8), dtype=np.int64)

for i in xrange(int(truth_n*0.8),truth_n):
    print i
    file_name1 = truth_pair[i][0]
    file_name2 = truth_pair[i][1]
    try:
        im1 = img.open('pics/train/%s'%file_name1)
        im2 = img.open('pics/train/%s'%file_name2)
    except:
        continue
    im1 = im1.resize([250,250])
    im2 = im2.resize([250,250])
    im1 = np.array(im1)
    im2 = np.array(im2)
    if len(im1.shape) == 3:
        im1 = im1[:,:,::-1]
        im1 = im1.transpose((2,0,1))
    else:
        continue
    if len(im2.shape) == 3:
        im2 = im2[:,:,::-1]
        im2 = im2.transpose((2,0,1))
    else:
        continue
    im1 = np.resize(im1, [3,250,250])
    im2 = np.resize(im2, [3,250,250])
    X[i-int(truth_n*0.8),:3,:,:] = im1
    X[i-int(truth_n*0.8),3:,:,:] = im2
    Y[i-int(truth_n*0.8)] = 1

X2 = np.zeros((falsehood_n-int(falsehood_n*0.8),6,250,250), dtype=np.uint8)
Y2 = np.zeros(falsehood_n-int(falsehood_n*0.8), dtype=np.int64)

for i in xrange(int(falsehood_n*0.8),falsehood_n):
    print i
    file_name1 = false_pair[i][0]
    file_name2 = false_pair[i][1]
    try:
        im1 = img.open('pics/train/%s'%file_name1)
        im2 = img.open('pics/train/%s'%file_name2)
    except:
        continue
    im1 = im1.resize([250,250])
    im2 = im2.resize([250,250])
    im1 = np.array(im1)
    im2 = np.array(im2)
    if len(im1.shape) == 3:
        im1 = im1[:,:,::-1]
        im1 = im1.transpose((2,0,1))
    else:
        continue
    if len(im2.shape) == 3:
        im2 = im2[:,:,::-1]
        im2 = im2.transpose((2,0,1))
    else:
        continue
    im1 = np.resize(im1, [3,250,250])
    im2 = np.resize(im2, [3,250,250])
    X2[i-int(falsehood_n*0.8),:3,:,:] = im1
    X2[i-int(falsehood_n*0.8),3:,:,:] = im2
    Y2[i-int(falsehood_n*0.8)] = 0

env = lmdb.open('wine_lmdb_val', map_size=map_size)
with env.begin(write=True) as txn:
    for i in xrange(int(truth_n*0.8),truth_n):
        datum = caffe.proto.caffe_pb2.Datum()
        datum.channels = X.shape[1]
        datum.height = X.shape[2]
        datum.width = X.shape[3]
        datum.data = X[i-int(truth_n*0.8)].tobytes()
        datum.label = Y[i-int(truth_n*0.8)]
        str_id = '{:08}'.format(i)
        txn.put(str_id, datum.SerializeToString())
    for i in xrange(int(falsehood_n*0.8), falsehood_n):
        datum = caffe.proto.caffe_pb2.Datum()
        datum.channels = X2.shape[1]
        datum.height = X2.shape[2]
        datum.width = X2.shape[3]
        datum.data = X2[i-int(falsehood_n*0.8)].tobytes()
        datum.label = Y2[i-int(falsehood_n*0.8)]
        str_id = '{:08}'.format(i+truth_n)
        txn.put(str_id, datum.SerializeToString())
env.close()
