function A = Matrice_DerivY_def(M, N, D,stepx,stepy)
    % Paramètres de discrétisation
    delta_y = D / (N - 1);
    % Coefficients a, b, c
    be = @(i, j, N) j + (i-1)*N; % Bijection formula
    inverse_be = @(K, N) [floor((K-1)/N) + 1, mod(K-1, N) + 1];
    b = 1/(delta_y);

    % Define the range parameters as a matrix
    % Each row is [xmin, xmax, ymax]
    ranges = generate_ranges(stepx,stepy);

    % Deformations list
    L = [];
    for r = 1:size(ranges, 1)
        xmin = ranges(r, 1);
        xmax = ranges(r, 2);
        ymax = ranges(r, 3);
        L = [L; deformation(xmin, xmax, ymax, N)];
    end

    % Initialiser la matrice A de taille (M*N) x (M*N)
    totalSize = M * N;
    A = zeros(totalSize, totalSize);

    % Loop over all indices
    for k = 1:M*N
        x = inverse_be(k, N);
        i = x(1);
        j = x(2);

        % Check general conditions
        if i ~= 1 && i ~= M && j ~= 1 && j ~= N && ~ismember(x, L, 'rows')
            A(k, be(i, j-1, N)) = -b/2;
            A(k, be(i, j+1, N)) = b/2;
        end

        % Special conditions
        if j == 1 && i ~= 1 && i ~= M
            A(k, be(i, j+1, N)) = 1;
            A(k, be(i, j, N)) = -1;
        elseif j == N && i ~= 1 && i ~= M && ~ismember(x, L, 'rows')
            A(k, be(i, j-1, N)) = -1;
            A(k, be(i, j, N)) = 1;
        end

        % Check if the current position matches any of the ranges
        for r = 1:size(ranges, 1)
            xmin = ranges(r, 1);
            xmax = ranges(r, 2);
            ymax = ranges(r, 3);

            % Inside range match
            if (N - j == ymax && xmin <= i && i <= xmax)
                A(k, be(i, j-1, N)) = -1;
                A(k, be(i, j, N)) = 1;
            end
        end
    end
end
