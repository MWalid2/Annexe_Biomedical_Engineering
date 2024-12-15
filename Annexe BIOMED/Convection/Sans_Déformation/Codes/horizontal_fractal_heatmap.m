function horizontal_fractal_heatmap(n_levels, M, N)
    figure;
    hold on;
    axis equal;
    axis off;
    title('Fractal with Heatmaps on Branches');
    
    % Parameters for branch scaling
    h = 0.79; % scaling factor
    L0 = 0.12; % initial length of branches
    D0 = 0.018; % initial width of branches
    
    % Starting position and orientation (horizontal line to the right)
    start_x = 0;
    start_y = 0;
    start_length = L0;
    
    % Draw the fractal structure
    draw_branch(start_x, start_y, start_length, 0, n_levels, M, N, h, L0, D0);
    
    hold off;
end