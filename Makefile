include ${FSLCONFDIR}/default.mk

PROJNAME = fabber_dualecho
LIBS = -lfsl-fabber_models_dualecho -lfsl-fabberexec -lfsl-fabbercore \
       -lfsl-newimage -lfsl-miscmaths -lfsl-utils -lfsl-cprob \
       -lfsl-NewNifti -lfsl-znz -ldl
XFILES = fabber_dualecho
SOFILES = libfsl-fabber_models_dualecho.so

# Forward models
OBJS =  fwdmodel_pcASL.o fwdmodel_q2tips.o fwdmodel_quipss2.o

# For debugging:
#OPTFLAGS = -ggdb

# Pass Git revision details
GIT_SHA1:=$(shell git describe --match=NeVeRmAtCh --always --abbrev=40 --dirty)
GIT_DATE:=$(shell git log -1 --format=%ad --date=local)
CXXFLAGS += -DGIT_SHA1=\"${GIT_SHA1}\" -DGIT_DATE="\"${GIT_DATE}\""

#
# Build
#

all: ${XFILES} ${SOFILES}

# models in a library
libfsl-fabber_models_dualecho.so : ${OBJS}
	${CXX} ${CXXFLAGS} -shared -o $@ $^

# fabber built from the FSL fabbercore library including the models specifieid in this project
fabber_dualecho : fabber_client.o libfsl-fabber_models_dualecho.so
	${CXX} ${CXXFLAGS} -o $@ $< ${LDFLAGS}

# DO NOT DELETE
