
#!/bin/bash

# Define the source directories where the .so files are located
ARM_DIR="build/app/intermediates/merged_native_libs/release/out/lib/armeabi-v7a"
ARM64_DIR="build/app/intermediates/merged_native_libs/release/out/lib/arm64-v8a"
X86_64_DIR="build/app/intermediates/merged_native_libs/release/out/lib/x86_64"

# Create temporary directories for each ABI
mkdir -p temp_armeabi-v7a
mkdir -p temp_arm64-v8a
mkdir -p temp_x86_64

# Copy .so files to temporary directories (without the lib directory structure)
if [ -d "$ARM_DIR" ]; then
  cp $ARM_DIR/*.so temp_armeabi-v7a/
  cd temp_armeabi-v7a
  zip -r ../native_symbols_armeabi-v7a.zip .
  cd ..
  echo "Created native_symbols_armeabi-v7a.zip"
fi

if [ -d "$ARM64_DIR" ]; then
  cp $ARM64_DIR/*.so temp_arm64-v8a/
  cd temp_arm64-v8a
  zip -r ../native_symbols_arm64-v8a.zip .
  cd ..
  echo "Created native_symbols_arm64-v8a.zip"
fi

if [ -d "$X86_64_DIR" ]; then
  cp $X86_64_DIR/*.so temp_x86_64/
  cd temp_x86_64
  zip -r ../native_symbols_x86_64.zip .
  cd ..
  echo "Created native_symbols_x86_64.zip"
fi

# Clean up temporary directories
rm -rf temp_armeabi-v7a temp_arm64-v8a temp_x86_64

echo "Native symbol ZIP files created for each ABI"
