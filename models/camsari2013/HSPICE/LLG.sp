* Library module for LLG
* 
* Version 1.0.1alpha
* 
* Copyright @ 2015 Kerem Y. Camsari, Samiran Ganguly, Supriyo Datta Group, Purdue University
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
* February 2015
*************************

.subckt LLG_BLOCK Theta Phi HSX HSY HSZ 

CTHETA Theta 0 c='tau'
CPHI Phi 0 c='tau'
GTHETA 0 Theta cur='-sin(v(Theta)) * hp * cos(v(Phi)) * sin(v(Phi)) - sin(v(Theta)) * alpha * cos(v(Theta)) - sin(v(Theta)) * alpha * hp * cos(v(Phi)) ^ 2 * cos(v(Theta)) - hs * v(HSZ) * sin(v(Theta)) + hs * sin(v(Phi)) * v(HSY) * cos(v(Theta)) + hs * cos(v(Phi)) * v(HSX) * cos(v(Theta)) + hs * cos(v(Phi)) * alpha * v(HSY) - hs * sin(v(Phi)) * alpha *v(HSX)'
GPHI   0 Phi   cur='alpha * hp * sin(v(Phi)) * cos(v(Phi)) - cos(v(Phi)) ^ 2 * cos(v(Theta)) * hp - cos(v(Theta)) - hs * (v(HSX) * sin(v(Phi)) - alpha * v(HSZ) * sin(v(Theta)) + alpha * cos(v(Theta)) * v(HSY) * sin(v(Phi)) + cos(v(Phi)) * alpha * cos(v(Theta)) * v(HSX) - cos(v(Phi)) * v(HSY)) / sin(v(Theta))'

EMX 6  0 vol='sin(v(Theta))*cos(v(Phi))'
EMY 7  0 vol='sin(v(Theta))*sin(v(Phi))'
EMZ 8  0 vol='cos(v(Theta))'

.ends
