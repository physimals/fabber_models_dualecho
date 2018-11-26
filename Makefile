include ${FSLCONFDIR}/default.mk

PROJNAME = fabber_dualecho

USRINCFLAGS = -I${INC_NEWMAT} -I${INC_PROB} -I${INC_BOOST} -I..
USRLDFLAGS = -L${LIB_NEWMAT} -L${LIB_PROB} -L../fabber_core

FSLVERSION= $(shell cat ${FSLDIR}/etc/fslversion | head -c 1)
ifeq ($(FSLVERSION), 6) 
  NIFTILIB = -lNewNifti
else 
  NIFTILIB = -lfslio -lniftiio 
endif

LIBS = -lutils -lnewimage -lmiscmaths -lprob -lnewmat ${NIFTILIB} -lznz -lz -ldl

XFILES = fabber_dualecho

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

all:	${XFILES} libfabber_models_dualecho.a

# models in a library
libfabber_models_dualecho.a : ${OBJS}
	${AR} -r $@ ${OBJS}

# fabber built from the FSL fabbercore library including the models specifieid in this project
fabber_dualecho : fabber_client.o ${OBJS}
	${CXX} ${CXXFLAGS} ${LDFLAGS} -o $@ $< ${OBJS} -lfabbercore -lfabberexec ${LIBS}

# DO NOT DELETE
