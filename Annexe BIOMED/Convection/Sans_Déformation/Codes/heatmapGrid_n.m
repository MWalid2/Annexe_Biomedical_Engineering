function heatmapGrid_n(M, N, n)
    
    L0 = 0.12;        
    D0 = 0.018;
    h = 0.79;
    Ln = h^n * L0;      
    Dn = h^n * D0;
    % Initialisation de la grille
    x = linspace(0, Ln, M); % Points en x
    y = linspace(0, Dn, N); % Points en y
    
    
    % Création du vecteur associé aux points de la grille (taille M*N)
    values = zeros(M, N);
    % Remplir le vecteur avec une bijection (i,j) -> k = j + (i-1)*N
    [Ux, Uy, P] = vecteur_G_n(M,N,n);
    for j = 1:N
        for i = 1:M
            k = j + (i-1) * N; % Calcul de l'indice k correspondant au point (i,j)
            % Assigner une valeur au point k 
            values(i,j) = Ux(k,1); % Exemple :
        end
    end
    
    % Transposer pour que les axes correspondent bien
    imagesc(x, y, values'); % Transpose values to match orientation
    colormap(parula);
    colorbar;
    xlabel('Longueur (x)');
    ylabel('Largeur (y)');
    title('Heatmap des valeurs sur la grille');
    end
