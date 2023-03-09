*****************************************************************************
* Library module for Rashba Spin-Orbit
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
 
.subckt G_RSO V1c V2c V1z V2z V1x V2x V1y V2y

GCC1 V1c 0 cur='G0 * v(V1c) - G0 * v(V2c)'
GZZ1 V1z 0 cur='G0 * v(V1z) - G0 * cos(theta) * v(V2z) - G0 * sin(theta) * v(V2x)'
GXX1 V1x 0 cur='G0 * v(V1x) + G0 * sin(theta) * v(V2z) - G0 * cos(theta) * v(V2x)'
GYY1 V1y 0 cur='G0 * v(V1y) - G0 * v(V2y)'


GCC2 V2c 0 cur='G0 * v(V2c) - G0 * v(V1c)'
GZZ2 V2z 0 cur='G0 * v(V2z) - G0 * cos(theta) * v(V1z) + G0 * sin(theta) * v(V1x)'
GXX2 V2x 0 cur='G0 * v(V2x) - G0 * sin(theta) * v(V1z) - G0 * cos(theta) * v(V1x)'
GYY2 V2y 0 cur='G0 * v(V2y) - G0 * v(V1y)'
.ends
