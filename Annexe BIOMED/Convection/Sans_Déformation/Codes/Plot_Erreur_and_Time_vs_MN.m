function Plot_Erreur_and_Time_vs_MN(L, D, a, P0, P1)
    % Définir la plage de valeurs pour M (et N)
    values = 10:10:80;  % De 10 à 80 avec un pas de 10
    num_values = length(values);
    
    % Initialiser les vecteurs pour les résultats
    Inc_values = zeros(num_values, 1);  % Pour stocker les incertitudes
    Time_values = zeros(num_values, 1); % Pour stocker les durées d'exécution
    
    % Boucle sur les valeurs de M = N
    for idx = 1:num_values
        M = values(idx);
        N = M;  % Fixer N égal à M
        
        % Mesurer le temps d'exécution pour vecteur_G
        tic;  % Démarrer le chronomètre
        [Ux, Uy, ~] = vecteur_G(M, N, L, D, a, P0, P1);
        C = sqrt(Ux.^2 + Uy.^2);  % Calculer la norme
        C = reshape(C, N, M);
        toc_time = toc;  % Arrêter le chronomètre
        
        % Stocker le temps mesuré
        Time_values(idx) = toc_time;
        
        % Calcul de l'incertitude
        QQ = zeros(M, 1);
        Q = zeros(M, 1);
        for i = 1:M
            QQ(i) = (mean(C(:, i))) * D;
            Q(i) = (P0 - P1) / ((12 * a * L) / D^3);
        end
        
        mean_QQ = mean(QQ);
        mean_Q = mean(Q);
        Inc = abs(mean_Q - mean_QQ) / mean_QQ;  % Incertitude absolue
        
        % Stocker l'incertitude
        Inc_values(idx) = Inc;
    end
    
    % Tracer l'incertitude et le temps d'exécution sur un seul graphique
    figure;
    yyaxis left; % Premier axe Y pour l'incertitude
    plot(values, Inc_values, '-o', 'LineWidth', 1.5, 'Color', 'b');
    ylabel('Erreur');
    xlabel('Maillage');
    title('Erreur et Temps d''exécution en fonction de maillage');
    
    yyaxis right; % Deuxième axe Y pour le temps
    plot(values, Time_values, '-s', 'LineWidth', 1.5, 'Color', 'r');
    ylabel('Temps d''exécution (s)');
    
    % Ajouter une légende
    legend({'Erreur', 'Temps d''exécution'}, 'Location', 'best');
    grid on;
end
