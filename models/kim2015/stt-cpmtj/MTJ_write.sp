************************************************************************************
************************************************************************************
** Title:  MTJ_write.sp
** Author: Jongyeon Kim, VLSI Research Lab @ UMN
** Email:  kimx2889@umn.edu
************************************************************************************
** This run file simulates the dynamic motion of  MTJ.
** # Instruction for simulation
** 1. Set the MTJ dimensions and material parameters.
** 2. Select anisotropy(IMA/PMA) and initial state of free layer(P/AP).
** 3. Adjust bias voltage for Read/Write operation.
** ex. APtoP switching: positive voltage @ ini='1'
**     PtoAP switching: negative voltage @ ini='0'  
************************************************************************************
** # Description of parameters
** lx,ly,lz: width, length, and thickness of free layer
** tox: MgO thickness
** Ms0:saturation magnetizaion at 0K
** P0: polarization factor at 0K 
** alpha: damping factor
** temp: temperature
** MA: magnetic anisotropy (MA=0:In-plane,MA=1:Perpendicular)
**     also sets magnetization in pinned layer, MA=0:[0,1,0],MA=1:[0,0,1]
** ini: initial state of free layer (ini=0:Parallel,ini=1:Anti-parallel)
** Kp: Crystal perpendicular anisotropy constant
************************************************************************************

.include 'MTJ_model.inc'

*** Options ************************************************************************
.option post
.save

*** Voltage biasing to MTJ *********************************************************
.param vmtj='0.5'
V1 1 0 'vmtj'
XMTJ1 1 0 MTJ lx='45n' ly='45n' lz='0.45n' Ms0='1210' P0='0.62' alpha='0.03' Tmp0='358' RA0='5' MA='1' ini='1' Kp='1.08e7'

*** Analysis ***********************************************************************
.param pw='10ns' 
.tran 1p 'pw' START=1.0e-18  uic $sweep vmtj 0.3 0.6 0.1

.meas tsw0 when v(XMTJ1.XLLG.Mz)='0'
.meas iwr find i(XMTJ1.ve1) at 1ns
.meas thermal_stability find v(XMTJ1.XLLG.thste) at 1ns

.end
