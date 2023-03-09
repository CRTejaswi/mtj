********************************************************************************************************
********************************************************************************************************
** Title:  MTJ_model.inc
** Author: Jongyeon Kim, VLSI Research Lab @ UMN
** Email:  kimx2889@umn.edu
********************************************************************************************************
** This library includes LLG_solver.inc, Resistance.inc, Thermal_fluctuation.inc, and Heat_diffusion.inc.
** At the given voltage across the MTJ, dynamic current and resistance are generated.
********************************************************************************************************

.include 'LLG_solver.inc'
.include 'Resistor.inc'
.include 'HeatDF.inc'

.subckt MTJ e1 e2 lx='65n' ly='130n' lz='1.8n' Ms0='1075' P0='0.715' alpha='0.01' Tmp0='300' RA0='5.4' MA='0.0' ini='1'

XRA   ex e2 Mx My Mz Tmp thi RA lx='lx' ly='ly' P0='P0' RA0='RA0' MA='MA' 
XLLG  Mx My Mz Is Ias Tmp thi LLG lx='lx' ly='ly' lz='lz' Ms0='Ms0' P0='P0' alpha='alpha' MA='MA' ini='ini'
XHD   Ihd Tmp HD lx='lx' ly='ly' lz='lz' Tmp0='Tmp0'

*** Internal top electrode of MTJ ***************
Ve1 e1 ex 0


*** Asymetry of write current ************************
*** positive bias:Ias=Iatp, negative bias:Ias=Ipta ***
*** Iatp will generate more spin current. ************ 
.param Iatp='1'
.param Ipta='1/1.5'
E_Ias Ias 0 vol='(1+(v(e1)-v(e2))/abs(v(e1)-v(e2)))*(Iatp-Ipta)/2+Ipta'


*** Charge current passing through MTJ stack *************
*** Imtj is fed to LLG and Head_Diffusion models *********
G_Imtj1 0 Is cur='-I(Ve1)'
G_Imtj2 0 Ihd cur='-I(Ve1)'



.ends
