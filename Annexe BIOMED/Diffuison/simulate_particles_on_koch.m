function simulate_particles_on_koch
    % Parameters
    niveaux = 5;               % Fractal level for the Koch curve
    longueur_initiale = 1;     % Length of the initial segment
    n_iterations = 10000;       % Number of iterations for random walk
    pas_marche = 0.01;         % Step size for random walk
    facteur_agrandissement = 3; % Scaling factor for the fractal
    hauteur_domaine = 2;       % Height of the domain
    n_particules = 10000;        % Number of particles

    % Generate the Koch curve
    [x_fractale, y_fractale] = construire_fractale([0, longueur_initiale], [0, 0], niveaux);

    % Scale and shift the fractal
    x_fractale = x_fractale * facteur_agrandissement;
    y_fractale = y_fractale * facteur_agrandissement;
    y_fractale = y_fractale - min(y_fractale);

    % Create figure for simulation
    figure;
    hold on;
    plot(x_fractale, y_fractale, 'k-', 'LineWidth', 1.5);
    title('Particle Simulation near a Koch Boundary');
    xlabel('x');
    ylabel('y');
    axis equal;
    xlim([min(x_fractale) - 0.1, max(x_fractale) + 0.1]);
    ylim([0, hauteur_domaine + 0.1]);
    grid on;

    % Initialize particle positions
    x_particules = rand(1, n_particules) * (max(x_fractale) - min(x_fractale)) + min(x_fractale);
    y_particules = repmat(hauteur_domaine, 1, n_particules);
    absorbees = false(1, n_particules);

    % Scatter plot for particles
    h_particules = scatter(x_particules, y_particules, 20, 'b', 'filled');

    % Prepare for absorbed particle count
    absorbed_per_iteration = zeros(1, n_iterations);

    % Simulation loop
    for t = 1:n_iterations
        absorbed_this_step = 0; % Count absorbed particles in this iteration

        for i = 1:n_particules
            if absorbees(i)
                continue;
            end

            % Random walk direction
            dx = (rand - 0.5) * 2 * pas_marche;
            dy = (rand - 0.5) * 2 * pas_marche;

            x_new = x_particules(i) + dx;
            y_new = y_particules(i) + dy;

            % Check absorption on Koch boundary
            if est_sur_paroi(x_new, y_new, x_fractale, y_fractale)
                absorbees(i) = true;
                x_particules(i) = NaN;
                y_particules(i) = NaN;
                absorbed_this_step = absorbed_this_step + 1;
            else
                x_particules(i) = x_new;
                y_particules(i) = y_new;
            end
        end

        % Store absorbed particle count for this iteration
        absorbed_per_iteration(t) = absorbed_this_step;

        % Update particle positions
        set(h_particules, 'XData', x_particules, 'YData', y_particules);

        % Update the display
        drawnow;
    end

    % Plot absorbed particles per iteration
    figure;
    plot(1:n_iterations, absorbed_per_iteration, 'r-', 'LineWidth', 1.5);
    title('Number of Particles Absorbed per Iteration');
    xlabel('Iteration');
    ylabel('Number of Absorbed Particles');
    grid on;
end

function [new_x, new_y] = construire_fractale(x, y, niveaux)
    % Generate the Koch curve of given levels
    new_x = x;
    new_y = y;
    for n = 1:niveaux
        temp_x = [];
        temp_y = [];
        for i = 1:length(new_x) - 1
            x1 = new_x(i); y1 = new_y(i);
            x2 = new_x(i + 1); y2 = new_y(i + 1);
            dx = (x2 - x1) / 3;
            dy = (y2 - y1) / 3;
            p1x = x1; p1y = y1;
            p2x = x1 + dx; p2y = y1 + dy;
            px = (x1 + x2) / 2 - sqrt(3) * (y2 - y1) / 6;
            py = (y1 + y2) / 2 + sqrt(3) * (x2 - x1) / 6;
            p3x = x1 + 2 * dx; p3y = y1 + 2 * dy;
            p4x = x2; p4y = y2;
            temp_x = [temp_x, p1x, p2x, px, p3x, p4x];
            temp_y = [temp_y, p1y, p2y, py, p3y, p4y];
        end
        new_x = temp_x;
        new_y = temp_y;
    end
end

function sur_paroi = est_sur_paroi(x_particule, y_particule, x_fractale, y_fractale)
    % Check if a particle is near the Koch boundary
    tol = 0.01; % Tolerance for absorption
    sur_paroi = false;
    for i = 1:length(x_fractale) - 1
        dx = x_fractale(i + 1) - x_fractale(i);
        dy = y_fractale(i + 1) - y_fractale(i);
        t = max(0, min(1, ((x_particule - x_fractale(i)) * dx + (y_particule - y_fractale(i)) * dy) / (dx^2 + dy^2)));
        proj_x = x_fractale(i) + t * dx;
        proj_y = y_fractale(i) + t * dy;
        distance = sqrt((x_particule - proj_x)^2 + (y_particule - proj_y)^2);
        if distance < tol
            sur_paroi = true;
            return;
        end
    end
end
