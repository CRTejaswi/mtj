**** Wrapper file for including the NRL MTJ SPICE Libraries
** The .hdl needs to point to the file that defines the MTJ resistance model
** (which is defined as MTJ_res)
.hdl "./MTJ_res.va"
** The .lib needs to point to the MTJ_enc.lib file containing the encrypted
** file for defining NRL MTJ SPICE Library components
.hdl "./LLGThermRandNum.va"
.lib "./MTJ.lib" NRL_MTJS
