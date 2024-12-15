function heatmapGrid(M, N, L, D,f)
    
    % Initialisation de la grille
    x = linspace(0, L, M); % Points en x
    y = linspace(0, D, N); % Points en y
    
    
    % Création du vecteur associé aux points de la grille (taille M*N)
    values = zeros(M, N);
    
    % Remplir le vecteur avec une bijection (i,j) -> k = j + (i-1)*N
    for j = 1:N
        for i = 1:M
            k = j + (i-1) * N; % Calcul de l'indice k correspondant au point (i,j)
            % Assigner une valeur au point k 
            values(i,j) = f(k,1); % Exemple :
        end
    end
    
    
    % Afficher la heatmap
    imagesc(x, y, values'); % Transpose values to match orientation
    colormap(parula);
    colorbar;
    xlabel('Longueur (x)');
    ylabel('Largeur (y)');
    title('Heatmap des valeurs sur la grille');
    end
