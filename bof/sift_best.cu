#include <math.h>
#include "tmwtypes.h"

__global__ void sift_best (int * index, const int * dist, const int n, const int m, const double thres)
{
    // index: m1+m2+...
    // dist:  n*(m1+m2+...)
    int idx = blockIdx.x*blockDim.x + threadIdx.x;
    if (idx < m)
    {
        int best_v = 99999999;
        int best_i = -1;
        for (int i = 0; i < n; i++)
        {
            if (dist[idx*n+i] < best_v)
            {
                best_i = -1;
                if (dist[idx*n+i] * thres < best_v) best_i = i;
                best_v = dist[idx*n+i];
            }
        }
        index[idx] = best_i;
    }
}
