import numpy as np
import matplotlib.pyplot as plt
from matplotlib.patches import Patch

COLORS = {
    "Stable Node": "blue",
    "Stable Spiral": "green",
    "Saddle Point": "red",
    "Unstable Node": "orange",
    "Unstable Spiral": "purple",
}

def plot_fixed_points(fixed_points, ax=None, label=None):
    """fixed_points: list of ((Ie, r_E), state)"""
    if ax is None:
        ax = plt.gca()
    for (Ie, r_E), state in fixed_points:
        ax.scatter(Ie, r_E, c=COLORS[state], s=2)
    ax.set_xlabel("$I_E^{ext}$")
    ax.set_ylabel("$r_E$")
    if label:
        ax.set_title(label)
    plt.legend(handles=[
        Patch(color="red", label='Saddle Point'),
        Patch(color="blue", label='Stable Node'),
        Patch(color='green',label='Stable Spiral'),
        Patch(color='orange',label='Unstable Node'),
        Patch(color='purple',label='Unstable Spiral')
        ], loc='lower right')


def plot_oscillatory_region(results):
    """results: list of (w_EE, w_II, is_oscillatory)"""
    w_EE_vals = sorted(set(r[0] for r in results))
    w_II_vals = sorted(set(r[1] for r in results))

    grid = np.zeros((len(w_II_vals), len(w_EE_vals)))
    ee_idx = {v: i for i, v in enumerate(w_EE_vals)}
    ii_idx = {v: i for i, v in enumerate(w_II_vals)}

    for w_EE, w_II, osc in results:
        grid[ii_idx[w_II], ee_idx[w_EE]] = int(osc)

    _, ax = plt.subplots(figsize=(8, 6))

    ax.contourf(w_EE_vals, w_II_vals, grid,
                levels=[0, 0.5, 1], colors=['#3B4CC0', '#B40426'], alpha=0.85)

    plt.plot(9, 11, 'ko', markersize=10)
    plt.plot(16, 1, 'w*', markersize=15, markeredgecolor='black')

    plt.annotate('NMA\n(bistable)', xy=(9, 11), xytext=(6.5, 14),
                    fontsize=10, ha='center',
                    arrowprops=dict(arrowstyle='->', color='white'),
                    color='white')
    plt.annotate('Li et al.\n(oscillatory)', xy=(16, 1), xytext=(19, 3),
                    fontsize=10, ha='center',
                    arrowprops=dict(arrowstyle='->', color='white'),
                    color='white')

    plt.xlabel('$w_{EE}$', fontsize=12)
    plt.ylabel('$w_{II}$', fontsize=12)
    plt.title('Oscillatory regime in $(w_{EE},\, w_{II})$ parameter space',
                fontsize=13, pad=12)


    plt.legend(handles=[
        Patch(color="#B40426", label='Oscillatory'),
            Patch(color="#3B4CC0", label='Non-oscillatory')
        ], loc='upper right')

def plot_phase_plane(model, ax=None, label=None):
    '''Plot phase plane'''
    if ax is None:
        ax = plt.gca()

    # E-nullcline: r_E -> r_I
    r_E_vals = np.linspace(0.001, 0.96, 500)
    r_I_E = [model._E_null(r_E) for r_E in r_E_vals]

    # I-nullcline: r_I -> r_E
    r_I_vals = np.linspace(0.001, 0.98, 500)
    r_I_vals1 = []
    r_E_Is = []
    for r_I in r_I_vals:
        r_E_I = model._I_null(r_I)
        if r_E_I<0.98:
            r_I_vals1.append(r_I)
            r_E_Is.append(r_E_I)

    ax.plot(r_E_vals, r_I_E, 'r', label='E-nullcline')
    ax.plot(r_E_Is, r_I_vals1, 'b', label='I-nullcline')
    ax.set_xlabel('$r_E$')
    ax.set_ylabel('$r_I$')
    ax.legend()

    if label:
        ax.set_title(label)

    fps = model.find_fixed_point()
    if fps:
        for r_E, r_I in fps:
            state = model.state_system(r_E, r_I)
            ax.plot(r_E, r_I, 'o', c=COLORS[state], markersize=8)

    plt.legend(handles=[
        Patch(color="red", label='Saddle Point'),
        Patch(color="blue", label='Stable Node'),
        Patch(color='green',label='Stable Spiral'),
        Patch(color='orange',label='Unstable Node'),
        Patch(color='purple',label='Unstable Spiral')
        ], loc='upper left')