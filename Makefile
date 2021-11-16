include ${FSLCONFDIR}/default.mk

PROJNAME = fabber_dualecho
XFILES   = fabber_dualecho
SOFILES  = libfsl-fabber_models_dualecho.so
AFILES   = libfabber_models_dualecho.a

# The FSL build system changed
# substantially in FSL 6.0.6
# FSL >= 6.0.6
ifeq (${FSL_GE_606}, true)
  LIBS = -lfsl-fabberexec -lfsl-fabbercore -lfsl-newimage \
         -lfsl-miscmaths -lfsl-utils -lfsl-cprob \
         -lfsl-NewNifti -lfsl-znz -ldl
# FSL <= 6.0.5
else
  ifeq ($(shell uname -s), Linux)
    MATLIB := -lopenblas
  endif
  USRINCFLAGS = -I${INC_NEWMAT} -I${INC_CPROB} -I${INC_BOOST} -I.. \
                -I${FSLDIR}/extras/include/armawrap
  USRLDFLAGS  = -L${LIB_NEWMAT} -L${LIB_CPROB} -L../fabber_core  \
                -lfabberexec -lfabbercore -lnewimage -lmiscmaths \
                -lutils -lcprob ${MATLIB} -lNewNifti -lznz -lz -ldl
endif


# Forward models
OBJS =  fwdmodel_pcASL.o fwdmodel_q2tips.o fwdmodel_quipss2.o

# For debugging:
#OPTFLAGS = -ggdb

# Pass Git revision details
GIT_SHA1 := $(shell git describe --match=NeVeRmAtCh --always --abbrev=40 --dirty)
GIT_DATE := $(shell git log -1 --format=%ad --date=local)
CXXFLAGS += -DGIT_SHA1=\"${GIT_SHA1}\" -DGIT_DATE="\"${GIT_DATE}\""

#
# Build
#

# FSL >=606 uses dynamic linking
ifeq (${FSL_GE_606}, true)

all: ${XFILES} ${SOFILES}

# models in a library
libfsl-fabber_models_dualecho.so : ${OBJS}
	${CXX} ${CXXFLAGS} -shared -o $@ $^ ${LDFLAGS}

# fabber built from the FSL fabbercore library including the models specifieid in this project
fabber_dualecho : fabber_client.o | libfsl-fabber_models_dualecho.so
	${CXX} ${CXXFLAGS} -o $@ $< -lfsl-fabber_models_dualecho ${LDFLAGS}

# FSL <=605 uses static linking
else

all: ${XFILES} ${AFILES}

libfabber_models_dualecho.a : ${OBJS}
	${AR} -r $@ $^

fabber_dualecho : fabber_client.o ${OBJS}
	${CXX} ${CXXFLAGS} -o $@ $^ ${LDFLAGS}

endif
