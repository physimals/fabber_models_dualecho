/* dualecho_models.cc Shared library functions for dualecho models

Copyright (C) 2010-2011 University of Oxford */

/* CCOPYRIGHT  */

#include "dualecho_models.h"
#include "fwdmodel_pcASL.h"
#include "fwdmodel_q2tips.h"
#include "fwdmodel_quipss2.h"

extern "C" {
int CALL get_num_models()
{
    return 3;
}

const char *CALL get_model_name(int index)
{
    switch (index)
    {
    case 0:
        return "pcASL";
        break;
    case 1:
        return "q2tips";
        break;
    case 2:
        return "quipss2";
        break;
    default:
        return NULL;
    }
}

NewInstanceFptr CALL get_new_instance_func(const char *name)
{
    if (string(name) == "pcASL")
    {
        return pcASLFwdModel::NewInstance;
    }
    else if (string(name) == "q2tips")
    {
        return Q2tipsFwdModel::NewInstance;
    }
    else if (string(name) == "quipss2")
    {
        return Quipss2FwdModel::NewInstance;
    }
    else
    {
        return NULL;
    }
}
}
