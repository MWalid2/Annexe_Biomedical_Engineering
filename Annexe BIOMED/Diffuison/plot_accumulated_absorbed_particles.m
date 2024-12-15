function plot_accumulated_absorbed_particles()
    % Parameters
    max_niveaux = 5;            % Maximum fractal level for the Koch curve
    longueur_initiale = 1;      % Length of the initial segment
    n_iterations = 5000;       % Number of iterations for random walk
    pas_marche = 0.01;          % Step size for random walk
    facteur_agrandissement = 3; % Scaling factor for the fractal
    hauteur_domaine = 2;        % Height of the domain
    n_particules = 10000;       % Number of particles per simulation

    % Storage for accumulated absorbed particles per level
    absorbed_particles = zeros(1, max_niveaux + 1);

    % Loop over fractal levels
    for niveaux = 0:max_niveaux
        % Generate the Koch curve for the current level
        [x_fractale, y_fractale] = construire_fractale([0, longueur_initiale], [0, 0], niveaux);

        % Scale and shift the fractal
        x_fractale = x_fractale * facteur_agrandissement;
        y_fractale = y_fractale * facteur_agrandissement;
        y_fractale = y_fractale - min(y_fractale);

        % Initialize particle positions
        x_particules = rand(1, n_particules) * (max(x_fractale) - min(x_fractale)) + min(x_fractale);
        y_particules = repmat(hauteur_domaine, 1, n_particules);
        absorbees = false(1, n_particules);

        % Simulation loop
        for t = 1:n_iterations
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
                else
                    x_particules(i) = x_new;
                    y_particules(i) = y_new;
                end
            end
        end

        % Count total absorbed particles for this level
        absorbed_particles(niveaux + 1) = sum(absorbees);
    end

    % Plot accumulated absorbed particles as a function of fractal level
    figure;
    plot(0:max_niveaux, absorbed_particles, 'o-', 'LineWidth', 1.5, 'MarkerSize', 8);
    title('Accumulated Absorbed Particles vs Fractal Level');
    xlabel('Fractal Level (niveaux)');
    ylabel('Accumulated Absorbed Particles');
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
