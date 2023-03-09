% Example 3: Reproduce X/Y axis of Fig. 18
% Assume that the injector magnet is a fixed layer along a reference
% direction 'z', which also corresponds to the transport direction. The
% detector magnet is a free layer and is initially slightly away from 'z'
% by a few degrees.
clear all; clc
global hd alpha I_H_conv1 I_H_conv2 Ic
Ic=5.5e-3; %Current at the injector from current source

%%% LLG parameters
%%%%%%%%%%%%%%%%%%%%%%%

%%% Constants
%%%------------
q=1.6e-19;              % Coulombs
hbar=6.626e-34/2/pi;       % Reduced Planck's constant (J-s)
mub=9.274e-21;            % Bohr Magneton
alpha = 0.007;           % Gilbert damping parameter
g = 1.76e7;             % Gyromagnetic ratio [(rad)/(Oe.s)]

%%% Magnet Parameters (taken from experiment)
%%%-------------------------------------------
Ms = 780;                 % Saturation Magnetization [emu/cm^3]
Ku2 = 3.14e4;               % Uni. anisotropy constant [erg/cm^3]
V1 = (170*75*20)*1e-21;            % Volume [cm^3]
V2 = (170*80*4)*1e-21;            % Volume [cm^3]
Hk = 2*Ku2/Ms ;               % Switching field [Oe]
Hd = 4*pi*Ms;                % Demagnetizing field [Oe]
Ns = Ms*V2/mub                 % Number of spins in the magnet

%%% Converting magnet parameters into dimensionless quantities. Note that
%%% in this code we transform the LLG equation into a dimensionless
%%% equation by normalizing it to the time constant 1/(g*Hk).
hk = 1;            % dimensionless uniaxial field
hd = Hd/Hk;           % dimensionless demag field
tau_c = (1+alpha^2)/(g*Hk); % LLG time constant

% Conversion factor for Ampere spin current into dimensionless input in
% LLG. The factor below is the simplified version of the term
% Is/(q*Ns*g*Hk), noting that g=2muB/hbar.
I_H_conv1 = hbar/2/q/(Ms*V1*Hk*1e-7);
I_H_conv2 = hbar/2/q/(Ms*V2*Hk*1e-7);
Isc = alpha*(1+hd/2)/I_H_conv2;
% Isc = Estimated ampere spin current required for easy axis switching

%%% Initial conditions of the simulation
mz1=1;
m01=[-sqrt(1-mz1^2) 0 mz1]; %Injector magnet

mz2=0.99; % Detector magnet slightly off easy axis due to, say, thermal noise
m02=[sqrt(1-mz2^2) 0 mz2]; %Magnet in the x-z plane

%%% Charge current: solving for a fixed number of input current values
%%% since we already have an idea of where switching will occur approximately
Icc=[-8 -5.6 -5.4 -5.3 -4.9 -4.5 -3 -1 1 3 4.5 4.9 5.1 5.4 5.6 8]*1e-3; Nd=length(Icc);

%%%%%%%%%%% Solving the LLG equation
options = odeset('RelTol',1e-8,'AbsTol',1e-9);
NanoS = 50;              %% Duration in units of nano-seconds
t_span= [0 NanoS*1e-9]/tau_c; %% Dimensionless time span
[t,x]= ode113('LLGsolver', t_span, [m01 m02], options);

mdet_f=zeros(1,Nd);
mdet_r=zeros(1,Nd);

for count=1:Nd
%%%Forward sweep of current
Ic=Icc(count) % Injector current in Amps
[t,x]= ode113('LLGsolver', t_span, [m01 m02], options);
sz=size(t,1);
mdet_f(count)=x(sz,6) %forward sweep
%mz2=mdet_f(count);
%m02=[sqrt(1-mz2^2) 0 mz2];
[Rnl_f(count)]=SpinCircuit(x(sz,1:3), x(sz,4:6));
end

mz2=-0.99; % Detector magnet slightly off easy axis due to, say, thermal noise
m02=[sqrt(1-mz2^2) 0 mz2]; %Magnet in the x-z plane

for count=1:Nd
%%%Reverse sweep of current
Ic=Icc(Nd-count+1) % Injector current in Amps
[t,x]= ode113('LLGsolver', t_span, [m01 m02], options);
sz=size(t,1);
mdet_r(Nd-count+1)=x(sz,6) %reverse sweep
%mz2=mdet_r(count);
%m02=[sqrt(1-mz2^2) 0 mz2];
[Rnl_r(Nd-count+1)]=SpinCircuit(x(sz,1:3), x(sz,4:6));
end

