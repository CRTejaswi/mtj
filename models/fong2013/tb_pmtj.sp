************************************************************************************
************************************************************************************
**                                                                                **
**                                 MTJ_calib.sp                                   **
**                                                                                **
************************************************************************************
************************************************************************************
************************************************************************************
** Author: Xuanyao Fong
** Email: xfong@ecn.purdue.edu
************************************************************************************
** This SPICE file demonstrates the operation of an MTJ device.
************************************************************************************

************************************************************************************
***                              Libraries                                       ***
************************************************************************************
.inc './mtj_libs_encoded/NRL_MTJ_SPICE_ENC_LIB.inc'

**********************************************************************
***                            Options                             ***
**********************************************************************
.option post=1
.option probe=0
.option runlvl=6
.option ingold=2
.option accurate=1
.option method=bdf
.option bdfrtol=1e-8
.option bdfatol=1e-9
.option numdgt=10
.option measfile=1
.option lis_new=1
.save

**********************************************************************
***                    Parameters/Definitions                      ***
**********************************************************************
.param pi='4*atan(1)'
.param kB='1.3806503e-23'
.param Temperature='25'
.param Ms='700'
.param alpha='0.028'
.param W='25e-9'
.param L='pi*25e-9'
.param Tm='1.4e-9'
.param Ea='56*kB*(300)*1e7'
.param Volume='W*L*Tm*1e6'
.param K='(Ea/Volume) + 2*pi*pow(Ms,2)'
.param P_L='0.8'
.param P_R='0.3'
.param Lambda_L='2'
.param Lambda_R='2'

**********************************************************************
***                     Initial Conditions                         ***
**********************************************************************
.ic V(XMTJ1.XLLG_Eq.thInt) '0.1*pi/180'
.ic V(XMTJ1.XLLG_Eq.phiInt) '0.0*pi/180'
.ic V(XMTJ2.XLLG_Eq.thInt) '179.9*pi/180'
.ic V(XMTJ2.XLLG_Eq.phiInt) '0.0*pi/180'

**********************************************************************
***                           Netlist                              ***
**********************************************************************
V_HAX hax 0 '0.0'
V_HAY hay 0 '0.0'
V_HAZ haz 0 '0.0'

I1 0 e1 '-100e-6'
XMTJ1 e1 0 hax hay haz PMAMTJ Ku2='K' W='W' P_L='P_L' P_R='P_R'
+ L='L' Tm='Tm' Ms='Ms' Lambda=0 alpha='alpha' Lambda_L='Lambda_L'
+ Lambda_R='Lambda_R'

I2 0 e2 '100e-6'
XMTJ2 e2 0 hax hay haz PMAMTJ Ku2='K' W='W' P_L='P_L' P_R='P_R'
+ L='L' Tm='Tm' Ms='Ms' Lambda=0 alpha='alpha' Lambda_L='Lambda_L'
+ Lambda_R='Lambda_R'

**********************************************************************
***                           Analysis                             ***
**********************************************************************
.tran 1p 3.0n START=1e-14 uic
.print tran v(XMTJ1.XLLG_Eq.MX) v(XMTJ1.XLLG_Eq.MY) v(XMTJ1.XLLG_Eq.MZ)
*.print tran v(XMTJ2.XLLG_Eq.MX) v(XMTJ2.XLLG_Eq.MY) v(XMTJ2.XLLG_Eq.MZ)
.end
