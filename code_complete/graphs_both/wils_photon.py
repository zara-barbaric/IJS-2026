import numpy as np
import matplotlib.pyplot as plt
import uproot
import awkward as ak
import os
import re
import glob

###ZA SPREMENITI:
#Pot do mape s celotnim projektom
main = "/scratch/barbariczara/2026"
#Pot do končne slike 
fig_path = f"{main}/graphs_complete/wils_photon_both.png"
# Pot do datoteke z rezultati
result_file_path = f"{main}/results_complete/wils_photon.dat"
#Za katere Wilsonove koeficiente narišemo grafe. Možnosti: "eu", "lu", "qe", "lq1", "lq3", "lequ1", "lequ3", "uB", "uW"
Wilson_coefficients = ["uW", "uB"]
#Kateri delec nastane na koncu. Možnosti "electron" (proces p p > c e+ e-), "photon" (proces p p > c a)
particle = "photon"
#Za katero neodvsno spremenljivko narišemo grafe. Možnosti: "pt", "wils"
variable = "wils"
#Vrednost Wilsonovega koeficienta, v kolikor gre za proces p p > c a in nas zanima odvisnost od giabalne količine. Možnosti: 1, 0.1, 0.01
pt_photon_C_value = 1

if particle == "photon" and variable == "pt":
    option = f"/C_{pt_photon_C_value}"
else:
    option = ""

#Vrednosti koeficientov, ki jih uporabimo pri odvisnosti od gibalne količine (zgornje meje)
pt_C_values = {
    "eu": 0.0539771,
    "lu": 0.0540114,
    "qe": 0.0423928,
    "lq1": 0.0503483,
    "lq3": 0.0265658,
    "lequ1": 0.0562678,
    "lequ3": 0.0270081,
    "uB": pt_photon_C_value,
    "uW": pt_photon_C_value
}

colors1 = plt.cm.Set2(np.linspace(0, 1, 16))[4:]
plt.rcParams.update({
    "figure.figsize": (3,2),
    "font.size": 10,
    "font.family": "serif",
    "text.usetex": True,
    "axes.labelsize": 10,
    "axes.titlesize": 10,
    "legend.fontsize": 6,
    "lines.linewidth": 1,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
})

plt.figure()
plt.ylim((-0.05,1))

if variable == "pt":
    prefix = "pt"
    xlabel = "$p_T$ [GeV]"
elif variable == "wils":
    prefix = "C"
    xlabel = "$C$ [TeV$^{-2}$]"

if particle == "electron":
    proc = "ee"
elif particle == "photon":
    proc = "a"
 
def get_xsec_mg5(filepath):
    """
    Vrne sipalni presek, za proces generiran s programom Madgraph.

    Parametri
    ---------
    filepath: pot do datoteke results.dat, v kateri je shranjen sipalni presek
    """

    try:
        with open(filepath, "r") as f:
            line = f.readline()
        results = line.split()
        xsec = float(results[0])
        return xsec

    except FileNotFoundError:
        print(f"\nFILE NOT FOUND: {filepath}")
        return None

def get_xsec_detected(filepath, xsec_mg5):
    """
    Vrne sipalni presek, ki ga zaznamo z detektorjem, simuliranim s programom Delphes. Izracunan je po formuli xsec_detected = xsec_mg5 * e, kjer je e = N_cut / N_total efektivnost detektorja

    Parametri
    ---------
    filepath: po do .root datoteke, ki jo generira Delphes \\
    xsec_mg5: sipalni presek za dani presek
    """

    try: 
        with uproot.open(filepath) as f:
            tree = f["Delphes"]
            arrays = tree.arrays(["Event.Weight", "Jet.BTag"], library="ak")

        weights = ak.flatten(arrays["Event.Weight"])
        jet_btag = arrays["Jet.BTag"]

        #preveri, ce je bit na mestu 1 vklopljen - curek je bil zaznan s CTagging
        is_ctag = ((jet_btag & 2) == 2)
        #izbere dogodke, kjer je bil vsaj en curek zaznan s CTagging
        mask_has_ctag = ak.any(is_ctag, axis=1)

        N_selected = ak.sum(weights[mask_has_ctag])
        N_gen = ak.sum(weights)
        efficiency = N_selected / N_gen
        xsec_detected = xsec_mg5 * efficiency

        return xsec_detected, efficiency

    except FileNotFoundError:
        print(f"\nFILE NOT FOUND: {filepath}")
        return None, None
    except:
        print(f"\nERROR WITH ROOT FILE: {filepath}")
        return None, None