%%%%%%%%%% Plotting
figure(1) %Non-local resistance v.s. injector charge current
hold on
plot(Icc,Rnl_f*1e3,'b','Linewidth',2); %forward sweep
plot(Icc,Rnl_r*1e3,'r--','Linewidth',2); %reverse sweep
set(gca,'linewidth',3.0,'Fontsize',30)
ylabel('R_{15}(m\Omega)') % The non local V/I
xlabel('I_c (Amp)')
box on

figure(2) %Magnetization v.s. injector charge current
hold on
plot(Icc,mdet_f,'b','Linewidth',2); %forward sweep
plot(Icc,mdet_r,'r--','Linewidth',2); %reverse sweep
set(gca,'linewidth',3.0,'Fontsize',30)
ylabel('m_z')
xlabel('I_c (Amp)')
box on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dmdt = LLGsolver(t,m)
% Vinh Diep, Srikant Srinivasan, Deepanjan Datta, Supriyo Datta Research group
global hd alpha I_H_conv1 I_H_conv2
m1=m(1:3); m2=m(4:6);
H1=[0*m1(1) -hd*m1(2) m1(3)];% Internal fields i.e. uniaxial (along z) and demag(along x)
H2=[0*m2(1) -hd*m2(2) m2(3)];
[Rn1, Is1, Is2]=SpinCircuit(m1, m2);

%%% converting back to [x y z] basis
Is1=Is1([end-1 end end-2])*I_H_conv1; Is1=Is1';
Is2=Is2([end-1 end end-2])*I_H_conv2; Is2=Is2';

%%% Differential Equation for magnetization Dynamics
dm1dt=(-cross(m1,H1)-alpha*cross(m1,cross(m1,H1))...
  +cross(m1,cross(Is1,m1))+alpha*cross(m1,Is1));
dm2dt=(-cross(m2,H2)-alpha*cross(m2,cross(m2,H2))...
  +cross(m2,cross(Is2,m2))+alpha*cross(m2,Is2));
dmdt=[dm1dt'; dm2dt'];

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Rnl, Is1, Is2]=SpinCircuit(m1,m2)
% 4-component Spin Circuit for the device in ref [Otani].
% Srikant Srinivasan, Purdue University Sept. 28, 2010
global Ic

zdir=[1 0 0]; % Unit vector along 'z', the basis convention being [z x y]
m1=m1([end 1:end-1]);
m2=m2([end 1:end-1]);

% Constants (all MKS)
q=1.6e-19; h=6.626e-34;
Z=zeros(4);
%%%%%%% Expt. Ckt. Parameters (SI units)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Magnet

PF1=0.49;PF2=0.49; %Magnet and Interface polarizations
AF1=170*75e-18; lF1=20e-9; % Area, thickness of Magnet 1
AF2=80*170e-18; lF2=4e-9; % Area, thickness of Magnet 2
lambdaF=5e-9; rhoF=17.1e-8; % Permalloy resistivity and spin-flip length
RF1=lambdaF*rhoF/AF1; RF2=lambdaF*rhoF/AF2; %Parameters of magnets
LF1=lF1/lambdaF; LF2=lF2/lambdaF; % Normalized magnet length
kf=1.36e10; Modes=kf*kf/2/pi; % Modes including both spins
RqF=h/q/q; % quantum of resistance per spin

% Channel
t=65e-9; AN=170e-9*t; % thickness, cross sectional area of Channel
lambdaN=1e-6; rhoN=0.69e-8; RN=lambdaN*rhoN/AN; % Copper
RN1=RN; RN2=RN; RN3=RN; % RN2=channel between inj. and det. and RN1,3=overhanging regions
lN2=270e-9; LN2=lN2/lambdaN; LN1=10; LN3=10;

% Gold lead
lambdaG=1e-8;rhoG=7e-8;Rau=lambdaG*rhoG/AF1;Lau=10;

%%%%% Spin Ckt Description
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Conductances

% Non-magnetic channel
[GN1,G0N1]=G_4x4(RN1,LN1,0,0,0);
[GN2,G0N2]=G_4x4(RN2,LN2,0,0,0);
[GN3,G0N3]=G_4x4(RN3,LN3,0,0,0);

% Top Gold Contacts
[GA1,G0A1]=G_4x4(Rau,Lau,0,0,0);
[GA2,G0A2]=G_4x4(Rau,Lau,0,0,0);

% Ferromagnet Bulk
[GF1,G0F1]=G_4x4(RF1,LF1,PF1,0,0);
[GF2,G0F2]=G_4x4(RF2,LF2,PF2,0,0);

% Ferromagnetic Interfaces
[GBF1,G0BF1]=G_4x4(RqF/(Modes*AF1),0,PF1,1,0);
[GBF2,G0BF2]=G_4x4(RqF/(Modes*AF2),0,PF2,1,0);
G0F1=G0F1+G0BF1;G0F2=G0F2+G0BF2;
% if max(max(GBF1))<max(max(GF1))
% % Ballistic limit
% GF1=GBF1; G0F1=G0BF1;
% else
% % diffusive limit
% G0F1=G0F1+G0BF1;
% end
% if max(max(GBF2))<max(max(GF2))
% % Ballistic limit
% GF2=GBF2; G0F2=G0BF2;
% else
% % diffusive limit

