#include "tmwtypes.h"

__global__ void sift_match (int *index, const uint8_T *vn,
        const uint8_T *vm, const int n, const int m, const double thres)
{
    int idx = blockIdx.x*blockDim.x + threadIdx.x;
    int diff;
    int tmp;
    int local_vm[128];
    for (int j = 0; j < 128; j++) local_vm[j] = vm[idx*128+j]; 
    if (idx < m)
    {
        int second_best = 9999999;
        int best_v = 999999999;
        int best_i = -1;
        for (int i = 0; i < n; i++)
        {
            tmp = 0;
            for (int j = 0; j < 128; j++)
            {
                diff = vn[i*128+j] - local_vm[j];
                tmp += diff * diff;
                if ( tmp > second_best ) break;
            }
            if ( tmp < best_v )
            {
                second_best = best_v;
                best_v = tmp;
                best_i = i;
            }
            else if ( tmp < second_best ) second_best = tmp;
        }
        if ( best_v * thres < second_best )
            index[idx] = best_i;
        else
            index[idx] = -1;
/*        int best_v = 99999999;
        int best_i = -1;
        for (int i = 0; i < n; i++)
        {
            if (dist[i] < best_v)
            {
                best_i = -1;
                if (dist[i] * thres < best_v) best_i = i;
                best_v = dist[i];
            }
        }
        index[idx] = best_i;
*/
    }
}
