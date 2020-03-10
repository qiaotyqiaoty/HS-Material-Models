/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/
/* Include files */
#include "ElasticPP.h"
#include "main.h"
#include "ElasticPP_terminate.h"
#include "ElasticPP_initialize.h"

/* Function Declarations */
static void argInit_1x50_real_T(double result[50]);
static void argInit_1xd21_char_T(char result_data[], int result_size[2]);
static char argInit_char_T(void);
static double argInit_real_T(void);
static void main_ElasticPP(void);

/* Function Definitions */
static void argInit_1x50_real_T(double result[50])
{
  int idx1;

  /* Loop over the array to initialize each element. */
  for (idx1 = 0; idx1 < 50; idx1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result[idx1] = argInit_real_T();
  }
}

static void argInit_1xd21_char_T(char result_data[], int result_size[2])
{
  int idx1;

  /* Set the size of the array.
     Change this size to the value that the application requires. */
  result_size[0] = 1;
  result_size[1] = 2;

  /* Loop over the array to initialize each element. */
  for (idx1 = 0; idx1 < 2; idx1++) {
    /* Set the value of the array element.
       Change this value to the value that the application requires. */
    result_data[idx1] = argInit_char_T();
  }
}

static char argInit_char_T(void)
{
  return '?';
}

static double argInit_real_T(void)
{
  return 0.0;
}

static void main_ElasticPP(void)
{
  char action_data[21];
  int action_size[2];
  double MatData[50];
  double Result;

  /* Initialize function 'ElasticPP' input arguments. */
  /* Initialize function input argument 'action'. */
  argInit_1xd21_char_T(action_data, action_size);

  /* Initialize function input argument 'MatData'. */
  /* Call the entry-point 'ElasticPP'. */
  argInit_1x50_real_T(MatData);
  Result = ElasticPP(action_data, action_size, MatData, argInit_real_T());
}

int main(int argc, const char * const argv[])
{
  (void)argc;
  (void)argv;

  /* Initialize the application.
     You do not need to do this more than one time. */
  ElasticPP_initialize();

  /* Invoke the entry-point functions.
     You can call entry-point functions multiple times. */
  main_ElasticPP();

  /* Terminate the application.
     You do not need to do this more than one time. */
  ElasticPP_terminate();
  return 0;
}

/* End of code generation (main.c) */
