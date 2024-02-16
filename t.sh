docker run -d -it \
  --name verilator_dev_0 \
  -v repos:/repos \
  -w /repos \
  base:latest

# #############################################################################

cat >>~/.bashrc <<-EOF
export PATH=\$PATH:\${EXT_PATH}
export PYTHONPATH=\$PYTHONPATH:\${EXT_PYTHONPATH}
EOF

apt update
apt install -y locales
apt install -y bison
apt install -y flex
apt install -y gperf
micromamba install bear abseil-cpp

# optional
# # micromamba install systemc systemc-dev
# apt install -y libsystemc libsystemc-dev

# for locales warn
sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure locales

# start build
autoconf

# just configure, do not build
CC=clang \
  CXX=clang++ \
  ./configure --prefix=$PWD/build/install_2

# build with cmake target `install`

cp include/verilated.mk build/install/include/
cp bin/verilator_includer build/install/bin/

# #############################################################################

verilator --help
verilator --help >demos/verilator.help.log

pushd examples/make_hello_binary
make
./obj_dir/Vtop
popd

pushd examples/cmake_hello_c
cmake .
cmake --build .
./example
popd

rm -rf obj_dir/
verilator --binary -j 0 examples/make_hello_binary/top.v
obj_dir/Vtop