% G0F2=G0F2+G0BF2;
% end

U1=rotmat(zdir,m1);
GF1=U1*GF1*U1'; G0F1=U1*G0F1*U1';
U2=rotmat(zdir,m2);
GF2=U2*GF2*U2'; G0F2=U2*G0F2*U2';

% Non-local computation
% Conductance matrix
G=[G0A1+GA1 -GA1 Z Z Z Z Z;
  -GA1 G0A1+GA1+G0F1+GF1 -GF1 Z Z Z Z;
  Z -GF1 G0F1+GF1+GN2+G0N2+G0N1+GN1 -GN2 Z Z Z ;
  Z Z -GN2 G0N2+GN2+G0F2+GF2+GN3+G0N3 -GF2 Z -GN3;
  Z Z Z -GF2 GF2+G0F2+GA2+G0A2 -GA2 Z;
  Z Z Z Z -GA2 GA2+G0A2 Z;
  Z Z Z -GN3 Z Z GN3+G0N3];

C = [Ic;zeros(27,1)];% Terminal currents
V=G\C;V=reshape(V,4,7);% Terminal voltages
delV=V(1,6)-V(1,7); % Non-Local voltage measured

Rnl=delV/Ic; % Non-Local Resistance
IF1=GF1*(V(:,3)-V(:,2))+(G0F1)*V(:,3);% current entering FM1
IF2=GF2*(V(:,4)-V(:,5))+(G0F2)*V(:,4);% current entering FM2
Is1=-IF1(2:4); Is2=-IF2(2:4); % Electron spin current
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Gmat, G0mat] = G_4x4(R,L,P,eta,ang)
% This function generates a 4 component conductance matrix for the various
% sections including Ferro-magnet, tunnel barrier, non-magnetic channel,
% Interface.
% Srikant Srinivasan, Purdue University (2010)

% Inputs of this function are defined for each as:
%--------------------------------------------------
% R=Spin resistance (i.e rho*lambda/A),
% L=Length normalized to spin diffusion length i.e. L/lambda,
% P=polarization fraction in the range (-1,1),
% eta=ratio of (mixing conductance/series conductance),
% ang=mixing angle (Ratio of Slonczewski:Field-Like Spin torque).
a=cos(ang);b=sin(ang);

% Setting up the Series (Gmat) and Shunt (G0mat) conductance matrices
%---------------------------------------------------------------------
Gmat=[1 P 0 0; P P^2 0 0; 0 0 0 0; 0 0 0 0];

if eta==0
   % Individual Sections (eta>0 is defined for the interface)
   if L>0
      if P==0
         % Non Magnet
         Gmat=(1/R/L)*(Gmat+ L*csch(L)*diag([0 1 1 1]));
         G0mat=1/R*tanh(L/2)*diag([0 1 1 1]);
      else
         % Ferro Magnet
         Gmat=(1/R/L)*(Gmat+(1-P^2)*L*csch(L)*diag([0 1 0 0]));
         G0mat=(1-P^2)/R*tanh(L/2)*diag([0 1 0 0]);
      end
   else
      %tunnel barrier (heuristic extension of 2 component)
      Gmat=(1/R)*[1 P 0 0; P 1 0 0; 0 0 1 0; 0 0 0 1];
      G0mat=[];
   end
else
   % FM/NM Interface conductance (based on derivation in Appendix B)
   Gmat=1/eta/R*[1 P 0 0; P 1 0 0; 0 0 0 0; 0 0 0 0];
   G0mat=1/R*[0 0 0 0; 0 0 0 0; 0 0 a b; 0 0 -b a];
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function R=rotmat(a,b)
% Implementing Rodriguez rotation formula to transform the conductance
% matrix for a magnet aligned along a direction specified by the vector 'a'
% to a direction specified by the vector 'b'

a=a/norm(a); b=b/norm(b);
c=dot(a,b); s=sqrt(1-c^2);
if s==0
   % Initial and final vectors are collinear
   u=[0 0 0];
else
   u=cross(a,b)/norm(cross(a,b));
end

%%% Z,X,Y coordinate system
ux=u(2); uy=u(3); uz=u(1);
R=[1      0           0           0;
  0 uz^2+(1-uz^2)*c     uz*ux*(1-c)-uy*s uz*uy*(1-c)+ux*s;
  0 uz*ux*(1-c)+uy*s ux^2+(1-ux^2)*c ux*uy*(1-c)-uz*s;
  0 uz*uy*(1-c)-ux*s ux*uy*(1-c)+uz*s uy^2+(1-uy^2)*c];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
