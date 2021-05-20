FROM debian:stable-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget ca-certificates gcc g++ gfortran libgomp1 make cmake libopenblas-dev libopenblas-base libopenmpi-dev libopenmpi3 git libeigen3-dev python3 python3-distutils \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
    && wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz \
    && tar -xvf metis-5.1.0.tar.gz \
    && cd metis-5.1.0 \
    && make config && make && make install

RUN cd /tmp \
    && wget http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/parmetis-4.0.3.tar.gz \
    && tar -xvf parmetis-4.0.3.tar.gz \
    && cd parmetis-4.0.3 \
    && make config && make && make install

RUN cd /tmp \
    && wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.13.3.tar.gz \
    && tar -xvf petsc-lite-3.13.3.tar.gz \
    && cd petsc-3.13.3 \
    && ./configure --with-fortran-bindings=0 --with-debugging=0 --with-memalign=32 --with-64-bit-indices CC=mpicc CXX=mpicxx FC=mpif90 --prefix=/usr/local/ --download-mumps --download-scalapack COPTFLAGS="-g -O3" CXXOPTFLAGS="-g -O3"  \
    && make PETSC_DIR=`pwd` PETSC_ARCH=arch-linux-c-opt -j4 \
    && make PETSC_DIR=`pwd` PETSC_ARCH=arch-linux-c-opt install

RUN cd /tmp \
    && wget https://github.com/hfp/libxsmm/archive/refs/tags/1.16.1.tar.gz \
    && tar -xvf 1.16.1.tar.gz \
    && cd libxsmm-1.16.1 \
    && make -j4 generator \
    && cp bin/libxsmm_gemm_generator /usr/local/bin/


FROM debian:stable-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates gcc g++ gfortran libgomp1 make cmake cmake-curses-gui libopenblas-dev libopenblas-base libopenmpi-dev libopenmpi3 git libeigen3-dev python3 python3-numpy liblua5.3-0 liblua5.3-dev vim zlib1g zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=0 /usr/local/ /usr/local/

WORKDIR /home
