function heatmapGrid_n1(M, N, n, x_start, y_start, L, D)
    % Grid points in x and y directions
    x = linspace(x_start, x_start + L, M); 
    y = linspace(y_start - D/2, y_start + D/2, N); 
    
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
    
    
    % Display heatmap using the `imagesc` function to fit the fractal branch
    imagesc(x, y, values'); % Transpose values to match orientation
    colormap(parula);
    colorbar;
end