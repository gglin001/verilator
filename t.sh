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
apt install -y graphviz
micromamba install bear abseil-cpp

# optional
# # micromamba install systemc systemc-dev
# apt install -y libsystemc libsystemc-dev

# for locales warn
sudo locale-gen en_US en_US.UTF-8
sudo dpkg-reconfigure locales

# cmake(build verilator) + make(`examples/make_*`)
# start build
autoconf
# just configure, do not build
CC=clang \
  CXX=clang++ \
  ./configure --prefix=$PWD/build/install_2
# build with cmake target `install`(in vscode)
cp include/verilated.mk build/install/include/
cp bin/verilator_includer build/install/bin/

# only for cmake based examples
# build with cmake target `inwstall`(in vscode)

# #############################################################################

verilator --help
verilator --help >demos/verilator.help.log

# need make
verilator --cc -j 0 \
  --runtime-debug \
  --build \
  --binary \
  --Mdir demos/top_cc \
  examples/make_hello_binary/top.v

# need make
pushd examples/make_hello_binary
make
./obj_dir/Vtop
popd

# cmake
pushd examples/cmake_hello_c
bash t.sh
popd

# cmake
pushd examples/cmake_hello_sc
bash t.sh
popd
