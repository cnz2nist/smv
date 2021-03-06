#!/bin/bash

# --------------------- wait_cases_end -----------------------------

wait_cases_end()
{
  while [[ `qstat -a | awk '{print $2 $4}' | grep $(whoami) | grep ${MOV_JOBPREFIX}` != '' ]]; do
     JOBS_REMAINING=`qstat -a | awk '{print $2 $4}' | grep $(whoami) | grep ${MOV_JOBPREFIX} | wc -l`
     echo "Waiting for ${JOBS_REMAINING} cases to complete."
     sleep 15
  done
}

QUEUE=

while getopts 'q:' OPTION
do
case $OPTION  in
  q)
   QUEUE="-q $OPTARG"
   ;;
esac
done
shift $(($OPTIND-1))

MOV_JOBPREFIX=MOV

TEST=$1

size=_64

OS=`uname`
if [ "$OS" == "Darwin" ]; then
  PLATFORM=_osx
else
  PLATFORM=_linux
fi

CURDIR=`pwd`
cd ../..
GITROOT=`pwd`
cd $CURDIR

FDSEXE=$GITROOT/fds/Build/impi_intel$PLATFORM$size/fds_impi_intel$PLATFORM$size
MAKEMOVIE="$GITROOT/smv/Utilities/Scripts/make_movie.sh"
QFDS=$GITROOT/fds/Utilities/Scripts/qfds.sh
QSMV="$GITROOT/smv/Utilities/Scripts/qsmv.sh -j ${MOV_JOBPREFIX} $QUEUE"

VDIR=$GITROOT/smv/Verification
INDIR=$GITROOT/smv/Verification/Visualization/frames
WUIINDIR=$GITROOT/smv/Verification/WUI/frames
OUTDIR=$GITROOT/smv/Manuals/SMV_Summary/movies

rm -f $INDIR/*.png
rm -f $WUIINDIR/*.png
rm -f $OUTDIR/*.m1v
rm -f $OUTDIR/*.mp4
rm -f $OUTDIR/*.png

# create version strings

cd $VDIR
$QFDS -e $FDSEXE -d Visualization -q terminal version2.fds
$QSMV            -d Visualization             version2

# -------- make movie frames -------------------

cd $VDIR

$QSMV -p 8 -c plume5c_movies.ssf        -d Visualization plume5c
$QSMV -p 8 -c thouse5_movies.ssf        -d Visualization thouse5
$QSMV -p 8 -c BT10m_2x2km_LS_movies.ssf -d WUI           BT10m_2x2km_LS
$QSMV -p 8 -c levelset1_movies.ssf      -d WUI           levelset1
$QSMV -p 8 -c wind_test1_movies.ssf     -d WUI           wind_test1
$QSMV -p 8 -c tree_test2_movies.ssf     -d WUI           tree_test2
wait_cases_end

# -------- make movies -------------------

cd $INDIR
$MAKEMOVIE -o $OUTDIR -m plume5c_tslice  plume5c_tslice
$MAKEMOVIE -o $OUTDIR -m plume5c_3dsmoke plume5c_3dsmoke
$MAKEMOVIE -o $OUTDIR -m plume5c_vtslice plume5c_vtslice
$MAKEMOVIE -o $OUTDIR -m plume5c_iso     plume5c_iso
$MAKEMOVIE -o $OUTDIR -m plume5c_tbound  plume5c_tbound
$MAKEMOVIE -o $OUTDIR -m plume5c_part    plume5c_part
$MAKEMOVIE -o $OUTDIR -m thouse5_tslice  thouse5_tslice
$MAKEMOVIE -o $OUTDIR -m thouse5_smoke3d thouse5_smoke3d

cd $WUIINDIR
$MAKEMOVIE -o $OUTDIR BT10m_2x2km_LS
$MAKEMOVIE -o $OUTDIR hill_structure
$MAKEMOVIE -o $OUTDIR levelset1
$MAKEMOVIE -o $OUTDIR wind_test1
$MAKEMOVIE -o $OUTDIR tree_test2

echo movies generated

