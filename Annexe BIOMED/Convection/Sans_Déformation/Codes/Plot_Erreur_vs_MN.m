function Plot_Incertitude_vs_MN(L, D, a, P0, P1)
    % Define the range for M (and N)
    values = 10:10:80;  % From 10 to 100 with a step of 10
    num_values = length(values);
    
    % Initialize the results vector for incertitude
    Inc_values = zeros(num_values, 1);  % To store Inc for each value of M = N
    % Loop over M = N values
    for idx = 1:num_values
        M = values(idx);
        N = M;  % Set N equal to M
        % Call vecteur_G and compute the required quantities
        [Ux, Uy, ~] = vecteur_G(M, N, L, D, a, P0, P1);
        C = sqrt(Ux.^2 + Uy.^2);
        C = reshape(C, N, M);
        
        QQ = zeros(M, 1);
        Q = zeros(M, 1);
        for i = 1:M
            QQ(i) = (mean(C(:, i))) * D;
            Q(i) = (P0 - P1) / ((12 * a * L) / D^3);
        end
        % Compute mean and incertitude
        mean_QQ = mean(QQ);
        mean_Q = mean(Q);
        Inc = abs(mean_Q - mean_QQ) / mean_QQ;  % Absolute incertitude
        % Store the incertitude value
        Inc_values(idx) = Inc;
    end
    % Plot the incertitude as a function of M (or N)
    figure;
    plot(values, Inc_values, '-o', 'LineWidth', 1.5);
    xlabel('Maillage');
    ylabel('Incertitude');
    title('Incertitude en fonction de maillage');
    grid on;
end
