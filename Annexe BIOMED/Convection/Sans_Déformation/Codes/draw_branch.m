function draw_branch(x, y, length, level, max_levels, M, N, h, L0, D0)
    if level > max_levels
        return;
    end
    spacing = 16*(0.5^ level);
    % Calculate current length and width based on level
    Ln = h^level * L0;
    Dn = h^level * D0;
    
    % Coordinates of the branch (horizontal orientation)
    x_end = x + Ln;
    y_end = y;
    
    % Draw the branch line
    plot([x, x_end], [y, y], 'g', 'LineWidth', 2);
    
    % Generate the heatmap for this branch
    heatmapGrid_n1(M, N, level, x, y, Ln, Dn);
    
    % Calculate positions for the branches' centers
    y_left = y + spacing * Dn / 2;   % Position of the left sub-branch
    y_right = y - spacing * Dn / 2;  % Position of the right sub-branch
    
    % Draw vertical lines connecting the center of the main branch to the two sub-branches
    line([x_end, x_end], [y_end, y_left], 'Color', 'g', 'LineWidth', 2);  % Vertical line to left branch
    line([x_end, x_end], [y_end, y_right], 'Color', 'g', 'LineWidth', 2); % Vertical line to right branch
    
    % Recursive call for the two sub-branches
    % Left branch
    draw_branch(x_end, y_left, Ln, level + 1, max_levels, M, N, h, L0, D0);
    % Right branch
    draw_branch(x_end, y_right, Ln, level + 1, max_levels, M, N, h, L0, D0);
end