def asymetry(wils, var_val, var_str, wils_value):
    """ 
    Izračuna asimetrijo med kvarkoma c in c~.
    
    Parametri
    ----------
    wils: kateri Wilsonov koeficient je vklopljena. Možnosti: "eu", "lu", "qe", "lq1", "lq3", "lequ1", "lequ3", "uB", "uW" \\
    var_val : vrednost neodvisne spremenljivke (Wilsonovega koeficienta ali gibalne količine), na katero je bila ta nastavljena med generacijo dogodkov \\
    var_str : vrednost neodvisne spremenljivke v string formatu (potrebno za pot do results.dat in .root datotek, da se ne izgubijo  končne decimalke enake 0)
    """

    # Poti do output mape, ki jo ustvari Madgraph
    # Proces v standardnem modelu
    if variable == "pt":
        path_sm = f"{main}/mg5_complete/SM/{variable}_{particle}/{prefix}_{var_str}"
    elif variable == "wils":
        path_sm = f"{main}/mg5_complete/SM/{variable}_{particle}"
    # Proces s kvarkom c v SMEFT
    path_c  = f"{main}/mg5_complete/C_{wils}/pp_c{proc}/{variable}{option}/{prefix}_{var_str}"
    # Proces s kvarkom c v SMEFT
    path_anti_c = f"{main}/mg5_complete/C_{wils}/pp_c~{proc}/{variable}{option}/{prefix}_{var_str}"

    xsec_sm = get_xsec_mg5(f"{path_sm}/SubProcesses/results.dat")
    xsec_c = get_xsec_mg5(f"{path_c}/SubProcesses/results.dat")
    xsec_anti_c = get_xsec_mg5(f"{path_anti_c}/SubProcesses/results.dat")

    if xsec_sm is None or xsec_c is None or xsec_anti_c is None:
        return None, None

    effxsec_sm, eff_sm = get_xsec_detected(f"{path_sm}/Events/run_01/tag_1_delphes_events.root", xsec_sm)
    effxsec_c, eff_c = get_xsec_detected(f"{path_c}/Events/run_01/tag_1_delphes_events.root", xsec_c)
    effxsec_anti_c, eff_anti_c = get_xsec_detected(f"{path_anti_c}/Events/run_01/tag_1_delphes_events.root", xsec_anti_c)

    if effxsec_sm is None or effxsec_c is None or effxsec_anti_c is None:
        return None, None

    #Asimetrija na partonskem nivoju
    combined_xsec_c = xsec_sm + wils_value**2 * xsec_c
    combined_xsec_anti_c = xsec_sm + wils_value**2 * xsec_anti_c

    xsec_sum = combined_xsec_c + combined_xsec_anti_c
    xsec_diff = combined_xsec_c - combined_xsec_anti_c

    if xsec_sum == 0:
        print(f"\nZERO SUM OF CROSS SECTIONS for Wilson coefficient C_{wils} at {variable} = {var_val}")
        return None
    asymetry_value = xsec_diff / xsec_sum

    #Asimetrija po hadronizaciji in detektorju
    combined_effxsec_c = effxsec_sm + wils_value**2 * effxsec_c
    combined_effxsec_anti_c = effxsec_sm + wils_value**2 * effxsec_anti_c

    effxsec_sum = combined_effxsec_c + combined_effxsec_anti_c
    effxsec_diff = combined_effxsec_c - combined_effxsec_anti_c

    if effxsec_sum == 0:
        print(f"\nZERO SUM OF CROSS SECTIONS for Wilson coefficient C_{wils} at {variable} = {var_val}")
        return None
    eff_asymetry_value = effxsec_diff / effxsec_sum

    if result_file_path is not None:
        with open(result_file_path, "a") as f:
            f.write(
                f"{var_val:<8}  {'SM':<5}{xsec_sm:<15.6g}{eff_sm:<15.6g}{effxsec_sm:<15.6g}\n"
                f"{var_val:<8}  {'c':<5}{xsec_c:<15.6g}{eff_c:<15.6g}{effxsec_c:<15.6g}\n"
                f"{var_val:<8}  {'c~':<5}{xsec_anti_c:<15.6g}{eff_anti_c:<15.6g}{effxsec_anti_c:<15.6g}{asymetry_value:<15.6g}\n"
            )
    return asymetry_value, eff_asymetry_value


