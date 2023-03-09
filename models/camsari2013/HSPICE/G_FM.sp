*****************************************************************************
* Library module for ferromagnet
*
* Version 1.0.0alpha
*
* Copyright @ 2014 Kerem Y. Camsari, Samiran Ganguly, Supriyo Datta Group, Purdue University
*
* The terms under which the software and associated documentation (the Software) is provided are as the following:
*
* The Software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.
*
* Kerem Y. Camsari, Samiran Ganguly Supriyo Datta Group, Purdue University grants, free of charge, to any users the right to modify, copy, and redistribute the Software, both within the user's organization and externally, subject to the following restrictions:
*
* 1. The users agree not to charge for the code itself but may charge for additions, extensions, or support.
*
* 2. In any product based on the Software, the users agree to acknowledge the Research Group that developed the software. This acknowledgment shall appear in the product documentation.
*
* 3. The users agree to obey all U.S. Government restrictions governing redistribution or export of the software.
*
* 4. The users agree to reproduce any copyright notice which appears on the software on any copy or modification of such made available to others.
*
* Agreed to by
* Kerem Y. Camsari
* Samiran Ganguly
* September 2014
*************************************************************************
.subckt G_FM2 1c 2c 1z 2z 1x 2x 1y 2y THETA A='1e-14'  L='1e-7'  rho='19*1e-8'
+lsf='5e-9' P='0.23'
.param g='A/(rho*L)'
.param inf=101


Gc12 1c 2c cur='g * (v(1c) - v(2c) + P * cos(v(THETA)) * v(1z) - P * cos(v(THETA)) * v(2z) - P
+* sin(v(THETA)) * v(1x) + P * sin(v(THETA)) * v(2x))'

Gz12 1z 2z cur='g * cos(v(THETA)) * (P * lsf * sinh(L / lsf) * v(1c) - P * lsf * sinh(L / lsf) * v(2c) + cos(v(THETA)) *
+P * P * lsf * sinh(L / lsf) * v(1z) - cos(v(THETA)) * P * P * lsf * sinh(L / lsf) * v(2z) + cos(v(THETA)) * L * v(1z) - cos(v(THETA))
+* L * v(2z) - cos(v(THETA)) * L * P * P * v(1z) + cos(v(THETA)) * L * P * P * v(2z) - sin(v(THETA)) * P * P * lsf * sinh(L / lsf)
+* v(1x) + sin(v(THETA)) * P * P * lsf * sinh(L / lsf) * v(2x) - sin(v(THETA)) * L * v(1x) + sin(v(THETA)) * L * v(2x) + sin(v(THETA)) *
+L * P * P * v(1x) - sin(v(THETA)) * L * P * P * v(2x)) / lsf / sinh(L / lsf)'


Gx12 1x 2x cur = '-g * sin(v(THETA)) * (P * lsf * sinh(L / lsf) * v(1c) - P * lsf * sinh(L / lsf)
+* v(2c) + cos(v(THETA)) * P * P * lsf * sinh(L / lsf) * v(1z) - cos(v(THETA)) * P * P * lsf * sinh(L / lsf) *
+v(2z) + cos(v(THETA)) * L * v(1z) - cos(v(THETA)) * L * v(2z) - cos(v(THETA)) * L * P * P * v(1z) + cos(v(THETA)) * L * P * P * v(2z) - sin(v(THETA))
+* P * P * lsf * sinh(L / lsf) * v(1x) + sin(v(THETA)) * P * P * lsf * sinh(L / lsf) * v(2x) - sin(v(THETA)) * L * v(1x) + sin(v(THETA))
+* L * v(2x) + sin(v(THETA)) * L * P * P * v(1x) - sin(v(THETA)) * L * P * P * v(2x)) / lsf / sinh(L / lsf)'


Gz11 1z 0 cur='-g * (-L * sinh(L / lsf / 2) * cos(v(THETA))*cos(v(THETA)) + L * sinh(L / lsf / 2) *
+P * P * cos(v(THETA))*cos(v(THETA)) - inf * lsf * cosh(L / lsf / 2) + cos(v(THETA))*cos(v(THETA)) *
+inf * lsf * cosh(L / lsf / 2)) / cosh(L / lsf / 2) / lsf * v(1z) + cos(v(THETA)) * g * sin(v(THETA)) *
+(-L * tanh(L / lsf / 2) + L * tanh(L / lsf / 2) *
+P * P + inf * lsf) / lsf * v(1x)'

Gx11 1x 0  cur='cos(v(THETA)) * g * sin(v(THETA)) * (-L * tanh(L / lsf / 2) + L * tanh(L / lsf / 2) *
+P * P + inf * lsf) / lsf * v(1z) + g * (L * sinh(L / lsf / 2) - L * sinh(L / lsf / 2) *
+cos(v(THETA))*cos(v(THETA)) - L * sinh(L / lsf / 2) * P * P + L * sinh(L / lsf / 2) * P * P *
+cos(v(THETA))*cos(v(THETA)) + cos(v(THETA))*cos(v(THETA))
+* inf * lsf * cosh(L / lsf / 2)) /
+cosh(L / lsf / 2) / lsf * v(1x)'


Gy11 1y 0  cur='g*inf*v(1y)'


Gz22 2z 0  cur='-g * (-L * sinh(L / lsf / 2) * cos(v(THETA))*cos(v(THETA)) + L * sinh(L / lsf / 2)
+* P * P * cos(v(THETA))*cos(v(THETA)) - inf * lsf * cosh(L / lsf / 2) + cos(v(THETA))*cos(v(THETA))
+* inf * lsf * cosh(L / lsf / 2)) / cosh(L / lsf / 2) / lsf * v(2z) + cos(v(THETA)) *
+g * sin(v(THETA)) * (-L * tanh(L / lsf / 2) + L * tanh(L / lsf / 2)
+* P * P + inf * lsf) / lsf * v(2x)'

Gx22 2x 0  cur='cos(v(THETA)) * g * sin(v(THETA)) * (-L * tanh(L / lsf / 2) + L * tanh(L / lsf / 2) *
+P * P + inf * lsf) / lsf * v(2z) + g * (L * sinh(L / lsf / 2) - L * sinh(L / lsf / 2) *
+cos(v(THETA))*cos(v(THETA)) - L * sinh(L / lsf / 2) * P * P + L * sinh(L / lsf / 2) * P * P * cos(v(THETA))*cos(v(THETA))
+ + cos(v(THETA))*cos(v(THETA)) * inf * lsf * cosh(L / lsf / 2)) / cosh(L / lsf / 2) / lsf * v(2x)'


Gy22 2y 0  cur='g*inf*v(2y)'

.tran 3m
.probe v(✯) i (✯)
.ends
