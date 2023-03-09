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

* This module was developed to use with the bulk PSC module
* (c) Shehrin Sayed.
*************************************************************

.subckt G_FMI_NM cFM cNM zFM zNM xFM xNM yFM yNM Gc='1e-6' gs='1' Gr='1' Gi='1'

.param gain='Gi/Gr'

*** series block ***
Rc cFM cNM r='1/Gc'
Rz zFM zNM r='1/gs'

*** shunt block ***
Rx xFM xNM r='1/Gr'
Gx xFM xNM cur='gain*(v(yFM)-v(yNM))'

Ry yFM yNM r='1/Gi'
Gy yFM yNM cur='-gain*(v(xFM)-v(xNM))'

.ends







