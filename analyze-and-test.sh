#!/bin/bash

#
# Copyright © 2018 - 2019 Stefan Kebekus <stefan.kebekus@math.uni-freiburg.de>
#
#
# This script does the following
#
# - Check the code with cppcheck, using the CLANG static analyzer to find
#   potential issues in the code
#
# - Build in debug mode, using the CLANG static analyzer to find potential
#   issues in the code
#
# - Run unit tests
#
# If a test fails, the script will abort, and the results of the failed step can
# be found in the directory "testResults". If all tests succeed, the directory
# testResults will be deleted.
#
# Run this script in the main directory tree.
#

#
# Fail on any error
#
set -e

#
# Clean up
#

rm -rf build-analysis testResults
mkdir testResults


#
# Run the cppcheck static analyser
#

echo "Running static analysis using cppcheck…"

cppcheck --enable=style,performance,portability,warning --force --inline-suppr --quiet src -i src/3rdParty 2> testResults/cppcheck-issues.txt

# Quit if cppcheck did find any issues
if [ -s testResults/cppcheck-issues.txt ]; then
   echo "Static analysis with cppcheck found issues"
   exit 0
fi
echo "Static analysis with cppcheck found no issues"
rm testResults/cppcheck-issues.txt


#
# Compile the project in debug mode using the CLANG static analyzer
#

echo
echo
echo "Running static analysis using the CLANG static analyzer…"
echo

mkdir build-analysis
cd build-analysis
scan-build cmake -DCMAKE_CXX_COMPILER=clazy -DCMAKE_BUILD_TYPE="Debug" -DCMAKE_CXX_FLAGS="-Werror" ..

# Compile & Analyze
scan-build --status-bugs -o ../testResults make -j5
cd ..

# Quit if cppcheck did find any issues
if find testResults -mindepth 1 | read; then
   echo "Static analysis with CLANG found issues"
   exit 0
fi
echo "Static analysis with CLANG found no issues"


#
# Run unit tests
#

echo
echo
echo "Running unit tests…"
echo

cd build-analysis
if ! QT_QPA_PLATFORM="offscreen" ctest -O ../testResults/UnitTestLog.txt; then
   exit 0
fi
cd ..
rm -rvf build-analysis testResults
