import matplotlib.pyplot as plt
import numpy as np

def Chebyshev(fig_name, dB):
    f = np.arange(0,100000,1)
    b0 = 0.4913 
    b1 = 1.2384
    b2 = 0.9883
    a0 = b0

    fig, ax = plt.subplots()
    H_L = a0/(np.sqrt( (b0 - b2*(f/4000)**2)**2 + (1.2384*(f/4000) - (f/4000)**3 )**2 ))

    ax.set(title="Magnitude Reponse Chebyshev filter,\n with cut-off frequency of 4kHz and pass-band ripple of 1 dB")

    #ax.axhline(y=-0, color="grey", linestyle="--",)
    ax.axhline(y=-1.1, color="grey", linestyle="--",)
    ax.annotate('-1 dB', xy=(4200, -3), xytext=(4200, 0))
 
    ax.axhline(y=-2.7, color="grey", linestyle="--",)
    ax.annotate('-3 dB', xy=(3200, -4.5), xytext=(1200, -7.3))

    ax.axvline(x=4100, color="grey", linestyle="--")
    ax.annotate('4 kHz', xy=(1000, -105), xytext=(1000, -105))


    ax.axhline(y=-60, color="grey", linestyle="--")
    ax.annotate('-60 dB', xy=(40200, -3), xytext=(40200, -59.18))
    ax.axvline(x=40000, color="grey", linestyle="--")
    ax.annotate('40 kHz', xy=(50000, -105), xytext=(50000, -105))
        
    Amplitude = 10*np.log(H_L)
    if dB:
        ax.semilogx(f,Amplitude)
    else:
        ax.plot(f,Amplitude)
    plt.savefig(fig_name)

Chebyshev("fig/Chebyshev_theoretical.pdf", True)
