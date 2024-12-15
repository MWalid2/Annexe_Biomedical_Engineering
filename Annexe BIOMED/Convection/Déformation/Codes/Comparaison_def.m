function Comparaison_def(M, N, L, D, a, P0, P1)
    % Compute the velocity components and pressure
    [Ux1, Uy1, ~] = vecteur_G_def(M, N, L, D,2,2, a, P0, P1);
    [Ux2, Uy2, ~] = vecteur_G_def(M, N, L, D,2,2, a, P1, P0);
    
    % Compute the velocity magnitude and reshape for sections
    U1 = sqrt(Ux1.^2 + Uy1.^2);
    U1 = reshape(U1, N, M); % Reshape to match (N, M) grid
    U2 = sqrt(Ux2.^2 + Uy2.^2);
    U2 = reshape(U2, N, M); % Reshape to match (N, M) grid
    
    % Initialize variables
    X = linspace(0, L, M)';       % Vector of positions along the length
    X1 = flip(X);                 % Reverse positions for the second group
    delta_y = D / (N - 1);        % Step in the y-direction
    
    % Compute flow rate by integrating velocity over the cross-section
    Qg = sum(U1, 1)' * delta_y; % Left section
    Qd = sum(U2, 1)' * delta_y; % Right section
    
    % Calculate statistics for Qg and Qd
    mean_Qg = mean(Qg);
    Inc_Qg = std(Qg) / mean_Qg;
    mean_Qd = mean(Qd);
    Inc_Qd = std(Qd) / mean_Qd;
    
    % Display the statistics
    fprintf('Débit à gauche (Qg): Moyenne = %.4f, Incertitude = %.4f\n', mean_Qg, Inc_Qg);
    fprintf('Débit à droite (Qd): Moyenne = %.4f, Incertitude = %.4f\n', mean_Qd, Inc_Qd);
    
    % Plot Debit à gauche and Debit à droite in a single figure
    figure;
    
    % Add the mean lines to the plot
    yline(mean_Qg, 'r-', 'LineWidth', 1, 'DisplayName', sprintf('Moyenne Qg = %.4f', mean_Qg));
    yline(mean_Qd, 'b-', 'LineWidth', 1, 'DisplayName', sprintf('Moyenne Qd = %.4f', mean_Qd));
    
    hold off;
    
    % Add labels, legend, and title
    title('Comparaison des débits');
    xlabel('Position (X)');
    ylabel('Débit (Q)');
    legend('show', 'Location', 'best');
    grid on;
    ytickformat('%.3e');
end
