*****************************************************************************
* Library module for Giant Spin Hall Effect
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
.subckt G_GSHE 1c 2c 3z 4z 3x 4x 3y 4y theta='-0.12' L='100*1e-9' W='250*1e-9'
+t='20*1e-9' rho='11.3*1e-8' lsf='40*1e-9' 

.param gc='t*W/L/rho'
.param gsse= 'W*L/rho/lsf/sinh(t/lsf)'
.param gssh= 'W*L/rho/lsf*tanh(t/2/lsf)'
.param gcz= 'W*theta/rho'


Rcc 1c 2c r='1/gc'
Gc1 1c 0  cur='-gcz*(v(3z)-v(4z))'
Gc2 2c 0  cur=' gcz*(v(3z)-v(4z))'

Rse  3z 4z r='1/gsse'
Rsh1 3z  0 r='1/gssh'
Rsh2 4z  0 r='1/gssh' 

Gs1 4z 0 cur='-gcz*(v(1c)-v(2c))'
Gs2 3z 0 cur='gcz*(v(1c)-v(2c))'

.ends
