cmake -S$PWD -B$PWD/build -G Ninja

cmake --build $PWD/build

./build/example
