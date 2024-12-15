import numpy as np
import matplotlib.pyplot as plt

# Paramètres de simulation
nombre_particules = 10000
longueur = 100
hauteur = 30
nombre_iterations = 20000

# Taille de la grille pour la heatmap
taille_grille_x = 100
taille_grille_y = 30

# Initialisation des positions des particules
positions = np.zeros((nombre_particules, 2))
positions[:, 0] = np.random.uniform(0, longueur / 8, size=nombre_particules)
positions[:, 1] = np.random.uniform(0, hauteur, size=nombre_particules)
initialement_gauche = positions[:, 0] < longueur / 2

# Matrice pour accumuler la densité de particules
heatmap_cumulative = np.zeros((taille_grille_x, taille_grille_y))

# Définir la fonction du bord droit irrégulier
def limite_droite(y):
    if y < 10:
        return 100
    elif y < 20:
        return 80
    else:
        return 100

# Boucle de simulation
for frame in range(nombre_iterations):
    # Mouvement aléatoire
    deplacements = np.random.choice([-1, 1], size=(nombre_particules, 2))
    positions += deplacements

    # Rebonds en haut et en bas
    positions[:, 1] = np.where(positions[:, 1] < 0, -positions[:, 1], positions[:, 1])
    positions[:, 1] = np.where(positions[:, 1] > hauteur, 2*hauteur - positions[:, 1], positions[:, 1])

    # Gestion des sorties à droite selon la forme irrégulière
    for i in range(nombre_particules):
        x_max = limite_droite(positions[i, 1])
        if positions[i, 0] > x_max:
            positions[i, 0] = x_max

    # Gestion des sorties à gauche
    sortie_gauche = (positions[:, 0] < 0) & (~initialement_gauche)
    positions[sortie_gauche, 0] = longueur
    positions[initialement_gauche & (positions[:, 0] < 0), 0] = 0

    # Accumuler la distribution de particules dans la grille
    heatmap, _, _ = np.histogram2d(positions[:, 0], positions[:, 1], bins=[taille_grille_x, taille_grille_y], range=[[0, longueur], [0, hauteur]])
    heatmap_cumulative += heatmap

# Calculer la moyenne sur toutes les itérations
heatmap_moyenne = heatmap_cumulative / nombre_iterations

# Calcul du Laplacien (différences finies) de la heatmap moyenne
laplacien = np.zeros_like(heatmap_moyenne)

# Appliquer un filtre de différences finies (Laplace)
for i in range(1, taille_grille_x - 1):
    for j in range(1, taille_grille_y - 1):
        laplacien[i, j] = (heatmap_moyenne[i-1, j] + heatmap_moyenne[i+1, j] +
                           heatmap_moyenne[i, j-1] + heatmap_moyenne[i, j+1] - 4 * heatmap_moyenne[i, j])

# Affichage de la heatmap moyenne de concentration
plt.figure(figsize=(5, 3))
plt.imshow(heatmap_moyenne.T, origin='lower', extent=[0, longueur, 0, hauteur], aspect='auto', cmap='YlGnBu')
plt.colorbar(label='Concentration moyenne de particules')
plt.xlabel('Position en x')
plt.ylabel('Position en y')
plt.title('Heatmap moyenne de la concentration des particules (bord droit irrégulier)')
plt.show()

# Affichage du Laplacien de la concentration
plt.figure(figsize=(5, 3))
plt.imshow(laplacien.T, origin='lower', extent=[0, longueur, 0, hauteur], aspect='auto', cmap='coolwarm')
plt.colorbar(label='Laplacien de la concentration')
plt.xlabel('Position en x')
plt.ylabel('Position en y')
plt.title('Laplacien de la concentration des particules')
plt.show()

# Vérification des valeurs nulles du laplacien (proche de zéro)
print(f"Maximum du Laplacien : {np.max(np.abs(laplacien))}")