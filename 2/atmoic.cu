#include <stdio.h>
#include "time.h"
#include <unistd.h>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#define NUM_THREADS 1000000
#define ARRAY_SIZE  100

#define BLOCK_WIDTH 1000

void print_array(int *array, int size)
{
    printf("{ ");
    for (int i = 0; i < size; i++)  { printf("%d ", array[i]); }
    printf("}\n");
}

__global__ void increment_naive(int *g)
{
	// which thread is this?
	int i = blockIdx.x * blockDim.x + threadIdx.x; 

	// each thread to increment consecutive elements, wrapping at ARRAY_SIZE
	i = i % ARRAY_SIZE;  
	g[i] = g[i] + 1;
}

__global__ void increment_atomic(int *g)
{
	// which thread is this?
	int i = blockIdx.x * blockDim.x + threadIdx.x; 

	// each thread to increment consecutive elements, wrapping at ARRAY_SIZE
	i = i % ARRAY_SIZE;  
	atomicAdd(& g[i], 1);
}

int main(int argc,char **argv)
{   
    clock_t begin, end;
    printf("%d total threads in %d blocks writing into %d array elements\n",
           NUM_THREADS, NUM_THREADS / BLOCK_WIDTH, ARRAY_SIZE);

    // declare and allocate host memory
    int h_array[ARRAY_SIZE];
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(int);
 
    // declare, allocate, and zero out GPU memory
    int *d_array;
    cudaMalloc((void **) &d_array, ARRAY_BYTES);
    cudaMemset((void *) d_array, 0, ARRAY_BYTES); 

    // launch the kernel - comment out one of these
    begin =  clock();
    // sleep(10);
    
    
    // Instructions: This program is needed for the next quiz
    // uncomment increment_naive to measure speed and accuracy 
    // of non-atomic increments or uncomment increment_atomic to
    // measure speed and accuracy of  atomic icrements
    // increment_naive<<<NUM_THREADS/BLOCK_WIDTH, BLOCK_WIDTH>>>(d_array);
    increment_atomic<<<NUM_THREADS/BLOCK_WIDTH, BLOCK_WIDTH>>>(d_array);
    end =  clock();
    
    // copy back the array of sums from GPU and print
    cudaMemcpy(h_array, d_array, ARRAY_BYTES, cudaMemcpyDeviceToHost);
    print_array(h_array, ARRAY_SIZE);
    printf("Time elapsed = %f ms\n", (double)(end - begin)/8);
 
    // free GPU memory allocation and exit
    cudaFree(d_array);
    return 0;
}