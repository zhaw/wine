#include <math.h>
#include "tmwtypes.h"

__global__ void sift_sum ( int *s, const int *d , const int n, const int m)
{
    // d: 128 x n x m
    // s: n x m
    if (blockIdx.x*blockDim.x + threadIdx.x < n
        && blockIdx.y*blockDim.y + threadIdx.y < m)
        {
            int i = 0;
            int a = blockIdx.x * blockDim.x + threadIdx.x;
            int b = blockIdx.y * blockDim.y + threadIdx.y;
            int idx = a + b*n;
            for (i = 128*idx; i < 128+128*idx; i++)
                s[idx] += d[i];
        }
}