with open(result_file_path, "w") as f:
    f.write("Results\n")

plt.gca().set_prop_cycle(color=colors1)
for wils in Wilson_coefficients:
    print(f"Drawing graph for C_{wils}")

    with open(result_file_path, "a")as f:
        f.write(f"--------------------\n C_{wils}\n -------------------\n")
        f.write(f"{prefix:<8}| {'process':<8}| {'xsec':<15}| {'efficiency':<15}| {'xsec * eff':<15} | {'asymetry':<15}\n")

    base_dir = f"{main}/mg5_complete/C_{wils}/pp_c{proc}/{variable}{option}"

    folders = glob.glob(os.path.join(base_dir, f"{prefix}_*"))

    xaxis_data = []
    for folder in folders:
        name = os.path.basename(folder)
        match = re.match(rf"{prefix}_([\d.]+)", name)
        if match:
            xaxis_data.append((float(match.group(1)), match.group(1)))

    xaxis_data.sort(key=lambda x: x[0]) 
    xaxis_values = [x[0] for x in xaxis_data]   #Številčne vrednosti - za graf
    xaxis_strings = [x[1] for x in xaxis_data]  #Besedilne vrednosti - za poti do result.dat datotek

    #Izračunana asimetrija za vsako vrednost koeficienta
    asymetry_values = []
    eff_asymetry_values = []

    if variable == "wils":
        for x_val, x_str in zip(xaxis_values, xaxis_strings):
            print(f"\r\033[KCollecting data for {variable} = {x_str}", end="", flush=True)
            C_value = x_val
            asymetry_value, eff_asymetry_value = asymetry(wils, x_val, x_str, C_value)
            asymetry_values.append(asymetry_value)
            eff_asymetry_values.append(eff_asymetry_value)
    elif variable == "pt":
        C_value = pt_C_values[wils]
        for x_val, x_str in zip(xaxis_values, xaxis_strings):
            print(f"\r\033[KCollecting data for {variable} = {x_str}", end="", flush=True)
            asymetry_value, eff_asymetry_value = asymetry(wils, x_val, x_str, C_value)
            asymetry_values.append(asymetry_value)
            eff_asymetry_values.append(eff_asymetry_value)
    print(" ")
    asymetry_values = np.array(asymetry_values)
    eff_asymetry_values = np.array(eff_asymetry_values)

    label = rf"$C_{{{wils}}}$"
    if "1" in wils:
        label = rf"$C_{{{wils[:-1]}}}^{{(1)}}$"
    elif "3" in wils:
        label = rf"$C_{{{wils[:-1]}}}^{{(3)}}$"
    
    plt.plot(xaxis_values, asymetry_values, linestyle="--")
    plt.plot(xaxis_values, eff_asymetry_values, alpha=0.7, label=label)

plt.plot([], [], color="black", linestyle="--", label="MadGraph5")
plt.plot([], [], color="black", label="MadGraph5 + Pythia + Delphes")

plt.xlabel(xlabel)                                                               
plt.ylabel(r"$\frac{\sigma_c - \sigma_{\bar{c}}}{\sigma_c + \sigma_{\bar{c}}}$")
plt.legend()
plt.savefig(fig_path)                              
plt.show()

print(f"Graph stored in: {fig_path}")