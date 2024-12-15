function L = deformation(Xmin, Xmax, Ymax,N)
    L = [];   % Initialisation de la liste de points
    x = Xmin;
    y = N;

    % Boucle pour parcourir l'intervalle Xmin à Xmax et de 0 à Ymax
    while Xmin <= x && x <= Xmax && N-y <= Ymax
        L = [L; x, y];  % Ajout du point (x, y) à la liste

        if x == Xmax
            x = Xmin;  % Réinitialiser x à Xmin
            y = y - 1; % Passer à la ligne suivante
            continue
        end
        x = x + 1;
    end
end
