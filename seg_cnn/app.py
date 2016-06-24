# pylint: skip-file
import flask
import numpy as np
import mxnet as mx
import os
import cv2
from PIL import Image

app = flask.Flask(__name__)

pallete = [ 0,0,0,
            255,255,255 ]
model_previx = "model_pascal/FCN8s_VGG16"
epoch = 2
ctx = mx.gpu(0)

def preprocess(im):
    """get the (1, 3, h, w) np.array data for the img_path"""
    mean = np.array([123.68, 116.779, 103.939])  # (R,G,B)
    factor = 500. / max(im.shape)
    new_shape = (int(im.shape[0]*factor), int(im.shape[1]*factor))
    im = cv2.resize(im, new_shape)
    im = np.array(im, dtype=np.float32)
    reshaped_mean = mean.reshape(1, 1, 3)
    im = im - reshaped_mean
    im = np.swapaxes(im, 0, 2)
    im = np.swapaxes(im, 1, 2)
    im = np.expand_dims(im, axis=0)
    return im

def main():
    app.fcnxs, app.fcnxs_args, app.fcnxs_auxs = mx.model.load_checkpoint(model_previx, epoch)
    app.run('0.0.0.0')
        s = get_data(img)
        if s == []:
            print img
            continue
        fcnxs_args["data"] = mx.nd.zeros([1,3,200,150], ctx)
        fcnxs_args["softmax_label"] = mx.nd.empty((1, 200*150), ctx)
        mx.nd.array(s, ctx).copyto(fcnxs_args["data"])
        data_shape = fcnxs_args["data"].shape
        label_shape = (1, data_shape[2]*data_shape[3])
#        fcnxs_args["softmax_label"] = mx.nd.empty(label_shape, ctx)
        exector = fcnxs.bind(ctx, fcnxs_args ,args_grad=None, grad_req="null", aux_states=fcnxs_args)
        exector.forward(is_train=False)
        output = exector.outputs[0]
#        out_img = np.uint8(np.squeeze(output.asnumpy().argmax(axis=1)))
        out_img = np.uint8(255*output.asnumpy()[:,1])
        out_img = Image.fromarray(out_img[0])
#        out_img.putpalette(pallete)
#        out_img.save(seg)

if __name__ == "__main__":
    main()
