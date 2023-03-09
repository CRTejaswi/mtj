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


function [G11,G12,G21,G22]=G_MTJ(G0,P1,P2,theta)
%% spin ground 
gg = 1e15;
G11=[G0*(1+P1*P2*cos(theta)) 0 0 0 ;
     0   gg 0 0 ; 
     0  0 gg 0 ;
     0 0 0 gg ;];
G12=-G11;
G22=G11;
G21=-G22;
end

function [G0N,GN] = G_NM(lsf,rhoN,lN,Area)
RN  = rhoN*lN/Area;
GN = (1/RN)*[1 0 0 0 ;0 lN/lsf*csch(lN/lsf) 0 0; 0 0  lN/lsf*csch(lN/lsf) 0 ; 0 0 0 lN/lsf*csch(lN/lsf)]; 
G0N= (1/RN)*lN/lsf*[0 0 0 0;0 coth(lN/lsf)-csch(lN/lsf) 0 0  ; 0 0 coth(lN/lsf)-csch(lN/lsf) 0 ; 0 0 0 coth(lN/lsf)-csch(lN/lsf) ]; 
end

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
