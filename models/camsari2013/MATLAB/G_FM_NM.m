% Library module for ferromagnet-non magnet interface
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
function [G_FM_NMse,G_FM_NMsh]=G_FM_NM(G,P,a,b,Area,theta,phi)

G0=G*Area;

%% g11 is the 'rotated' interface matrix, given analytically as a function of theta and phi

G_FM_NMse= G0*   [1                       P*cos(theta)                     P*sin(theta)*cos(phi)           P*sin(theta)*sin(phi) ; 
                 P*cos(theta)            cos(theta)^2                     sin(theta)*cos(theta)*cos(phi)  sin(theta)*cos(theta)*sin(phi);
                 P*sin(theta)*cos(phi)   sin(theta)*cos(theta)*cos(phi)  sin(theta)^2*cos(phi)^2         sin(theta)^2*cos(phi)*sin(phi);                      
                 P*sin(theta)*sin(phi)   sin(theta)*cos(theta)*sin(phi) sin(theta)^2*cos(phi)*sin(phi)  sin(theta)^2*sin(phi)^2];
                

G_FM_NMsh=G0*  [    0       0                                               0                                                                               0       ;
                    0    a*sin(theta)^2                                  sin(theta)*(-a*cos(phi)*cos(theta))+b*sin(phi)                               -sin(theta)*(a*sin(phi)*cos(theta))+b*cos(phi);
                    0    -sin(theta)*(a*cos(phi)*cos(theta))+b*sin(phi)   a*(cos(phi)^2)*cos(theta)^2+1-cos(phi)^2                                    (-a*sin(phi)*cos(phi)+a*sin(phi)*cos(phi)*cos(theta)*cos(theta)+b*cos(theta));
                    0    -sin(theta)*(a*sin(phi)*cos(theta))-b*cos(phi)   (-a*sin(phi)*cos(phi)+a*sin(phi)*cos(phi)*cos(theta)^2-b*cos(theta))        -a*(-cos(phi)*cos(phi)+cos(phi)*cos(phi)*cos(theta)*cos(theta)-cos(theta)*cos(theta))]; 
                

end
