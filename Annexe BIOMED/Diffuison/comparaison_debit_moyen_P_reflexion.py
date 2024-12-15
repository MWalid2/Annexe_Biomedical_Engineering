import numpy as np
import matplotlib.pyplot as plt

# Paramètres de simulation
nombre_particules = 10000
longueur = 100
hauteur = 25
nombre_iterations = 20000

# Taille de la grille pour la heatmap
taille_grille_x = 100
taille_grille_y = 25
taille_fenetre = 100


def moyenne_mobile(data, window_size):
    """Calcule une moyenne mobile pour lisser les données."""
    return np.convolve(data, np.ones(window_size) / window_size, mode='valid')


def simulation(limite_droite_func, nombre_iterations, nombre_particules, longueur, hauteur, P_refl):
    # Initialisation des positions des particules
    positions = np.zeros((nombre_particules, 2))
    positions[:, 0] = 0
    positions[:, 1] = np.random.uniform(0, hauteur, size=nombre_particules)
    initialement_gauche = positions[:, 0] < longueur / 2

    # Stocker le nombre de passages au bord droit
    debit_temps = []
    # Boucle de simulation
    for frame in range(nombre_iterations):
        # Mouvement aléatoire
        deplacements = np.random.choice([-1, 1], size=(nombre_particules, 2))
        positions += deplacements

        # Rebonds en haut et en bas
        positions[:, 1] = np.where(positions[:, 1] < 0, -positions[:, 1], positions[:, 1])
        positions[:, 1] = np.where(positions[:, 1] > hauteur, 2 * hauteur - positions[:, 1], positions[:, 1])

        # Gestion des sorties à droite selon la forme irrégulière
        particules_sorties = 0  # Compteur de particules sortant au bord droit
        for i in range(nombre_particules):
            x_max = limite_droite_func(positions[i, 1])
            if positions[i, 0] > x_max:
                if np.random.rand() < P_refl:
                    # Réflexion : revenir dans la zone avec mouvement inverse
                    positions[i, 0] = 2 * x_max - positions[i, 0]
                else:
                    # Sortie : réinitialiser à zéro
                    particules_sorties += 1
                    positions[i, 0] = 0

        # Enregistrer le débit pour cette itération
        debit_temps.append(particules_sorties)

        # Gestion des sorties à gauche
        sortie_gauche = (positions[:, 0] < 0) & (~initialement_gauche)
        positions[sortie_gauche, 0] = longueur
        positions[initialement_gauche & (positions[:, 0] < 0), 0] = 0

    # Appliquer le lissage
    debit_lisse = moyenne_mobile(debit_temps, taille_fenetre)
    return debit_temps, debit_lisse


def limite_droite(y):
    """Définir la fonction du bord droit irrégulier."""
    if y < 8:
        return 100
    elif y < 16:
        return 75
    else:
        return 100


def moyenne_stationnaire(debit_lisse, seuil_variance=1e-2):
    """
    Calcule la moyenne du débit lorsque la courbe devient stationnaire.

    :param debit_lisse: Liste des débits lissés
    :param seuil_variance: Seuil pour considérer que la variance est faible (stationnarité)
    :return: Moyenne sur la phase stationnaire
    """
    # Détecter la phase stationnaire (dernière portion des données)
    derniere_portion = debit_lisse[-200:]  # Utiliser les 200 dernières valeurs ou ajuster selon besoin
    if np.var(derniere_portion) < seuil_variance:
        return np.mean(derniere_portion)
    else:
        return None  # La stationnarité n'est pas atteinte


# Liste des valeurs de P_refl à tester
P_refl_values = [0.2,0.3, 0.5,0.8,0.9,1]

# Tracer les résultats et calculer les moyennes stationnaires
plt.figure(figsize=(12, 8))

moyennes_stationnaires = {}  # Stocker les moyennes pour chaque P_refl

for P_refl in P_refl_values:
    debit_temps, debit_lisse = simulation(
        limite_droite, nombre_iterations, nombre_particules, longueur, hauteur, P_refl
    )

    # Calculer la moyenne stationnaire
    moyenne_stat = moyenne_stationnaire(debit_lisse)
    moyennes_stationnaires[P_refl] = moyenne_stat

    # Tracer la courbe lissée
    plt.plot(
        range(taille_fenetre - 1, nombre_iterations),
        debit_lisse,
        label=f'P_refl = {P_refl}, Moyenne stat. = {moyenne_stat:.2f}' if moyenne_stat is not None else f'P_refl = {P_refl}, Moyenne stat. = N/A'
    )

# Configuration du graphique
plt.xlabel('Temps (itérations)')
plt.ylabel('Débit (particules/itération)')
plt.title('Débit lissé en fonction de P_refl')
plt.legend()
plt.grid()
# Tracer les moyennes stationnaires en fonction de P_refl
plt.figure(figsize=(8, 6))
plt.plot(
    P_refl_values,
    [moyenne if moyenne is not None else 0 for moyenne in moyennes_stationnaires.values()],
    marker='o',
    linestyle='-',
    color='b'
)
plt.xlabel('Probabilité de réflexion (P_refl)')
plt.ylabel('Moyenne stationnaire du débit (particules/itération)')
plt.title('Moyenne stationnaire en fonction de P_refl')
plt.grid()
plt.show()


# Afficher les moyennes stationnaires
for P_refl, moyenne in moyennes_stationnaires.items():
    print(f"Moyenne stationnaire pour P_refl = {P_refl}: {moyenne:.2f}")