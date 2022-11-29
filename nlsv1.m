clc; clear all; close all;

%Constants (all MKS, except energy which is in eV)
q=1.6e-19;Z=zeros(2,2);

% Parameters
% note: R => rho*lambda_sf/A; L => L/lambda_sf
ii=0;
for X=-5:0.1:5
   ii=ii+1; RT(ii)=X; RT1=10^X; RT2=10^X;% Tunnel Resistance
   PT1=0.2; PT2=0.2;% Polarization of Tunnel Contacts
   RF=1e-2; LF1=100; LF2=100; PF1=0.05; PF2=0.05;% Ferromagnetic contacts
   RN=1; LN1=100; LN2=1e-3; LN3=100;% Nonmagnetic Channel

  % FM layers
  G_FM1 = ((1/RF/LF1)*[1 PF1;PF1 PF1*PF1])+(((1-PF1*PF1)/RF)*[0 0; 0 ...
            csch(LF1)]);
  G_FM2 = ((1/RF/LF2)*[1 PF2;PF2 PF2*PF2])+(((1-PF2*PF2)/RF)*[0 0; 0 ...
            csch(LF2)]);
  G0_FM1 = ((1-PF1*PF1)/RF)*[0 0;0 coth(LF1)-csch(LF1)];
  G0_FM2 = ((1-PF2*PF2)/RF)*[0 0;0 coth(LF2)-csch(LF2)];

  % NM channel
  G_NM1 = (1/RN/LN1)*[1 0;0 LN1*csch(LN1)];
  G_NM2 = (1/RN/LN2)*[1 0;0 LN2*csch(LN2)];
  G_NM3 = (1/RN/LN3)*[1 0;0 LN3*csch(LN3)];
  G0_NM1 = (1/RN)*[0 0;0 coth(LN1)-csch(LN1)];
  G0_NM2 = (1/RN)*[0 0;0 coth(LN2)-csch(LN2)];
  G0_NM3 = (1/RN)*[0 0;0 coth(LN3)-csch(LN3)];

  % Tunnel Barrier
  G_TB1=(1/RT1)*[1 PT1;PT1 1];
  G_TB2=(1/RT2)*[1 PT2;PT2 1];

  % Conductance matrix from KCL
  G = [G0_FM1+G_FM1 -G_FM1 Z Z Z Z Z;
    -G_FM1 G0_FM1+G_FM1+G_TB1 Z Z -G_TB1 Z Z;
    Z Z G0_FM2+G_FM2 -G_FM2 Z Z Z;
    Z Z -G_FM2 G0_FM2+G_FM2+G_TB2 Z -G_TB2 Z;
    Z -G_TB1 Z Z G_NM1+G0_NM1+G0_NM2+G_NM2+G_TB1 -G_NM2 Z;
    Z Z Z -G_TB2 -G_NM2 G_NM3+G0_NM2+G0_NM3+G_NM2+G_TB2 -G_NM3;
    Z Z Z Z Z -G_NM3 G_NM3+G0_NM3];

  % SPICE Solution
  C = [1; PF1; zeros(12,1)];% Terminal currents
  V=G\C; V=reshape(V,2,7);% Terminal voltages
  Vout(ii)=V(1,3)-V(1,7);% Output voltage

  % Analytical Solution
  RF1=RF; RF2=RF;
  Numer = 2*RN*exp(-LN2)*(PT1*RT1/RN/(1-PT1^2) + PF1*RF1/RN/(1-PF1^2))...
    *(PT2*RT2/RN/(1-PT2^2) + PF2*RF2/RN/(1-PF2^2));
  denom = (1+ 2*RT1/RN/(1-PT1^2) + 2*RF1/RN/(1-PF1^2))...
    *(1+ 2*RT2/RN/(1-PT2^2) + 2*RF2/RN/(1-PF2^2)) - exp(-LN2);
  Rnon_local(ii)=Numer/denom;
end

figure;
subplot(1,2,1); plot(RT, Vout/C(1)); ylabel(['V_{out}']); xlabel(['log(R_{TB})']); title(['V_{out}/I_{in} vs R_{TB}  (spice solution)']); grid on;
subplot(1,2,2); plot(RT, Rnon_local); ylabel(['R_{NL}']); xlabel(['log(R_{TB})']); title(['R_{NL} vs R_{TB} (analytical solution)']); grid on;
sgtitle(['R_{NL} Characteristics for NLSV (I_{in} = 1A)']);
