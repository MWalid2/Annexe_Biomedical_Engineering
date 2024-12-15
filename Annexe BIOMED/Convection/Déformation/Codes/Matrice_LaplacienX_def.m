function A = Matrice_LaplacienX_def(M, N, L, D,stepx,stepy)

    % Paramètres de discrétisation
    delta_x = L / (M - 1);
    delta_y = D / (N - 1);
    be = @(i, j, N) j + (i-1)*N; % Bijection formula
    inverse_be = @(K, N) [floor((K-1)/N) + 1, mod(K-1, N) + 1];

    % Coefficients a, b, c
    b = 1 / delta_x;
    c = 1 / delta_y;
    B = b^2;
    C = c^2;
    a = -2 * (B + C);

    % Define the range parameters as a matrix [xmin, xmax, ymax]
    ranges = generate_ranges(stepx,stepy);

    % Generate deformation list L from all ranges
    L_combined = [];
    for r = 1:size(ranges, 1)
        xmin = ranges(r, 1);
        xmax = ranges(r, 2);
        ymax = ranges(r, 3);
        L_combined = [L_combined; deformation(xmin, xmax, ymax, N)];
    end

    % Initialize matrix A of size (M*N) x (M*N)
    totalSize = M * N;
    A = zeros(totalSize, totalSize);

    % Fill the matrix A
    for k = 1:totalSize
        x = inverse_be(k, N);
        i = x(1);
        j = x(2);

        % Check if the point is not at the boundary and not in L_combined
        if i ~= 1 && i ~= M && j ~= 1 && j ~= N && ~ismember(x, L_combined, 'rows')
            A(k, be(i+1, j, N)) = B; % Right neighbor
            A(k, be(i-1, j, N)) = B; % Left neighbor
            A(k, be(i, j+1, N)) = C; % Top neighbor
            A(k, be(i, j-1, N)) = C; % Bottom neighbor
            A(k, k) = a; % Center
        elseif j == 1 || j == N
            A(k, k) = 1; % Dirichlet condition on vertical boundaries
        elseif i == 1
            if j ~= 1 && j ~= N
                A(k, k) = 1; % Dirichlet at the top boundary
                A(k, be(i+1, j, N)) = -1; % Downward derivative
            end
        elseif i == M
            if j ~= 1 && j ~= N
                A(k, k) = 1; % Dirichlet at the bottom boundary
                A(k, be(i-1, j, N)) = -1; % Upward derivative
            end
        end

        % Handle points in L_combined (Deformation condition)
        if ismember(x, L_combined, 'rows')
            A(k, k) = 1;
        end
    end
end
