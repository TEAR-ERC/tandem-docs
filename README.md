# tandem-env

[tandem](https://github.com/TEAR-ERC/tandem) requires some dependencies.
The Docker image provided with this repositories contains all necessary dependencies to build tandem.

Example usage:

```console
$ docker pull uphoffc/tandem-env
$ docker run -it -v $(pwd):/home uphoffc/tandem-env
# git clone https://github.com/TEAR-ERC/tandem.git
# cd tandem/
# git submodule update --init
# mkdir build && cd build
# cmake .. -DPOLYNOMIAL_DEGREE=6
# make -j8
```
