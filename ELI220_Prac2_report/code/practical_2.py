import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np

def Cf(tau,T,f):
    return (tau/T)*np.sinc(np.pi*f*tau)
def q1a():
    f = np.arange(-20,20,1)
    plt.title("Frequency spectrum C(f) for " + r'$\tau$' + " = " + r'$\frac{T}{2}$' + ", T=1s")
    C1 = Cf(0.5,1,f)
    unit = "Hz"
    return C1,f,unit

def q1b():
    f = np.arange(-40,40,1)
    plt.title("Frequency spectrum C(f) for " + r'$\tau$' + " = " + r'$\frac{T}{20}$' + ", T = 1s")
    C2 = Cf(1/20,1,f)
    unit = "Hz"
    return C2,f,unit

def q1d():
    f = np.arange(-30000,30000, 2/0.0037)
    plt.title("Frequency spectrum C(f) for " + r'$\tau$' + " = 75" + r'$\mu$' + "s, T = 3.7 ms")
    C4 = Cf(0.000075,0.0036,f)
    unit = "kHZ"

    def format_func(value, tick_number):
        return f'{int(value / 1000)}'

    plt.gca().xaxis.set_major_formatter(ticker.FuncFormatter(format_func))
    return C4,f,unit

def Q1(fn,fig_name):
    C,f,unit = fn()
    pos_C = [] 
    pos_f = [] 
    neg_C = [] 
    neg_f = [] 
    for i in range(len(C)):
        if(C[i] >= 0):
            pos_C.append(C[i])
            pos_f.append(f[i])
        else:
            neg_C.append(C[i])
            neg_f.append(f[i])
    if len(pos_f) > 0:
        plt.stem(pos_f, pos_C,linefmt="black",markerfmt="^")
    if len(neg_f) > 0:
        plt.stem(neg_f, neg_C, linefmt="black",markerfmt="v")
    plt.xlabel("Frequency, f ("+unit+")")
    plt.ylabel("C(f)")
    plt.savefig(fig_name)
    plt.clf()

def bode_plot(dB,deg,t,text,fig_name):
    fig, axs = plt.subplots(2)
    fig.suptitle('Bode plot for ' + text)
    
    axs[0].set(
        # xlabel="frequency, f (Hz)",
        ylabel="Magnitude, |H(f)| (dB)"
    )
    axs[0].set_axisbelow(True)
    axs[0].xaxis.grid(which="both", color=(0.8,0.8,0.8), linestyle='dashed')
    axs[0].yaxis.grid(which="major", color=(0.8,0.8,0.8), linestyle='solid')
    axs[0].semilogx(t,dB,color="black")

    axs[1].set(
        xlabel="frequency, f (Hz)",
        ylabel="Phase, " + r'$\angle$' + "H(f) (Hz)",
    )
    axs[1].set_axisbelow(True)
    axs[1].xaxis.grid(which="both", color=(0.8,0.8,0.8), linestyle='dashed')
    axs[1].yaxis.grid(which="major", color=(0.8,0.8,0.8), linestyle='solid')
    axs[1].semilogx(t,deg,color="black")
    fig.savefig(fig_name)
    plt.clf()


def rc_time(R,C):
    t0 = np.arange(0,1.5,1/100)
    t = t0/1000
    a1 = (1/(R*C))
    a2 = (-t/(R*C))
    h = a1*np.e**a2
    return h,0,t0 

def rc_freq(R,C):
    f = np.logspace(1,6,50)
    s = 2*np.pi*f*1j
    H = 1/(R*C*s+1) 
    A = abs(10*np.log10(H)) 
    T = np.angle(H,deg=True)
    return A,T,f

def Q2rc(R,fn,fig_name):
    y,o,t = fn(R,0.000000033)
    propery_text = "RC circuit (R = " + str(round(R/1000)) + 'k' + r'$\Omega$' + ", C = 33nF)"
    if fn == rc_time:
        plt.plot([0,0],[t[0],y[0]],color="black")
        plt.plot(t, y, color="black")
        plt.title("Impulse response of RC circuit " + propery_text)
        plt.xlabel("time, t (ms)")
        plt.ylabel("h(t)")
        plt.savefig(fig_name)
        plt.clf()
    else:
        bode_plot(y,o,t,propery_text,fig_name)

def rl_time(R,L):
    t0 = np.arange(0,2,1/100)
    t = t0/1000
    h = (R/L)*(np.e**(-(R/L)*t))
    return h,0,t0

def rl_freq(R,L):
    f = np.logspace(1, 8, 50)
    s = 2*np.pi*f*1j

    H = s/((R/L)+s) 
    A = abs(10*np.log10(H))
    T = np.angle(H)
    return A,T,f 

def Q2rl(R,fn,fig_name):
    y,theta,t = fn(R,0.01)
    propery_text = "RL circuit (R = " + str(R) + r'$\Omega$' + ", L = 10mH)"
    if fn == rl_time:
        plt.plot([0,0],[t[0],y[0]],color="black")
        plt.plot(t, y, color="black")
        plt.title("Impulse response of " + propery_text)
        plt.xlabel("time, t (ms)")
        plt.ylabel("h(t)")
        plt.savefig(fig_name)
        plt.clf()
    else:
        bode_plot(y,theta,t,propery_text,fig_name)

    
def rlc_time(R,L,C):
    t0 = np.arange(0, 4,1/100)
    t = t0/1000
    b = 55004.21
    g = (1/(L*C*b))
    h = g*(np.e**((-R/L)*t))*np.sin(b*t)
    return h,0,t0

def rlc_freq(R,L,C): 
    f = np.logspace(1,6,50)
    s = 2*np.pi*f*1j
    H_s = 1/((L*C*(s**2)) + s*R*C + 1)
    H_abs = np.abs(H_s)
    # H_abs = np.sqrt((H_s)**2)
    # H_abs = 1/(np.sqrt( ((1-L*C*(2*np.pi*f)**2)**2) + ((R*C*2*np.pi*f)**2) ))
    A = (10*np.log10(H_abs))
    T = np.angle(H_s)
    return A,T,f

def Q2rlc(R,fn,fig_name):
    y,theta,t = fn(R,0.01, 0.000000033)
    propery_text = "RLC circuit (R = " + str(R) + r'$\Omega$' + ", C = 33nF, L = 10mH)"
    if fn == rlc_time:
        plt.plot([0,0],[t[0],y[0]],color="black")
        plt.plot(t, y, color="black")
        plt.title("Impulse response of " + propery_text)
        plt.xlabel("time, t (ms)")
        plt.ylabel("h(t)")
        plt.savefig(fig_name)
        plt.clf()
    else:
        bode_plot(y,theta,t,propery_text,fig_name)


Q1(q1a,"fig/Q1_a_C(f).pdf")
Q1(q1b,"fig/Q1_b_C(f).pdf")
Q1(q1d,"fig/Q1_d_C(f).pdf")
Q2rc(10000,rc_time,"fig/Q2_a_RC_time.pdf")
Q2rc(10000,rc_freq,"fig/Q2_a_RC_freq.pdf")
Q2rl(56,rl_time,"fig/Q2_b_RL_time.pdf")
Q2rl(56,rl_freq,"fig/Q2_b_RL_freq.pdf")
Q2rlc(0,rlc_time,"fig/Q2_c_RCL_0_time.pdf")
Q2rlc(0,rlc_freq,"fig/Q2_c_RCL_0_freq.pdf")
Q2rlc(22,rlc_time,"fig/Q2_d_RCL_22_time.pdf") 
Q2rlc(22,rlc_freq,"fig/Q2_d_RCL_22_freq.pdf")
