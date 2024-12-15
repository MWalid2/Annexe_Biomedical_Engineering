function heatmap3D(M, N, L, D,f)

    % Initialisation de la grille
    x = linspace(0, L, M); % Points en x
    y = linspace(0, D, N); % Points en y
    [X, Y] = meshgrid(x, y); % Génération de la grille 2D
    
    % Création du vecteur associé aux points de la grille (taille M*N)
    values = zeros(N, M); % Notez l'inversion des dimensions pour meshgrid
    
    % Remplir le vecteur avec une bijection (i,j) -> k = j + (i-1)*N
    for j = 1:N
        for i = 1:M
            k = j + (i-1) * N; % Calcul de l'indice k correspondant au point (i,j)
            values(j, i) = f(k, 1); % Remplissage des valeurs (N, M)
        end
    end
    
    % Affichage en 3D
    figure;
    surf(X, Y, values, 'EdgeColor', 'none'); % Affichage de la surface sans bordures
    colormap(parula); % Choix de la colormap
    colorbar; % Ajout de la barre de couleur
    xlabel('Longueur (x)');
    ylabel('Largeur (y)');
    zlabel('Valeur de la fonction f(x,y)');
    title('Représentation 3D de la grille');
    
end
