# train fcn-32s model
# python -u fcn_xs.py --model=fcn32s --prefix=/home/zw/dataset/VOC2012Segmentation/VGG_FC_ILSVRC_16_layers \
#        --epoch=74 --init-type=vgg16

# train fcn-16s model
python -u fcn_xs.py --model=fcn16s --prefix=model_pascal/FCN32s_VGG16 \
      --epoch=1 --init-type=fcnxs

# train fcn-8s model
python -u fcn_xs.py --model=fcn8s --prefix=model_pascal/FCN16s_VGG16 \
      --epoch=1 --init-type=fcnxs
