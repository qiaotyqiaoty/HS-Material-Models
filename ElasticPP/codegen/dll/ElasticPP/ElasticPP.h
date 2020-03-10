/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ElasticPP.h
 *
 * Code generation for function 'ElasticPP'
 *
 */

#ifndef ELASTICPP_H
#define ELASTICPP_H

/* Include files */
#include <stddef.h>
#include <stdlib.h>
#include "rtwtypes.h"
#include "ElasticPP_types.h"

/* Function Declarations */
#ifdef __cplusplus

extern "C" {

#endif

  extern double ElasticPP(const char action_data[], const int action_size[2],
    double MatData[50], double edp);

#ifdef __cplusplus

}
#endif
#endif

/* End of code generation (ElasticPP.h) */
