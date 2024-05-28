BUILD_DIR=build
BIN_DIR=~/local/bin/compiler_explorer/
COMP_VERSION=gcc-12.1.0
COMPILER_PATH="${BIN_DIR}${COMP_VERSION}/bin/g++"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

if [[ ! -f $COMPILER_PATH ]]; then
  echo "Didn't find compiler in [$COMPILER_PATH]... installing"
  curl -L https://compiler-explorer.s3.amazonaws.com/opt/"$COMP_VERSION".tar.xz | tar Jx
  echo "mkdir $BIN_DIR"
  mkdir -p "$BIN_DIR"
  echo "mv $COMP_VERSION $BIN_DIR"
  mv "$COMP_VERSION" "$BIN_DIR"
fi

export CXX=$COMPILER_PATH && cmake -DCMAKE_BUILD_TYPE=Release ..
make -j3
retVal=$?
if [ "$retVal" -ne 0 ]; then
  echo "build failed"
  exit "$retVal"
fi
cd ..
ln -s -f "$BUILD_DIR"/compile_commands.json compile_commands.json
