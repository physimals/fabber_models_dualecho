include ${FSLCONFDIR}/default.mk

PROJNAME = fabber_dualecho

USRINCFLAGS = -I${INC_NEWMAT} -I${INC_PROB} -I${INC_BOOST} 
USRLDFLAGS = -L${LIB_NEWMAT} -L${LIB_PROB}

LIBS = -lutils -lnewimage -lmiscmaths -lprob -lnewmat -lfslio -lniftiio -lznz -lz -ldl

XFILES = fabber

# Forward models
OBJS =  fwdmodel_pcASL.o fwdmodel_q2tips.o fwdmodel_quipss2.o

# For debugging:
OPTFLAGS = -ggdb
#OPTFLAGS =

#
# Build
#

all:	${XFILES} libfabbermodels_dualecho.a

# models in a library
libfabbermodels_dualecho.a : ${OBJS}
	${AR} -r $@ ${OBJS}

# fabber built from the FSL fabbercore library including the models specifieid in this project
fabber : fabber_client.o ${OBJS}
	${CXX} ${CXXFLAGS} ${LDFLAGS} -o $@ $< ${OBJS} -lfabbercore -lfabberexec ${LIBS}

# DO NOT DELETE
