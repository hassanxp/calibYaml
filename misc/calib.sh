#!/bin/sh
set -uxe
ingestPfsCalibs.py /projects/HSC/PFS/Subaru --output=/projects/HSC/PFS/Subaru/CALIB --validity=1800 --create --doraise --mode=copy -- '/projects/HSC/PFS/Subaru/$DRP_STELLA_DATA_DIR/raw/detectorMap-sim-r1.fits' '/projects/HSC/PFS/Subaru/$DRP_STELLA_DATA_DIR/raw/detectorMap-sim-b1.fits'
constructPfsBias.py /projects/HSC/PFS/Subaru --calib=/projects/HSC/PFS/Subaru/CALIB --rerun=hassans/yaml/test_calib/bias --doraise --batch-type=smp --cores=1 --id field=BIAS
ingestPfsCalibs.py /projects/HSC/PFS/Subaru --output=/projects/HSC/PFS/Subaru/CALIB --validity=1800 --doraise --mode=copy -- /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/bias/BIAS/*.fits
constructPfsDark.py /projects/HSC/PFS/Subaru --calib=/projects/HSC/PFS/Subaru/CALIB --rerun=hassans/yaml/test_calib/dark --doraise --batch-type=smp --cores=1 --id field=DARK
ingestPfsCalibs.py /projects/HSC/PFS/Subaru --output=/projects/HSC/PFS/Subaru/CALIB --validity=1800 --doraise --mode=copy -- /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/dark/DARK/*.fits
constructFiberFlat.py /projects/HSC/PFS/Subaru --calib=/projects/HSC/PFS/Subaru/CALIB --rerun=hassans/yaml/test_calib/flat --doraise --batch-type=smp --cores=1 --id field=FLAT
ingestPfsCalibs.py /projects/HSC/PFS/Subaru --output=/projects/HSC/PFS/Subaru/CALIB --validity=1800 --doraise --mode=copy -- /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/flat/FLAT/*.fits
constructFiberProfiles.py /projects/HSC/PFS/Subaru --calib=/projects/HSC/PFS/Subaru/CALIB --rerun=hassans/yaml/test_calib/fiberProfiles --doraise --batch-type=smp --cores=1 --id field=FLAT_ODD
constructFiberProfiles.py /projects/HSC/PFS/Subaru --calib=/projects/HSC/PFS/Subaru/CALIB --rerun=hassans/yaml/test_calib/fiberProfiles --doraise --batch-type=smp --cores=1 --id field=FLAT_EVEN
mkdir /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/COMBINED
_get1stMatch() { if test -e "$1" ; then echo "$1" ; fi ; }
profiles0="$(_get1stMatch /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/pfsFiberProfiles-*-b1.fits)"
if [ -n "$profiles0" ]
then
    combineFiberProfiles.py \
        /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/COMBINED/"$(basename "$profiles0")" \
        /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/pfsFiberProfiles-*-b1.fits
fi
profiles0="$(_get1stMatch /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/pfsFiberProfiles-*-r1.fits)"
if [ -n "$profiles0" ]
then
    combineFiberProfiles.py \
        /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/COMBINED/"$(basename "$profiles0")" \
        /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/pfsFiberProfiles-*-r1.fits
fi
profiles0="$(_get1stMatch /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/pfsFiberProfiles-*-m1.fits)"
if [ -n "$profiles0" ]
then
    combineFiberProfiles.py \
        /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/COMBINED/"$(basename "$profiles0")" \
        /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/pfsFiberProfiles-*-m1.fits
fi
profiles0="$(_get1stMatch /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/pfsFiberProfiles-*-n1.fits)"
if [ -n "$profiles0" ]
then
    combineFiberProfiles.py \
        /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/COMBINED/"$(basename "$profiles0")" \
        /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/pfsFiberProfiles-*-n1.fits
fi
ingestPfsCalibs.py /projects/HSC/PFS/Subaru --output=/projects/HSC/PFS/Subaru/CALIB --validity=1800 --doraise --mode=copy -- /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/fiberProfiles/FIBERPROFILES/COMBINED/*.fits
reduceArc.py /projects/HSC/PFS/Subaru --calib=/projects/HSC/PFS/Subaru/CALIB --rerun=hassans/yaml/test_calib/detectorMap --doraise -j1 --id field=ARC
ingestPfsCalibs.py /projects/HSC/PFS/Subaru --output=/projects/HSC/PFS/Subaru/CALIB --validity=1800 --doraise --mode=copy --config clobber=True -- /projects/HSC/PFS/Subaru/rerun/hassans/yaml/test_calib/detectorMap/DETECTORMAP/*.fits
