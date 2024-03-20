CC = gcc
CFLAGS = -O2

FC = gfortran
FFLAGS = -O2 -fopenmp

# AA: Make STREAM_ARRAY_SIZE a variable
ifdef ARR_SIZE
	ARRAY_SIZE=-DSTREAM_ARRAY_SIZE=$(ARR_SIZE)
endif
# AA: make openmp optional
ifdef USE_MT
	OPENMP=-fopenmp
endif


all: stream_f.exe stream_c.exe

stream_f.exe: stream.f mysecond.o
	$(CC) $(CFLAGS) -c mysecond.c
	$(FC) $(FFLAGS) -c stream.f
	$(FC) $(FFLAGS) stream.o mysecond.o -o stream_f.exe

stream_c.exe: stream.c
	$(CC) $(CFLAGS) stream.c -o stream_c.exe

# AA: run with larger than cache array size
stream_large:
	$(CC) $(CFLAGS) $(OPENMP) $(ARRAY_SIZE) stream.c -o stream_large

clean:
	rm -f stream_f.exe stream_c.exe *.o stream_large

# an example of a more complex build line for the Intel icc compiler
stream.icc: stream.c
	icc -O3 -xCORE-AVX2 -ffreestanding -qopenmp -DSTREAM_ARRAY_SIZE=80000000 -DNTIMES=20 stream.c -o stream.omp.AVX2.80M.20x.icc
