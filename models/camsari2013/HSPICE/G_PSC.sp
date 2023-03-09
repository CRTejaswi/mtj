* Library module for FMI and NM interface
* Library module for ferromagnet 
* 
* Version 1.0.0alpha
* 
* Copyright @ 2017 Shehrin Sayed, Supriyo Datta Group, Purdue University
* 
* The terms under which the software and associated documentation (the Software) is provided are as the following:
*  
* The Software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.
*  
* Shehrin Sayed, Supriyo Datta Group, Purdue University grants, free of charge, to any users the right to modify, copy, and redistribute the Software, both within the user's organization and externally, subject to the following restrictions:
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
* Shehrin Sayed
* Library module for magnon diffusion in bulk of ferromagnetic insulators                    
*
* (c) Shehrin Sayed.
*************************************************************

.subckt G_PSC t1c t2c t1z t2z A='1e-18' L='1e-9' rho='1' lsf='1e-9' gc='1e-6'

* Internal parameters
.param gcse='A/(rho*L)'
.param gsse='gcse*(L/lsf)/sinh(L/lsf)'
.param gssh='gcse*(L/lsf)*tanh(L/(2*lsf))'

* Series t1-t2 
Rc12 t1c t2c r='1/Gc'
Rz12 t1z t2z r='1/gsse'

* Shunt for spin t1
Rz10 t1z 0 r='1/gssh'

* Shunt for spin t2
Rz20 t2z 0 r='1/gssh'

.ends


