import numpy as np
import matplotlib.pyplot as plt

colors1 = plt.cm.Set2(np.linspace(0, 1, 8))
plt.rcParams.update({
    "figure.figsize": (6, 4),
    "font.size": 15,
    "font.family": "serif",
    'text.usetex': True,
    "axes.labelsize": 15,
    "axes.titlesize": 15,
    "legend.fontsize": 10,
    "lines.linewidth": 1.5,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
})

def sigma(filename):
    try:
        with open(filename, "r") as f:
            line = f.readline()

        results = line.split()
        sigma = float(results[0])
        return sigma

    except FileNotFoundError:
        print(f"FILE NOT FOUND: {filename}")
        return None

def simetrija(file_sm, file_c, file_c_, c):
    sigma_sm = sigma(file_sm)
    sigma_c0 = sigma(file_c)
    sigma_c0_ = sigma(file_c_)

    if sigma_sm is None or sigma_c0 is None or sigma_c0_ is None:
        return None

    sigma_c = sigma_sm + c**2 * sigma_c0
    sigma_c_ = sigma_sm + c**2 * sigma_c0_

    sum_ = sigma_c + sigma_c_
    diff = sigma_c - sigma_c_

    if sum_ == 0:
        return None

    return diff / sum_

C_all = np.concatenate(([0.01], np.arange(0.5, 30.5, 0.5)))

plt.gca().set_prop_cycle(color=colors1)
for Wils in ["eu", "lequ1", "lequ3"]:

    sym_coefficients = []

    if "1" in Wils:
        label = rf"$C_{{{Wils[:-1]}}}^{{(1)}}$"
    elif "3" in Wils:
        label = rf"$C_{{{Wils[:-1]}}}^{{(3)}}$"
    else:
        label = r"$C_{eu}$, $C_{lu}$, $C_{qe}$, $C_{lq}^{(1)}$, $C_{lq}^{(3)}$"

    for c in C_all:
        file_sm = f"/scratch/barbariczara/2026/mg5/SM/pp_c~ee_sm/SubProcesses/results.dat"
        file_c = f"/scratch/barbariczara/2026/mg5/C_{Wils}/pp_cee/C={c}/SubProcesses/results.dat" 
        file_c_ = f"/scratch/barbariczara/2026/mg5/C_{Wils}/pp_c~ee/C={c}/SubProcesses/results.dat"
        print(file_c)

        sym_coefficients.append(simetrija(file_sm, file_c, file_c_, c))

    sym_coefficients = np.array(sym_coefficients)

    plt.plot(C_all, sym_coefficients, label=label)

plt.xlabel("$C$ [TeV$^{-2}$]") #r"$C_{lq}^{(1)}$") #                                                               
ylabel = r"$\frac{\sigma_c - \sigma_{\bar{c}}}{\sigma_c + \sigma_{\bar{c}}}$"
plt.ylabel(ylabel)
plt.ylim(top=1)
plt.legend()
plt.savefig(f"/home/barbariczara/2026/graphs/graf_C_all.png")                              
plt.show()
