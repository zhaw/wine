#include <math.h>
#include "tmwtypes.h"

__global__ void sift_dist ( int * d, const uint8_T * vn, const uint8_T * vm, const int n, const int m)
{
    // d:  n * m
    // v1: 128 x n
    // v2: 128 x m
    int diff;
    int idx1 = blockIdx.x*blockDim.x + threadIdx.x;
    int idx2 = blockIdx.y*blockDim.y + threadIdx.y;
    if ( idx1 < n && idx2 < m )
    {
        for (int i = 0; i < 128; i++)
        {
            diff = vn[idx1*128+i] - vm[idx2*128+i];
            d[idx2*n+idx1] += diff * diff;
        }
    }
}
