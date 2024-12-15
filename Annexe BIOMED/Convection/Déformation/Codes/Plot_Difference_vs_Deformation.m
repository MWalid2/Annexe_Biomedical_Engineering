function Plot_Difference_vs_Deformation(M, N, L, D, a, P0, P1)
    steps = [2, 3, 4,5, 6]; % Steps to consider (excluding 6 and 8)
    deformation_sizes = steps; % Deformation inversely proportional to step
    mean_differences = zeros(size(steps)); % To store differences between means
    
    % Loop over each step size
    for idx = 1:length(steps)
        step = steps(idx);
        
        % Compute the velocity components and pressure for both configurations
        [Ux1, Uy1, ~] = vecteur_G_def(M, N, L, D, 2,step, a, P0, P1);
     
        
        % Compute the velocity magnitude and reshape for sections
        U1 = sqrt(Ux1.^2 + Uy1.^2);
        U1 = reshape(U1, N, M); % Reshape to match (N, M) grid

        
        % Compute flow rates by integrating velocity over the cross-section
        delta_y = D / (N - 1); % Step in the y-direction
        Qg = sum(U1, 1)' * delta_y; % Left section

        % Calculate mean difference
        mean_Qg = mean(Qg);
       mean_differences(idx) = mean_Qg;
    end
    
    % Plot the difference between means as a function of deformation size
    figure;
    plot(deformation_sizes, mean_differences, '-o', 'LineWidth', 1.5);
    title('Débit en fonction de l''hauteur de la déformation');
    xlabel('Hauteur de la déformation');
    ylabel('Débit');
    grid on;
end
