#include<algorithm>
#include<iostream>
#include<vector>
#include<stdio.h>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"

__global__ void add_atomic(int *g)
{
	// which thread is this?
	int i = blockIdx.x * blockDim.x + threadIdx.x; 

	// each thread to increment consecutive elements, wrapping at ARRAY_SIZE
	// i = i % ARRAY_SIZE;  
	// atomicAdd(&g[i], 1);
	// i = i % 80;  

	g[i] = threadIdx.x;
}

int main() {
    const int SIZE = 16;
    int *arr = new int[SIZE];
    int *arr_d, *inp_d;
    std::fill_n(arr, SIZE, 10);

    for (size_t i = 0; i < SIZE; i++) {
       std::cout << arr[i] << std::endl;
    }
    
    // std::cout << sizeof(arr) * SIZE <<std::endl;
    cudaMalloc((void **) &arr_d, sizeof(arr) * SIZE);
    // cudaMemset((void *)arr_d, 0, sizeof(arr) * SIZE);
    std::cout << "============" <<std::endl;

    cudaMemcpy(arr_d, arr, sizeof(arr) * SIZE, cudaMemcpyHostToDevice);
    add_atomic<<<3, 1,SIZE>>>(arr_d);
    cudaMemcpy(arr, arr_d, sizeof(arr) * SIZE, cudaMemcpyDeviceToHost);

    for (size_t i = 0; i < SIZE; i++) {
       std::cout << arr[i] << std::endl;
    }
    return 0;
}