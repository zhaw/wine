import sys
sys.path.insert(0, '/usr/local/lib/python2.7/dist-packages')

import scipy.io
import numpy as np
import Image as img
import lmdb
import caffe

def rgb2gray(im):
    return np.dot(im[...,:3], [0.299, 0.587, 0.144])

data = scipy.io.loadmat('mat/true_false_match.mat')['data']
truth = data[0,0]
falsehood = data[0,1]
truth_n = data[0,0].shape[0]
falsehood_n = data[0,1].shape[0]

N = truth_n + falsehood_n
print truth_n, falsehood_n, N

X = np.zeros((N,6,250,250), dtype=np.uint8)
Y = np.zeros(N, dtype=np.int64)

for i in xrange(truth_n):
    file_name1 = truth[i,0][0]
    file_name2 = truth[i,1][0]
    im1 = img.open('pics/test2_cutted/%s.jpg'%file_name1)
    im2 = img.open('pics/train/%s.jpg'%file_name2)
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
    print i
    im1 = np.resize(im1, [3,250,250])
    im2 = np.resize(im2, [3,250,250])
    X[i,:3,:,:] = im1
    X[i,3:,:,:] = im2
    Y[i] = 1

for i in xrange(falsehood_n):
    file_name1 = falsehood[i,0][0]
    file_name2 = falsehood[i,1][0]
    im1 = img.open('pics/test2_cutted/%s.jpg'%file_name1)
    im2 = img.open('pics/train/%s.jpg'%file_name2)
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
    print i
    im1 = np.resize(im1, [3,250,250])
    im2 = np.resize(im2, [3,250,250])
    X[truth_n+i,:3,:,:] = im1
    X[truth_n+i,3:,:,:] = im2
    Y[truth_n+i] = 0

map_size = X.nbytes * 4
env = lmdb.open('wine_lmdb_te', map_size=map_size)
with env.begin(write=True) as txn:
    for i in xrange(X.shape[0]):
        datum = caffe.proto.caffe_pb2.Datum()
        datum.channels = X.shape[1]
        datum.height = X.shape[2]
        datum.width = X.shape[3]
        datum.data = X[i].tobytes()
        datum.label = Y[i]
        str_id = '{:08}'.format(i)
        txn.put(str_id, datum.SerializeToString())
env.close()
