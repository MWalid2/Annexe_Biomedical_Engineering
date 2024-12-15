import numpy as np
import matplotlib.pyplot as plt

# Définir les paramètres
C0 = 3.37  # Concentration initiale
L = 100   # Longueur du rectangle (axe horizontal)
H = 25    # Hauteur du rectangle (axe vertical)
Lambda = 30 # longueur de périmètre non écrantée en cm


# Définir la fonction limite_droite basée sur une gaussienne
def limite_droite(y):
    a = 20     # Amplitude (effet de réduction maximal)
    b = 12.5   # Position centrale de la réduction (milieu du domaine en y)
    c = 8      # Largeur de la transition (écart-type)
    return 100 - a * np.exp(-((y - b) ** 2) / (2 * c ** 2))

# Créer une grille de points (x, y)
x = np.linspace(0, L, 100)  # Plus de points pour une résolution lisse
y = np.linspace(0, H, 25)
X, Y = np.meshgrid(x, y)

# Calculer la concentration en fonction de la limite droite
C = np.zeros_like(X)

for i in range(len(y)):
    # Pour chaque ligne (y), calculer la concentration en fonction de x_max
    x_max = limite_droite(y[i])
    # La concentration dépend de la position en x relative à x_max
    C[i, :] = ( C0 / (Lambda+x_max) ) * ( Lambda+x_max - X[i, :] )

# Tracer la heatmap avec les couleurs similaires à l'image
plt.figure(figsize=(10, 6))
heatmap = plt.contourf(X, Y, C, cmap="hot", levels=50)  # Utilise la colormap "hot"
cbar = plt.colorbar(heatmap, label='Concentration moyenne de particules')

# Ajouter des labels et des titres
plt.title("Heatmap de la concentration des particules avec bord droit irrégulier")
plt.xlabel("Position en x")
plt.ylabel("Position en y")
plt.show()
