*****************************************************************************
* Library module for fm|nm interface
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
*************************************************************************************
.subckt G_FM_NM cFM cNM zFM zNM xFM xNM yFM yNM  THETA PHI g='1' a='1' b='0'

* These formulas are obtained from  U(G)U’
* G = Gse or Gsh 
* U is the Rodriguez rotation matrix for (theta,phi) 
* 4x4 Conductance Matrix for the Series Component 

E11 d11 0 vol='g'
E12 d12 0 vol='g*P*cos(v(THETA))'
E13 d13 0 vol='g*P*sin(v(THETA))*cos(v(PHI))'
E14 d14 0 vol='g*P*sin(v(THETA))*sin(v(PHI))'

E21 d21 0 vol='g*P*cos(v(THETA))'
E22 d22 0 vol='(g)*cos(v(THETA))*cos(v(THETA))'
E23 d23 0 vol='(g)*sin(v(THETA))*cos(v(THETA))*cos(v(PHI))'
E24 d24 0 vol='(g)*sin(v(THETA))*cos(v(THETA))*sin(v(PHI))'

E31 d31 0 vol='g*P*sin(v(THETA))*cos(v(PHI))'
E32 d32 0 vol='(g)*sin(v(THETA))*cos(v(THETA))*cos(v(PHI))'
E33 d33 0 vol='(g)*sin(v(THETA))*sin(v(THETA))*cos(v(PHI))*cos(v(PHI))'
E34 d34 0 vol='(g)*sin(v(THETA))*sin(v(THETA))*cos(v(PHI))*sin(v(PHI))'

E41 d41 0 vol= '(g)*P*sin(v(THETA))*sin(v(PHI))'
E42 d42 0 vol= '(g)*sin(v(THETA))*cos(v(THETA))*sin(v(PHI))'
E43 d43 0 vol= '(g)*sin(v(THETA))*sin(v(THETA))*cos(v(PHI))*sin(v(PHI))'
E44 d44 0 vol='(g)*sin(v(THETA))*sin(v(THETA))*sin(v(PHI))*sin(v(PHI))'


GC11 cFM cNM cur='v(d11)*(v(cFM)-v(cNM))'
GC12 cFM cNM cur='v(d12)*(v(zFM)-v(zNM))'
GC13 cFM cNM cur='v(d13)*(v(xFM)-v(xNM))'
GC14 cFM cNM cur='v(d14)*(v(yFM)-v(yNM))'

GZ21 zFM zNM cur='v(d21)*(v(cFM)-v(cNM))'
GZ22 zFM zNM cur='v(d22)*(v(zFM)-v(zNM))'
GZ23 zFM zNM cur='v(d23)*(v(xFM)-v(xNM))'
GZ24 zFM zNM cur='v(d24)*(v(yFM)-v(yNM))'


GX31 xFM xNM cur='v(d31)*(v(cFM)-v(cNM))'
GX32 xFM xNM cur='v(d32)*(v(zFM)-v(zNM))'
GX33 xFM xNM cur='v(d33)*(v(xFM)-v(xNM))'
GX34 xFM xNM cur='v(d34)*(v(yFM)-v(yNM))'

GY41 yFM yNM cur='v(d41)*(v(cFM)-v(cNM))'
GY42 yFM yNM cur='v(d42)*(v(zFM)-v(zNM))'
GY43 yFM yNM cur='v(d43)*(v(xFM)-v(xNM))'
GY44 yFM yNM cur='v(d44)*(v(yFM)-v(yNM))'

* 4x4 Conductance Matrix for the Shunt Component 
* First column is zero: No charge current through spin-shunts 

E55 d55 0 vol= 'g*a*sin(v(THETA))*sin(v(THETA))'
E56 d56 0 vol= '-g*sin(v(THETA))*(a*cos(v(PHI))*cos(v(THETA))+b*sin(v(PHI)))' 
E57 d57 0 vol= '-g*sin(v(THETA))*(a*sin(v(PHI))*cos(v(THETA))-b*cos(v(PHI)))' 

E65 d65  0 vol= 'g*sin(v(THETA))*(-a*cos(v(PHI))*cos(v(THETA))+b*sin(v(PHI)))' 
E66 d66  0 vol= 'g*a*( cos(v(PHI))*cos(v(PHI))*cos(v(THETA))*cos(v(THETA))+1-cos(v(PHI))*cos(v(PHI)))' 
E67 d67  0 vol= 'g*(-a*sin(v(PHI))*cos(v(PHI))+a*sin(v(PHI))*cos(v(PHI))*cos(v(THETA))*cos(v(THETA))-b*cos(v(THETA)))'

E75 d75  0 vol='-g*sin(v(THETA))*(a*sin(v(PHI))*cos(v(THETA))+b*cos(v(PHI)))'  
E76 d76  0 vol='g*(-a*sin(v(PHI))*cos(v(PHI))+a*sin(v(PHI))*cos(v(PHI))*cos(v(THETA))*cos(v(THETA))+b*cos(v(THETA)))'
E77 d77  0 vol='-g*a*(-cos(v(PHI))*cos(v(PHI))+cos(v(PHI))*cos(v(PHI))*cos(v(THETA))*cos(v(THETA))-cos(v(THETA))*cos(v(THETA)))' 

GZ55 zNM 0 cur='v(d55)*(v(zNM))'
GZ56 zNM 0 cur='v(d56)*(v(xNM))'
GZ57 zNM 0 cur='v(d57)*(v(yNM))'


GX65 xNM 0 cur='v(d65)*(v(zNM))'
GX66 xNM 0 cur='v(d66)*(v(xNM))'
GX67 xNM 0 cur='v(d67)*(v(yNM))'

GY75 yNM 0 cur='v(d75)*(v(zNM))'
GY76 yNM 0 cur='v(d76)*(v(xNM))'
GY77 yNM 0 cur='v(d77)*(v(yNM))'

.ends






