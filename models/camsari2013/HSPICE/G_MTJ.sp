*****************************************************************************
* Library module for MTJ
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
.subckt G_MTJ 1c 2c 1z 2z 1x 2x 1y 2y THETA sz sx sy  

.param inf = 1e20

Gcc 1c 2c cur='G0*(1+P*P*cos(v(THETA)))*(v(1c)-v(2c))'
Gzz 1z 2z cur='G0*inf*(v(1z)-v(2z))'
Gxx 1x 2x cur='G0*inf*(v(1x)-v(2x))'
Gyy 1y 2y cur='G0*inf*(v(1y)-v(2y))'


Ezz sz 0 vol='conv*-i(Gzz)'
Exx sx 0 vol='conv*-i(Gxx)'
Eyy sy 0 vol='conv*-i(Gyy)'


.ends
