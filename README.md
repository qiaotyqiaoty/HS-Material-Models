# Supplemental Material Models for HSS
[TOC]

## All Materials

### Elastic02

2 parameter should be defined for Elastic02 model:

​	Epos: 	elastic modulus under positive strain (tensile elastic modulus)

​	Eneg:	elastic modulus under negative strain (compressive elastic modulus)

Negative elastic modulus values will be changed to positive. 



### ElasticNoTension

1 parameter should be defined for ElasticNoTension model:

​	E: 	elastic modulus

Zero stress is forced when strain > 0 (no tension stress).

![ElasticNoTension_sample](.\fig\ElasticNoTension_sample.jpg)

### Concrete01

4 parameters should be defined for Concrete01 model:

​	fpc: 	concrete maximum compressive strength (double, must be negative)

​	epsc: 	concrete strain at maximum strength (double, must be negative)

​	fpcu: 	concrete crushing strength (double, must be negative)

​	epscu:	concrete strain at crushing strength (double, must be negative)

Tips:

- The initial slope (i.e. 'Modulus of Elasticity') for this model is: 2*fpc/epsc.
  $$
  E_{c} = \frac{2\times fpc}{epsc}
  $$

- All properties should be input as negative values. If not, they will be converted to negative automatically.

- This material is developed based on the OpenSees material 'Concrete01'. 

- This material model behaves very similarly as Concrete01 in OpenSees. See source code at OpenSees Github: https://github.com/OpenSees/OpenSees/blob/master/SRC/material/uniaxial/Concrete01.cpp

![Concrete01_sample](.\fig\Concrete01_sample.png)

### SelfCentering



### SelfCentering02









Material models update for hybrid simulation, based on OpenSees