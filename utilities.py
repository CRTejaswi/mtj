#    Copyright(c) 2022-
#    Author: Chaitanya Tejaswi (github.com/CRTejaswi)    License: GPL v3.0+

import numpy as np
import matplotlib.pyplot as plt

def plot_spice(model='fong2013',datafile=None, datatype='spice', plot=True, plotType=None, plotName=None):
    file=f'models/{model}/{datafile}'
    match datatype:
        case 'spice':
            data = [line.strip() for line in open(file)][8:3008]
            data = [x.split(' ',maxsplit=3) for x in data]
            t  = [x[0] for x in data]
            mx = [x[1] for x in data]
            my = [x[2] for x in data]
            mz = [x[3] for x in data]
            # Plot
            plt.plot(t,mx, color='#FF0000', linestyle='--', label='$m_{x}$')
            plt.plot(t,my, color='#00FF00', linestyle='--', label='$m_{y}$')
            plt.plot(t,mz, color='#0000FF', linestyle='--', label='$m_{z}$') 
            plt.title(plotName); plt.xlabel('Time (ns)'); plt.ylabel('Magnetisation (A/m)');
            plt.grid(); plt.legend(); plt.xticks([]); plt.yticks([]); plt.show(); 
        case 'csv':
            data = [line.strip() for line in open(file)][1:]
            data = [x.split(',',maxsplit=7) for x in data]
            t  = [x[0] for x in data]
            n1 = [x[1] for x in data]
            n2 = [x[3] for x in data]
            I  = [x[5] for x in data]
            R  = [x[7] for x in data]
            # Plot
            plt.figure(figsize=(16,9));
            plt.plot(t,n1, color='#FF0000', linestyle='--', label='n1')
            plt.plot(t,n2, color='#FFD000', linestyle='--', label='n2')
            plt.plot(t,I, color='#00FF00', linestyle='--', label='I')
            plt.plot(t,R, color='#0000FF', linestyle='--', label='R')
            plt.title(plotName); plt.xlabel('Time (ns)'); plt.ylabel('');
            xcoords=[x for x in np.arange(2e-10, 2e-07, 1e-9)]; #ycoords=np.arange(2e-10, 2e-07, 1e-9);
            plt.legend(); plt.xticks(xcoords, xcoords); plt.yticks([]); plt.show(); #plt.grid();
        case _:
            raise NotImplementedError(f"'{datatype}' files aren't supported!")

plot_spice(model='fong2013', datafile='imtj-ap2p.printtr0', plotName='iMTJ (AP->P)')
plot_spice(model='fong2013', datafile='imtj-p2ap.printtr0', plotName='iMTJ (P->AP)')
plot_spice(model='fong2013', datafile='pmtj-ap2p.printtr0', plotName='pMTJ (AP->P)')
plot_spice(model='fong2013', datafile='pmtj-p2ap.printtr0', plotName='pMTJ (P->AP)')
plot_spice(model='beihang/stt-pmtj', datafile='stt-pmtj1.csv', datatype='csv', plotName='Beihang STT-pMTJ Model')
