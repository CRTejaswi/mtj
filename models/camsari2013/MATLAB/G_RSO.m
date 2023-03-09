% Library module for Rashba Spin-Orbit
%  
%  Version 1.0.0alpha
%  
%  Copyright @ 2014  Kerem Y. Camsari, Samiran Ganguly, Supriyo Datta Group, Purdue University
%  
%  The terms under which the software and associated documentation (the Software) is provided are as the following:
%   
%  The Software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the Software or the use or other dealings in the Software.
%   
%  Kerem Y. Camsari and Samiran Ganguly, Supriyo Datta Group, Purdue University grants, free of charge, to any users the right to modify, copy, and redistribute the Software, both within the user's organization and externally, subject to the following restrictions:
%   
%  1. The users agree not to charge for the code itself but may charge for additions, extensions, or support.
%   
%  2. In any product based on the Software, the users agree to acknowledge the Research Group that developed the software. This acknowledgment shall appear in the product documentation.
%   
%  3. The users agree to obey all U.S. Government restrictions governing redistribution or export of the software.
%   
%  4. The users agree to reproduce any copyright notice which appears on the software on any copy or modification of such made available to others.
%   
%  Agreed to by 
%  Kerem Y. Camsari
%  Samiran Ganguly
%  September 2014
% 
function [rso11,rso12,rso21,rso22] = G_RSO(G0,rashba,m,LCH)
hbar=1.06e-34;
theta =2*m*rashba*LCH/hbar^2; 
 
rso11 = eye(4)*G0;
rso22 = eye(4)*G0; 

rso12 = G0*[1   0       0       0;
        0 cos(theta)  sin(theta)   0;
        0 -sin(theta)  cos(theta)  0; 
        0  0  0 0];

rso21=  G0*[1 0 0 0;
        0 cos(theta)  -sin(theta)  0 ;
        0 +sin(theta)  cos(theta)  0  ; 
        0  0     0 0     ];


end