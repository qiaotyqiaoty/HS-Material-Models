# Supplemental Material Models for HSS

Adding the following materials to HSS software:

+ [Elastic02](#elastic02)
+ [ElasticPP](#elasticpp)
+ [ElasticNoTension](#elasticnotension)
+ [Concrete01](#concrete01)
+ [SelfCentering](#selfcentering)
+ [BoucWen](#boucwen)


**IMPORTANT NOTE: **

**These materials ONLY work for displacement-control!!**




### Elastic02

This is a elastic material with different elastic modulus in tension and in compression.

2 parameter should be defined for Elastic02 model:

* Epos: 	elastic modulus under positive strain (tensile elastic modulus)

* Eneg:	elastic modulus under negative strain (compressive elastic modulus)

Negative elastic modulus values will be changed to positive. 

![Elastic02_sample](https://github.com/qiaotyqiaoty/HS-Material-Models/blob/master/fig/Elastic02_sample.png)

### ElasticPP

4 parameter should be defined for Elastic02 model:

* E: 	elastic modulus

* epsyP:	strain at positive yielding point (must be positive value)

* epsyN: 	strain at negative yielding point (must be negative value)

* ezero:  initial strain (put zero if normal material, put strain here to model pre-stressing)

Negative elastic modulus values will be changed to positive. 

![ElasticPP_sample](https://github.com/qiaotyqiaoty/HS-Material-Models/blob/master/fig/ElasticPP_sample.png)

### ElasticNoTension

1 parameter should be defined for ElasticNoTension model:

* E: 	elastic modulus

Zero stress is forced when strain > 0 (no tension stress).

![ElasticNoTension_sample](https://github.com/qiaotyqiaoty/HS-Material-Models/blob/master/fig/ElasticNoTension_sample.jpg)

### Concrete01

4 parameters should be defined for Concrete01 model:

* fpc: 	concrete maximum compressive strength (double, must be negative)

* epsc: 	concrete strain at maximum strength (double, must be negative)

* fpcu: 	concrete crushing strength (double, must be negative)

* epscu:	concrete strain at crushing strength (double, must be negative)

Tips:

- The initial slope (i.e. 'Modulus of Elasticity') for this model is: 2*fpc/epsc.
  $$
  E_{c} = \frac{2\times fpc}{epsc}
  $$

- All properties should be input as negative values. If not, they will be converted to negative automatically.

- This material is developed based on the OpenSees material 'Concrete01'. 

- This material model behaves very similarly as Concrete01 in OpenSees. See source code at OpenSees Github: https://github.com/OpenSees/OpenSees/blob/master/SRC/material/uniaxial/Concrete01.cpp

![Concrete01_sample](https://github.com/qiaotyqiaoty/HS-Material-Models/blob/master/fig/Concrete01_sample.png)


### SelfCentering

7 parameters should be defined for SelfCentering model:

* k1

* k2

* ActF

* beta

* epsSlip

* epsBear

* rBear

This material is programmed based on OpenSees. Please see OpenSees Wiki to determine the parameters above.

SelfCentering model:

![ElasticNoTension_model](https://github.com/qiaotyqiaoty/HS-Material-Models/blob/master/fig/SelfCentering_model.png)

SelfCentering sample:

![ElasticNoTension_sample](https://github.com/qiaotyqiaoty/HS-Material-Models/blob/master/fig/SelfCentering_sample.png)

SelfCentering sample with slippage:

![ElasticNoTension_sample2](https://github.com/qiaotyqiaoty/HS-Material-Models/blob/master/fig/SelfCentering_sample2.png)


### BoucWen

8 parameters should be defined:

* alpha: ratio of post-yield stiffness to the initial elastic stiffenss (0<alpha<1)

* ko: initial elastic stiffness

* n: parameter that controls transition from linear to nonlinear range (as n increases the transition becomes sharper; n is usually grater or equal to 1)

* gamma: parameters that control shape of hysteresis loop

* beta: parameters that control shape of hysteresis loop

* Ao: parameters that control tangent stiffness

* tolerance: tolerance for iterations, default 0.00001

* maxNumIter: maximum number of iterations, default 20

![BoucWenSample](https://github.com/qiaotyqiaoty/HS-Material-Models/blob/master/fig/Sample_BoucWen.png)
