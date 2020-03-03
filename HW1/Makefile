NVCC=nvcc

OPENCV_LIBPATH=/usr/local/lib/opencv4/
OPENCV_INCLUDEPATH=/usr/local/include/opencv4/

OPENCV_LIBS=-lopencv_core -lopencv_imgproc -lopencv_highgui
CUDA_INCLUDEPATH=/usr/local/cuda-10.1/include

COMMON+= -DOPENCV
CFLAGS+= -DOPENCV
LDFLAGS+= `pkg-config --libs opencv4`
COMMON+= `pkg-config --cflags opencv4`

NVCC_OPTS= -arch=sm_75 -Xcompiler -Wall -Xcompiler -Wextra -m64

GCC_OPTS= -Wall -Wextra -m64 -fPIC

student: main.o student_func.o compare.o reference_calc.o Makefile
	$(NVCC) -o HW1 main.o student_func.o compare.o reference_calc.o -L $(OPENCV_LIBPATH) $(OPENCV_LIBS) $(NVCC_OPTS) $(COMMON) $(CFLAGS) $(LDFLAGS)

main.o: main.cpp timer.h utils.h reference_calc.cpp compare.cpp HW1.cpp 
	clang++ -c main.cpp $(COMMON) $(CFLAGS) $(LDFLAGS) $(GCC_OPTS) -I $(CUDA_INCLUDEPATH) -I $(OPENCV_INCLUDEPATH)

student_func.o: student_func.cu utils.h
	nvcc -c student_func.cu $(NVCC_OPTS)

compare.o: compare.cpp compare.h
	clang++ -c compare.cpp -I $(OPENCV_INCLUDEPATH) $(GCC_OPTS) -I $(CUDA_INCLUDEPATH) $(COMMON) $(CFLAGS) $(LDFLAGS)

reference_calc.o: reference_calc.cpp reference_calc.h
	clang++ -c reference_calc.cpp -I $(OPENCV_INCLUDEPATH) $(GCC_OPTS) -I $(CUDA_INCLUDEPATH) $(COMMON) $(CFLAGS) $(LDFLAGS)

clean:
	rm -f *.o *.png HW1
