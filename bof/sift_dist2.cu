#include <math.h>
#include "tmwtypes.h"

__global__ void sift_dist2 ( int * d, const uint8_T * vn, const uint8_T * vm, const int n, const int m)
{
    // d:  n * m
    // v1: 128 x n
    // v2: 128 x m
    int diff;
    int idx1 = blockIdx.x;
    int idx2 = blockIdx.y;
    int i = threadIdx.x;
    diff = vm[idx2*128+i] - vn[idx1*128+i];
    atomicAdd(&d[idx2*n+idx1], diff*diff);
}
