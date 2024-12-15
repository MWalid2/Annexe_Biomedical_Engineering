import numpy as np
import matplotlib.pyplot as plt

# Paramètres de simulation
nombre_particules = 10000
longueur = 100
hauteur = 30
nombre_iterations = 20000
taille_fenetre = 100  # Taille de la fenêtre pour le lissage

def moyenne_mobile(data, window_size):
    """Calcule une moyenne mobile pour lisser les données."""
    return np.convolve(data, np.ones(window_size)/window_size, mode='valid')

def simulation(limite_droite_func, nombre_iterations, nombre_particules, longueur, hauteur):
    """Effectue la simulation pour une fonction de déformation donnée."""
    # Initialisation des positions des particules
    positions = np.zeros((nombre_particules, 2))
    positions[:, 0] = np.random.uniform(0, longueur / 8, size=nombre_particules)
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
        positions[:, 1] = np.where(positions[:, 1] > hauteur, 2*hauteur - positions[:, 1], positions[:, 1])

        # Gestion des sorties à droite selon la fonction de déformation
        particules_sorties = 0  # Compteur de particules sortant au bord droit
        for i in range(nombre_particules):
            x_max = limite_droite_func(positions[i, 1])
            if positions[i, 0] > x_max:
                particules_sorties += 1
                positions[i, 0] = x_max

        # Enregistrer le débit pour cette itération
        debit_temps.append(particules_sorties)

        # Gestion des sorties à gauche
        sortie_gauche = (positions[:, 0] < 0) & (~initialement_gauche)
        positions[sortie_gauche, 0] = longueur
        positions[initialement_gauche & (positions[:, 0] < 0), 0] = 0

    # Appliquer le lissage
    debit_lisse = moyenne_mobile(debit_temps, taille_fenetre)
    return debit_temps, debit_lisse

# Définir les deux fonctions de déformation
def limite_droite_3(y):
    if y < 12:
        return 100
    elif y < 18:
        return 80
    else:
        return 100
def limite_droite_1(y):
    if y < 9:
        return 100
    elif y < 21:
        return 80
    else:
        return 100

def limite_droite_2(y):
    if y < 6:
        return 100
    elif y < 24:
        return 80
    else:
        return 100
def limite_droite_4(y):
    if y < 3:
        return 100
    elif y < 27:
        return 80
    else:
        return 100

# Simulation pour les deux cas
debit_temps_1, debit_lisse_1 = simulation(limite_droite_1, nombre_iterations, nombre_particules, longueur, hauteur)
debit_temps_2, debit_lisse_2 = simulation(limite_droite_2, nombre_iterations, nombre_particules, longueur, hauteur)
debit_temps_3, debit_lisse_3 = simulation(limite_droite_3, nombre_iterations, nombre_particules, longueur, hauteur)
debit_temps_4, debit_lisse_4 = simulation(limite_droite_4, nombre_iterations, nombre_particules, longueur, hauteur)
# Affichage des résultats
plt.figure(figsize=(12, 8))

# Débit brut et lissé pour le premier cas
plt.plot(range(taille_fenetre-1, nombre_iterations), debit_lisse_1, label='Débit lissé (Déformation 1)', color='blue')
plt.plot(range(taille_fenetre-1, nombre_iterations), debit_lisse_2, label='Débit lissé (Déformation 2)', color='red')
plt.plot(range(taille_fenetre-1, nombre_iterations), debit_lisse_3, label='Débit lissé (Déformation 3)', color='green')
plt.plot(range(taille_fenetre-1, nombre_iterations), debit_lisse_4, label='Débit lissé (Déformation 4)', color='orange')
plt.xlabel('Temps (itérations)')
plt.ylabel('Débit (particules/itération)')
plt.title('Comparaison du débit pour deux déformations différentes')
plt.legend()
plt.grid()
plt.show()