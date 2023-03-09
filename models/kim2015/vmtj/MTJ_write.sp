************************************************************************************
************************************************************************************
** Title: VCMA-assisted STT switching
** Author: Jeehwan Song, VLSI Research Lab @ UMN (songx944@umn.edu)
** This is modified based on previous STT model by Jongyeon Kim, VLSI Research Lab @ UMN (kimx2889@umn.edu)
************************************************************************************
** This run file simulates the dynamic motion of  MTJ.
** # Instruction for simulation
** 1. Set the MTJ dimensions and material parameters.
** 2. Select initial state of free layer(P/AP).
** 3. Select VCMA coefficient and external magnetic field 
**    ex. vcma_coeff = 33e-15, 105e-15, 290e-15 [J*V^-1*m^-1]
**        Hext_x = 200 [Oe]
** 4. Adjust voltage pulse parameters(voltage-amplitude, pulsewidth) for four switching directions.
**    ex. voltage pulse (1): P-to-P, AP-to-P switching @ ini='0/1'
**     	  voltage pulse (2): P-to-AP, AP-to-AP switching @ ini='0/1'
************************************************************************************
** # Description of parameters
** lx,ly,lz: width, length, and thickness of free layer
** tox: MgO thickness
** Ms0: saturation magnetizaion at 0K
** P0: polarization factor at 0K 
** alpha: damping factor
** Tmp0: temperature [K]
** RA0: resistance-are Product at parallel state
** MA: magnetic anisotropy (MA=0:In-plane,MA=1:Perpendicular)
**     also sets magnetization in pinned layer, MA=0:[0,1,0],MA=1:[0,0,1]
** ini: initial state of free layer (ini=0:Parallel,ini=1:Anti-parallel)
** tc: critical thickness (single interface: tc=1.5nm, Double interface: tc=3nm)
** vcma_coeff: coefficient of voltage-controlled magnetic anisotropy (VCMA)
** VE: voltage for VCMA-effect
** VSTT: voltage for STT-effect (VSTTP:positive VSTT, VSTTN:negative VSTT)
** PW_VE, PW_VSTT: pulsewidths of VE, VSTT
** Hext_x, H_ext_y, Hext_z: external magnetic field toward x-asix, y-axis, z-axis
************************************************************************************
.include 'MTJ_model.inc'

*** Options ************************************************************************
.option post
	+ runlvl=3
	+ ITL4=100
.save

*** Device Parameters of MTJ *******************************************************
.param lx='70n' ly='70n' lz='1.49n' Ms0='950' P0='0.54' alpha='0.025' Tmp0='358' RA0='130' MA='1' tc='1.5n' tox='1.4n' ini = '0' vcma_coeff = '33e-15'
.param pi='355/113' 
*** MTJ ****************************************************************************
XMTJ 1 0 2 Mx My Mz MTJ lx='lx' ly='ly' lz='lz' Ms0='Ms0' P0='P0' alpha='alpha' Tmp0='Tmp0' RA0='RA0' MA='MA' ini='ini' tc='tc' tox='tox' 

*** Experimental Parameters of MTJ ************************************************* 
.param Tmp0='358' Hext_x = '200' Hext_y = '0' Hext_z = '0'
.param VE = '2.45' VSTTP = '1.8' VSTTN = '-1.8' PW_VE = '0.48n' PW_VSTT = '2.00n'
.param t0 = '0.5n'			$time before VE pulse
.param t1 = 'VE*0.02n'  		$rising time from 0V to VE
.param t2 = '(VE-VSTTP)/(VE/t1)'	$falling time from VE to VSTTP
.param t3 = '(VSTTP-0)/(VE/t1)'		$time after VSTT pulse 

*** RC-delay for energy barrier time constant **************************************
.param R_Eb = '0k' C_Eb = '0f' 

R_Eb 1 2 'R_Eb'	$resistance of RC-delay model
C_Eb 2 0 'C_Eb' $capacitance of RC-delay model

*** Analysis ***********************************************************************
.param pw='10ns'
.tran 1p 'pw' START=1.0e-18  uic  $sweep PW_VE 0.45n 0.50n 0.01n

*** Voltage pulse(1): VE + POSTIVE VSTT (VSTTP) ************************************
Vpwl 1 0 pwl (0 0 't0' 0 't0+t1' 'VE' 't0+t1+PW_VE' 'VE' 't0+t1+PW_VE+t2' 'VSTTP' 't0+t1+PW_VE+t2+PW_VSTT' 'VSTTP' 't0+t1+PW_VE+t2+PW_VSTT+t3' 0 'pw' 0)

*** switching time measurement
.meas t_start		when v(1)='VE/2' rise=1
.meas t_finish		when v(Mz)=0.5	rise=1 TD='t0+t1+PW_VE+t2'  
.meas Tsw		param='t_finish-t_start'
.meas final_State	find v(Mz) at 'pw'

*** switching energy measurment
.meas i_avg   		AVG i(XMTJ.ve1) from='t0'	to='t_finish'
.meas v_avg   		AVG V(1) 	from='t0'	to='t_finish'
.meas Ewr_pulse1 	param='i_avg*v_avg*(t_finish-t0)'

*** Voltage pulse(2): VE + NEGATIVE VSTT (VSTTP) ***********************************
.alter
.param t2='(VE-VSTTN)/(VE/t1)'
.param t3='(0-VSTTN)/(VE/t1)'

Vpwl 1 0 pwl (0 0 't0' 0 't0+t1' 'VE' 't0+t1+PW_VE' 'VE' 't0+t1+PW_VE+t2' 'VSTTN' 't0+t1+PW_VE+t2+PW_VSTT' 'VSTTN' 't0+t1+PW_VE+t2+PW_VSTT+t3' 0 'pw' 0)

*** switching time measurement
.meas t_start		when v(1)='VE/2' rise=1
.meas t_finish		when v(Mz)=-0.5	fall=1 TD='t0+t1+PW_VE+t2'  
.meas Tsw		param='t_finish-t_start'
.meas final_State	find v(Mz) at 'pw'

*** switching energy measurment
.meas t_mid		when v(1)='0' fall=1
.meas i_avg_ve 		AVG i(XMTJ.ve1) from='t0'	to='t_mid'
.meas i_avg_vstt 	AVG i(XMTJ.ve1) from='t_mid'	to='t_finish'
.meas v_avg_ve 		AVG V(1) 	from='t0'	to='t_mid'
.meas v_avg_vstt	AVG V(1) 	from='t_mid'	to='t_finish'
.meas Ewr_pulse2 	param='(i_avg_ve*v_avg_ve*(t_mid-t0))+(i_avg_vstt*v_avg_vstt*(t_finish-t_mid))'

.end
