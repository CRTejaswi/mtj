% Library module for ferromagnet 
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

function [G0F,GF] = G_FM(P,lsf,rhoF,lF,Area,gsft,theta)

g= Area/rhoF/lF;
a=gsft; 
%% Series GF1 as a general angle theta
GF= [g g * P * cos(theta) -g * P * sin(theta) 0; g * P * cos(theta) -g * ...
(-P ^ 2 * lsf * sinh(lF / lsf) - lF + lF * P ^ 2) * cos(theta) ^ 2 / ...
lsf / sinh(lF / lsf) g * cos(theta) * (-P ^ 2 * lsf * sinh(lF / lsf) - lF + lF * P ^ 2) ...
* sin(theta) / lsf / sinh(lF / lsf) 0; -g * P * sin(theta) g * cos(theta) * (-P ^ 2 * lsf * sinh(lF / lsf) -...
 lF + lF * P ^ 2) * sin(theta) / lsf / sinh(lF / lsf) -g * sin(theta) ^ 2 * (-P ^ 2 * lsf * sinh(lF / lsf) - lF + lF * P ^ 2) ...
/ lsf / sinh(lF / lsf) 0; 0 0 0 0;];



G0F = [0 0 0 0;
 0 -g * (-lF * sinh(lF / lsf / 2) * cos(theta) ^ 2 + lF * sinh(lF / lsf / 2) *...
 P ^ 2 * cos(theta) ^ 2 - a * lsf * cosh(lF / lsf / 2) + cos(theta) ^ 2 * a * lsf * cosh(lF / lsf / 2)) ...
/ cosh(lF / lsf / 2) / lsf cos(theta) * g * sin(theta) * (-lF * tanh(lF / lsf / 2) + lF * tanh(lF / lsf / 2) ...
* P ^ 2 + a * lsf) / lsf 0; 0 cos(theta) * g * sin(theta) * (-lF * tanh(lF / lsf / 2) + lF * tanh(lF / lsf / 2) ...
* P ^ 2 + a * lsf) / lsf g * (lF * sinh(lF / lsf / 2) - lF * sinh(lF / lsf / 2) * cos(theta) ^ 2 - lF *...
 sinh(lF / lsf / 2) * P ^ 2 + lF * sinh(lF / lsf / 2) * P ^ 2 * cos(theta) ^ 2 + cos(theta) ^ 2 * a * ...
lsf * cosh(lF / lsf / 2)) / cosh(lF / lsf / 2) / lsf 0; 0 0 0 g * a;];


end
