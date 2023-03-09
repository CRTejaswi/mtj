%%% Simple LLG solver to reproduce Fig. 16
clear all; clc
global hext hd alpha Is_conv

%%% LLG parameters
%%%%%%%%%%%%%%%%%%%%%%%

%%% Constants
%%%------------
q=1.6e-19; % Coulombs
hbar=6.626e-34/2/pi; % Reduced Planck's constant (J-s)
mub=9.274e-21; % Bohr Magneton
alpha = 0.007; % Gilbert damping parameter
g = 1.76e7; % Gyromagnetic ratio [(rad)/(Oe.s)]

%%% Magnet Parameters (taken from experiment)
%%%-------------------------------------------
Ms = 780; % Saturation Magnetization [emu/cm^3]
Ku2 = 3.14e4; % Uni. anisotropy constant [erg/cm^3]
V = (170*80*2)*1e-21; % Volume [cm^3] ()
Hk = 2*Ku2/Ms ; % Switching field [Oe]
Hd = 4*pi*Ms; % Demagnetizing field [Oe]
Ns=Ms*V/mub % Number of spins in the magnet

%%% Converting magnet parameters into dimensionless quantities. Note that
%%% in this code we transform the LLG equation into a dimensionless
%%% equation by normalizing it to the time constant 1/(g*Hk).
hk = 1; % dimensionless uniaxial field
hd = Hd/Hk; % dimensionless demag field
hext=0; % Assume no external applied fields
tau_c = (1+alpha^2)/(g*Hk); % LLG time constant

% Conversion factor for Ampere spin current into dimensionless input in
% LLG. The factor below is for the term Is/(q*Ns*g*Hk), noting that
% g=2muB/hbar.
I_H_conv = hbar/2/q/(Ms*V*Hk*1e-7);
Isc = alpha*(1 + hd/2) * (Hk*Ms*V) * 1e-7 * 2*q/hbar;
% Isc = Estimated ampere spin current required for easy axis switching


Is=-1.3*Isc; % Spin current (Amps) incident on magnet
% Is=-3*Isc; %Is=-2*Isc;
Is_conv=Is*I_H_conv;
% switching_time=2*q*Ns/Is; %% Estimated switching time.

%%% Initial conditions of the simulation
mz=0.999; % Magnet slightly off easy axis due to, say, thermal noise
m=[sqrt(1-mz^2) 0 mz]; %Magnet in the x-z plane


%%%%%%%%%%% Solving the LLG equation
options = odeset('RelTol',1e-8,'AbsTol',1e-9);
NanoS = 15; %% Duration in units of nano-seconds
t_span= [0 NanoS*1e-9]/tau_c; %% Dimensionless time span
[t,x]= ode113('LLGsolver_example2', t_span, m, options);

%%%%%%%%%% Plotting
figure(1)
hold on
%plot(t*tau_c/1e-9,x(:,1),'k-'); % m_x
%plot(t*tau_c/1e-9,x(:,2),'r-'); % m_y
h=plot(t*tau_c/1e-9,x(:,3),'r-'); % m_z
axis([0 15 -1 1])
set(h,'linewidth',3.0)
set(gca,'Fontsize',30)
xlabel(' Time (ns) ')
ylabel(' m_z')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dmdt = LLGsolver_example2(t,m)
global hd alpha Is_conv

H=[0*m(1) -hd*m(2) m(3)]; % Internal fields i.e. uniaxial (along z) and demag(along x)

Is1=Is_conv*[0 0 1];

%%% Differential Equation for magnetization Dynamics
dmdt0=(-cross(m,H)-alpha*cross(m,cross(m,H))...
+cross(m,cross(Is1,m))+alpha*cross(m,Is1)) ;

dmdt=dmdt0';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
