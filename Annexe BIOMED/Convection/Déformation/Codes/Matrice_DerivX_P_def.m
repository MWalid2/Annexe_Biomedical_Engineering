function A = Matrice_DerivX_P_def(M, N, L,stepx,stepy)

    % Paramètres de discrétisation
    delta_x = L / (M - 1);
    be = @(i, j, N) j + (i-1)*N; % Bijection formula
    inverse_be = @(K, N) [floor((K-1)/N) + 1, mod(K-1, N) + 1];
    % Coefficients a, b, c
    
    b = 1/(delta_x);
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

    for k = 1:M*N
        x = inverse_be(k,N);
        i = x(1);
        j = x(2);
        if i ~= 1 && i ~= M && j ~= 1 && j ~= N && ~ismember(x,L,'rows')
            A(k, be(i, j, N)) = -b;
            A(k, be(i+1, j, N)) = b;
        end
    end
end