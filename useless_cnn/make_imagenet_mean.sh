#!/usr/bin/env sh
# Compute the mean image from the imagenet training lmdb
# N.B. this is available in data/ilsvrc12


~/caffe/build/tools/compute_image_mean train_lmdb \
  wine_mean.binaryproto

echo "Done."
