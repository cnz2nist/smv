#!/bin/csh -f
set SVNROOT=~/FDS-SMV
set rev=$1

cd $SVNROOT/SMV_5/source/Smokeview
/usr/local/bin/svn -r $rev update
cd $SVNROOT/SMV_5/Build/INTEL_OSX_32
make -f ../Makefile clean
./make_smv.csh
