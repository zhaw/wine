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
falsehood_n = data[0,1].shape[1]

N = truth_n + falsehood_n


map_size = 1e12 
env = lmdb.open('wine_lmdb', map_size=map_size)
with env.begin(write=True) as txn:
    for i in xrange(truth_n/10):
        X = np.zeros((3,250,250), dtype=np.uint8)
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
        im1 = np.resize(im1, [3,250,250])
        im2 = np.resize(im2, [3,250,250])
        X[:3,:,:] = im1
#         X[3:,:,:] = im2
        im_dat = caffe.io.array_to_datum(X,1)
        txn.put('{:0>10d}'.format(i), im_dat.SerializeToString())

    for i in xrange(falsehood_n/10):
        X = np.zeros((3,250,250), dtype=np.uint8)
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
        im1 = np.resize(im1, [3,250,250])
        im2 = np.resize(im2, [3,250,250])
        X[:3,:,:] = im1
#         X[3:,:,:] = im2
        im_dat = caffe.io.array_to_datum(X,0)
        txn.put('{:0>10d}'.format(i+truth_n), im_dat.SerializeToString())

env.close()
