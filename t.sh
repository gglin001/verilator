docker run -d -it \
  --name verilator_dev_0 \
  -v repos:/repos \
  -w /repos \
  base:latest

# #############################################################################

verilator --help

build/src/verilator_bin_dbg \
  -o hello examples/hello.vl

verilated.mk
