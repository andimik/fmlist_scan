#!/bin/bash

if [ ! "$(whoami)" = "root" ]; then
  echo "$0 must be called as root or with sudo"
  exit 0
fi

if [ -z "${FMLIST_SCAN_USER}" ]; then
  export FMLIST_SCAN_USER="pi"
fi
if [ -z "${FMLIST_SCAN_RASPI}" ]; then
  export FMLIST_SCAN_RASPI="1"
fi

echo "$0 [syspre|pre|rtl|csdr|lfec|ldsp|redsea|dabcmd|pipwm|chkspec|pscan|kal]"
echo "  syspre  install system prerequisites"
echo "  pre     install prerequisites for all tools to be compiled"
echo "  rtl     install prerequisites, build & install librtlsdr - rtlsdr 'driver' lib"
echo "  csdr    install prerequisites, build & install for csdr - sdr command line tools"
echo "  lfec    install prerequisites, build & install for libfec aka libcorrect - required from liquid-dsp"
echo "  ldsp    install prerequisites, build & install for liquid-dsp - required from redsea"
echo "  redsea  install prerequisites, build & install for redsea - rds decoder"
echo "  dabcmd  install prerequisites, build & install for dab-cmdline - dab decoder - modified for scan"
echo "  pipwm   build & install libwiringPi. then compile / install pipwm"
echo "  chkspec build & install liquid-dsp. then compile / install checkSpectrumForCarrier"
echo "  pscan   compile / install prescanDAB"
echo "  kal     build & install kal."
echo ""
echo "environment parameters - to set before calling:"
echo "set FMLIST_SCAN_USER=<user>   # default user \"pi\""
echo "set FMLIST_SCAN_RASPI=<1/0>   # default \"1\" if Raspberry Pi hardware"
echo "set FMLIST_SCAN_GPS_COORDS=\"49.540295 / 8.652697\"   # default \"\" for using gpsd - with GPS hardware"
echo ""

if [ "$1" == "-h" ] || [ "$1" == "--h" ] || [ "$1" == "--help" ]; then
  exit 0
fi

if [ "$1" == "" ]; then
  echo "will install/build ALL - without parameters"
  sleep 5
fi

if [ "$1" == "syspre" ] || [ "$1" == "" ]; then
  echo "installing system prerequisites"
  . prereq_fmlist_scan
fi

if [ "$1" == "pre" ] || [ "$1" == "" ]; then
  echo "installing prerequisites"
  . prereq_librtlsdr
  . prereq_csdr
  . prereq_liquid-dsp
  . prereq_redsea
  . prereq_dab-cmdline
fi


if [ "$1" == "rtl" ] || [ "$1" == "" ]; then
  echo "building librtlsdr"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_librtlsdr"
  . inst_librtlsdr
fi

if [ "$1" == "csdr" ] || [ "$1" == "" ]; then
  echo "building csdr"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_csdr"
  . inst_csdr
fi

if [ "$1" == "lfec" ] || [ "$1" == "" ]; then
  echo "building libcorrect/libfec"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_libcorrect"
  . inst_libcorrect
fi

if [ "$1" == "ldsp" ] || [ "$1" == "" ]; then
  echo "building libliquid-dsp"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_liquid-dsp"
  . inst_liquid-dsp
fi

if [ "$1" == "redsea" ] || [ "$1" == "" ]; then
  echo "building redsea"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_redsea"
  . inst_redsea
fi

if [ "$1" == "dabcmd" ] || [ "$1" == "" ]; then
  echo "building dab-cmdline"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_dab-cmdline"
  . inst_dab-cmdline
fi

if [ "$1" == "pipwm" ] || [ "$1" == "" ]; then
  echo "building libwiringPi"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_wiringpi"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_pipwm"
  . setup_pipwm
fi

if [ "$1" == "chkspec" ] || [ "$1" == "" ]; then
  echo "building libliquid-dsp"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_liquid-dsp"
  . inst_liquid-dsp
  echo "building checkSpectrumForCarrier"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_checkSpectrum"
fi

if [ "$1" == "pscan" ] || [ "$1" == "" ]; then
  echo "building prescanDAB"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_prescanDAB"
fi

if [ "$1" == "kal" ] || [ "$1" == "" ]; then
  echo "building kal"
  sudo -u ${FMLIST_SCAN_USER} bash -c "source build_kal"
  . inst_kal
fi
