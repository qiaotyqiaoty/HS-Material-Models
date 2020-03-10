/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ElasticPP.c
 *
 * Code generation for function 'ElasticPP'
 *
 */

/* Include files */
#include <math.h>
#include "ElasticPP.h"

/* Function Definitions */
double ElasticPP(const char action_data[], const int action_size[2], double
                 MatData[50], double edp)
{
  double Result;
  double eyp;
  double eyn;
  double ep;
  double fyp;
  double fyn;
  double stressT;
  double strainT;
  double tangentT;
  double stressC;
  double strainC;
  boolean_T b_bool;
  int kstr;
  int exitg1;
  static const char cv0[10] = { 'i', 'n', 'i', 't', 'i', 'a', 'l', 'i', 'z', 'e'
  };

  double sigT;
  static const char cv1[14] = { 's', 'e', 't', 'T', 'r', 'i', 'a', 'l', 'S', 't',
    'r', 'a', 'i', 'n' };

  double b_sigT;
  static const char cv2[14] = { 's', 'e', 't', 'T', 'r', 'i', 'a', 'l', 'S', 't',
    'r', 'e', 's', 's' };

  static const char cv3[9] = { 'g', 'e', 't', 'S', 't', 'r', 'a', 'i', 'n' };

  static const char cv4[9] = { 'g', 'e', 't', 'S', 't', 'r', 'e', 's', 's' };

  static const char cv5[14] = { 'g', 'e', 't', 'F', 'l', 'e', 'x', 'i', 'b', 'i',
    'l', 'i', 't', 'y' };

  static const char cv6[12] = { 'g', 'e', 't', 'S', 't', 'i', 'f', 'f', 'n', 'e',
    's', 's' };

  static const char cv7[19] = { 'g', 'e', 't', 'I', 'n', 'i', 't', 'i', 'a', 'l',
    'S', 't', 'i', 'f', 'f', 'n', 'e', 's', 's' };

  static const char cv8[21] = { 'g', 'e', 't', 'I', 'n', 'i', 't', 'i', 'a', 'l',
    'F', 'l', 'e', 'x', 'i', 'b', 'i', 'l', 'i', 't', 'y' };

  static const char cv9[11] = { 'c', 'o', 'm', 'm', 'i', 't', 'S', 't', 'a', 't',
    'e' };

  /*  ========================================================================= */
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* %%%%%%%%%%%   ACTS Hardware-in-the-loop Simulation Software   %%%%%%%%%%%% */
  /* %%%%%%%%%%%%%%%%%%%%%%%%%   DO NOT DISTRIBUTE   %%%%%%%%%%%%%%%%%%%%%%%%%% */
  /* %%%%%%%%%%%%%%%% By Joe Tianyang Qiao, March, 2020 %%%%%%%%%%%%%%%%%%%%%%% */
  /* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% */
  /*  ========================================================================= */
  /*  ElasticPP (Elastic-Perfectly-Plastic) material */
  /*  varargout = ElasticPP(action,MatData,stress) */
  /*  */
  /*  action  : switch with following possible values */
  /*               'initialize'         initialize internal variables */
  /*               'setTrialStress'     set the trial stress */
  /*               'getStress'          get the current stress */
  /*               'getStrain'          get the current strain */
  /*               'getTangent'         get the current tangent flexibility */
  /*               'getInitialTangent'  get the initial tangent flexibility */
  /*               'commitState'        commit state of internal variables */
  /*  MatData : data structure with material information */
  /*  edp     : trial stress or strain */
  /*  extract material properties */
  /*  unique material tag */
  /*  Elastic modulus */
  eyp = MatData[2];

  /*  Positive yield strain */
  eyn = MatData[3];

  /*  Negative yield strain */
  /*  Initial strain (pre-stressing) */
  /*  state variables */
  ep = MatData[5];
  fyp = MatData[6];
  fyn = MatData[7];
  stressT = MatData[8];
  strainT = MatData[9];
  tangentT = MatData[10];
  stressC = MatData[11];
  strainC = MatData[12];
  Result = 0.0;
  b_bool = false;
  if (action_size[1] == 10) {
    kstr = 0;
    do {
      exitg1 = 0;
      if (kstr < 10) {
        if (action_data[kstr] != cv0[kstr]) {
          exitg1 = 1;
        } else {
          kstr++;
        }
      } else {
        b_bool = true;
        exitg1 = 1;
      }
    } while (exitg1 == 0);
  }

  if (b_bool) {
    kstr = 0;
  } else {
    b_bool = false;
    if (action_size[1] == 14) {
      kstr = 0;
      do {
        exitg1 = 0;
        if (kstr < 14) {
          if (action_data[kstr] != cv1[kstr]) {
            exitg1 = 1;
          } else {
            kstr++;
          }
        } else {
          b_bool = true;
          exitg1 = 1;
        }
      } while (exitg1 == 0);
    }

    if (b_bool) {
      kstr = 1;
    } else {
      b_bool = false;
      if (action_size[1] == 14) {
        kstr = 0;
        do {
          exitg1 = 0;
          if (kstr < 14) {
            if (action_data[kstr] != cv2[kstr]) {
              exitg1 = 1;
            } else {
              kstr++;
            }
          } else {
            b_bool = true;
            exitg1 = 1;
          }
        } while (exitg1 == 0);
      }

      if (b_bool) {
        kstr = 2;
      } else {
        b_bool = false;
        if (action_size[1] == 9) {
          kstr = 0;
          do {
            exitg1 = 0;
            if (kstr < 9) {
              if (action_data[kstr] != cv3[kstr]) {
                exitg1 = 1;
              } else {
                kstr++;
              }
            } else {
              b_bool = true;
              exitg1 = 1;
            }
          } while (exitg1 == 0);
        }

        if (b_bool) {
          kstr = 3;
        } else {
          b_bool = false;
          if (action_size[1] == 9) {
            kstr = 0;
            do {
              exitg1 = 0;
              if (kstr < 9) {
                if (action_data[kstr] != cv4[kstr]) {
                  exitg1 = 1;
                } else {
                  kstr++;
                }
              } else {
                b_bool = true;
                exitg1 = 1;
              }
            } while (exitg1 == 0);
          }

          if (b_bool) {
            kstr = 4;
          } else {
            b_bool = false;
            if (action_size[1] == 14) {
              kstr = 0;
              do {
                exitg1 = 0;
                if (kstr < 14) {
                  if (action_data[kstr] != cv5[kstr]) {
                    exitg1 = 1;
                  } else {
                    kstr++;
                  }
                } else {
                  b_bool = true;
                  exitg1 = 1;
                }
              } while (exitg1 == 0);
            }

            if (b_bool) {
              kstr = 5;
            } else {
              b_bool = false;
              if (action_size[1] == 12) {
                kstr = 0;
                do {
                  exitg1 = 0;
                  if (kstr < 12) {
                    if (action_data[kstr] != cv6[kstr]) {
                      exitg1 = 1;
                    } else {
                      kstr++;
                    }
                  } else {
                    b_bool = true;
                    exitg1 = 1;
                  }
                } while (exitg1 == 0);
              }

              if (b_bool) {
                kstr = 6;
              } else {
                b_bool = false;
                if (action_size[1] == 19) {
                  kstr = 0;
                  do {
                    exitg1 = 0;
                    if (kstr < 19) {
                      if (action_data[kstr] != cv7[kstr]) {
                        exitg1 = 1;
                      } else {
                        kstr++;
                      }
                    } else {
                      b_bool = true;
                      exitg1 = 1;
                    }
                  } while (exitg1 == 0);
                }

                if (b_bool) {
                  kstr = 7;
                } else {
                  b_bool = false;
                  if (action_size[1] == 21) {
                    kstr = 0;
                    do {
                      exitg1 = 0;
                      if (kstr < 21) {
                        if (action_data[kstr] != cv8[kstr]) {
                          exitg1 = 1;
                        } else {
                          kstr++;
                        }
                      } else {
                        b_bool = true;
                        exitg1 = 1;
                      }
                    } while (exitg1 == 0);
                  }

                  if (b_bool) {
                    kstr = 8;
                  } else {
                    b_bool = false;
                    if (action_size[1] == 11) {
                      kstr = 0;
                      do {
                        exitg1 = 0;
                        if (kstr < 11) {
                          if (action_data[kstr] != cv9[kstr]) {
                            exitg1 = 1;
                          } else {
                            kstr++;
                          }
                        } else {
                          b_bool = true;
                          exitg1 = 1;
                        }
                      } while (exitg1 == 0);
                    }

                    if (b_bool) {
                      kstr = 9;
                    } else {
                      kstr = -1;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  switch (kstr) {
   case 0:
    /*  ====================================================================== */
    strainT = 0.0;
    stressT = 0.0;
    strainC = 0.0;
    stressC = 0.0;
    tangentT = MatData[1];
    MatData[13] = MatData[1];
    if (MatData[2] < 0.0) {
      eyp = -MatData[2];
    }

    if (MatData[3] > 0.0) {
      eyn = -MatData[3];
    }

    fyp = MatData[1] * eyp;
    fyn = MatData[1] * eyn;
    ep = 0.0;

    /*  ====================================================================== */
    break;

   case 1:
    strainT = edp;

    /*  Compute temp trial stress (only using modulus) */
    sigT = MatData[1] * ((edp - MatData[4]) - MatData[5]);

    /*  Yield function */
    /*  Yield? */
    if (sigT >= 0.0) {
      b_sigT = sigT - MatData[6];
    } else {
      b_sigT = -sigT + MatData[7];
    }

    if (b_sigT <= -MatData[1] * 2.2204460492503131E-16) {
      /*  Not yielded */
      stressT = sigT;
      tangentT = MatData[1];
    } else {
      /*  Yielded */
      if (sigT > 0.0) {
        stressT = MatData[6] + 1.0E-10 * MatData[1];
      } else {
        stressT = MatData[7] - 1.0E-10 * MatData[1];
      }

      tangentT = 1.0E-10 * MatData[1];
    }

    /*  ====================================================================== */
    break;

   case 2:
    stressT = edp;

    /*  ====================================================================== */
    break;

   case 3:
    Result = MatData[9];

    /*  ====================================================================== */
    break;

   case 4:
    Result = MatData[8];
    break;

   case 5:
    /* x */
    if (fabs(MatData[10]) < 1.0E-10 * MatData[1]) {
      Result = 1.0E-10 * MatData[1];
    } else {
      Result = 1.0 / MatData[10];
    }
    break;

   case 6:
    Result = MatData[10];

    /*  ====================================================================== */
    break;

   case 7:
    Result = MatData[1];

    /*  ====================================================================== */
    break;

   case 8:
    Result = 1.0 / MatData[1];

    /*  ====================================================================== */
    break;

   case 9:
    sigT = MatData[1] * ((MatData[9] - MatData[4]) - MatData[5]);
    if (sigT >= 0.0) {
      stressC = sigT - MatData[6];
    } else {
      stressC = -sigT + MatData[7];
    }

    if (stressC > -MatData[1] * 2.2204460492503131E-16) {
      if (sigT > 0.0) {
        ep = MatData[5] + stressC / MatData[1];
      } else {
        ep = MatData[5] - stressC / MatData[1];
      }
    }

    strainC = MatData[9];
    stressC = MatData[8];
    MatData[13] = MatData[10];
    break;
  }

  /*  ====================================================================== */
  /*  Record */
  /*  unique material tag */
  MatData[2] = eyp;
  MatData[3] = eyn;
  MatData[5] = ep;
  MatData[6] = fyp;
  MatData[7] = fyn;
  MatData[8] = stressT;
  MatData[9] = strainT;
  MatData[10] = tangentT;
  MatData[11] = stressC;
  MatData[12] = strainC;
  return Result;
}

/* End of code generation (ElasticPP.c) */
