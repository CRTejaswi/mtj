% Library module for Giant Spin Hall Effect
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

function [GSHE]=GSHE_CALL
global lambda rho t w leff
%%  Taken from Supplementary Otani - PRL 2012 156602
t = 20*1e-9  ;  % m
w = 250*1e-9 ;  % m 
%% Effective length is the width of the Copper wire.
leff=100*1e-9; %m
 %% Parameters from PRL 156602
%for Cu
%rho=6.3*1e-8
% for CuBI
rho=11.3*1e-8;
 % for CuIr
 %rho =14*1e-8;

sigma=1/rho;
%% The CuBi spin-flip
lambda = 40*1e-9; % for CuBi 
%lambda = 10*1e-9; % for Pt
%lambda = 1300*1e-9; % for Cu
%lambda =  ?? % for CuIr

theta = -0.12;  % for CuBi
%theta = 0.021;   % for Pt 
%theta = 0 ; % for Cu
%theta = 0.021; % for CuIr   
%% Effective Area (After Otani Supp.) 
AM  = leff*w;
gc =(t*w*sigma/leff);
gzz= (AM)*sigma/t;
gcz= -(w*sigma*theta);
X=0;
%% GCC 1-2-3-4

GCC=[gc -gc X X ;
     -gc gc X X ;
      X  X  X X ;
      X  X  X  X];
%% GCZ 1-2-3-4 
GCZ=[X X gcz -gcz ; 
     X X -gcz gcz ;
     X X  X   X   ;
     X X  X   X ];
%% GZC 1-2-34
GZC = -GCZ'; 
%%
GZZ =gzz*t/lambda*[t/leff*w/w X X X; 
                   X t/leff*w/w X X;
                   X X coth(t/lambda) -csch(t/lambda);
                   X X -csch(t/lambda) coth(t/lambda);];
                           
 
GCY = zeros(4,4);
GCX = zeros(4,4);
GYC = zeros(4,4);
GXC = zeros(4,4);
%%
GZX =zeros(4,4);
GZY =zeros(4,4);
%%
GXZ = zeros(4,4);
GXY = zeros(4,4);
%% 
GYZ = zeros(4,4);
GYX = zeros(4,4);
%%
GXX = zeros(4,4);
GYY = zeros(4,4);

   GGSHE =  [GCC GCZ GCX GCY ; 
             GZC GZZ GZX GZY; 
             GXC GXZ GXX GXY; 
             GYC GYZ GYX GYY];
         
%% From original basis 1c 2c 3c 4c 1s 2s 3s 4s to SPICE Basis 1c 1s 2c 2s 3c 3s 4c 4s %%
ind=[1 5 9 13 2 6 10 14 3 7 11 15 4 8 12 16];
GSHE = GGSHE(ind,ind);

