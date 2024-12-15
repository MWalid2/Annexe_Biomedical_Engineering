function Plot_Time_vs_MN(L, D, a, P0, P1)
    % Définir la plage de valeurs pour M (et N)
    values = 10:10:80;  % De 10 à 80 avec un pas de 10
    num_values = length(values);
    
    % Initialiser un vecteur pour stocker les durées
    Time_values = zeros(num_values, 1);  % Pour stocker la durée pour chaque M = N
    
    % Boucle sur les valeurs de M = N
    for idx = 1:num_values
        M = values(idx);
        N = M;  % Fixer N égal à M
        
        % Mesurer le temps d'exécution pour vecteur_G
        tic;  % Démarrer le chronomètre
        [Ux, Uy, ~] = vecteur_G(M, N, L, D, a, P0, P1);
        C = sqrt(Ux.^2 + Uy.^2);  % Effectuer les calculs
        C = reshape(C, N, M);
        toc_time = toc;  % Arrêter le chronomètre
        
        % Stocker le temps mesuré
        Time_values(idx) = toc_time;
    end
    
    % Tracer la durée en fonction de M = N
    figure;
    plot(values, Time_values, '-o', 'LineWidth', 1.5);
    xlabel('Maillage');
    ylabel('Temps d''exécution (s)');
    title('Temps d''exécution en fonction de maillage');
    grid on;
end
