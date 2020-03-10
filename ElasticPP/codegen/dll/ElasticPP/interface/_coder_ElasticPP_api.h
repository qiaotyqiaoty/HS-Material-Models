/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_ElasticPP_api.h
 *
 * Code generation for function '_coder_ElasticPP_api'
 *
 */

#ifndef _CODER_ELASTICPP_API_H
#define _CODER_ELASTICPP_API_H

/* Include files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_ElasticPP_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
#ifdef __cplusplus

extern "C" {

#endif

  extern real_T ElasticPP(char_T action_data[], int32_T action_size[2], real_T
    MatData[50], real_T edp);
  extern void ElasticPP_api(const mxArray *prhs[3], int32_T nlhs, const mxArray *
    plhs[2]);
  extern void ElasticPP_atexit(void);
  extern void ElasticPP_initialize(void);
  extern void ElasticPP_terminate(void);
  extern void ElasticPP_xil_shutdown(void);
  extern void ElasticPP_xil_terminate(void);

#ifdef __cplusplus

}
#endif
#endif

/* End of code generation (_coder_ElasticPP_api.h) */
