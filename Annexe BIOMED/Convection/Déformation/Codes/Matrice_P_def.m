function A = Matrice_P_def(M, N,stepx,stepy)
    % Initialiser la matrice A de taille (M*N) x (M*N)
    totalSize = M * N;
    A = zeros(totalSize, totalSize);
    be = @(i, j, N) j + (i-1)*N; % Bijection formula
    inverse_be = @(K, N) [floor((K-1)/N) + 1, mod(K-1, N) + 1];
    
    % Define the range parameters as a matrix
    ranges = generate_ranges(stepx,stepy);
    % Loop through each element in the grid
    for k = 1:M*N
        x = inverse_be(k, N);
        i = x(1);
        j = x(2);
        
        % Boundary conditions
        if i == 1 || i == M
            A(k, k) = 1;
        elseif j == 1
            if i ~= 1 && i ~= M
                A(k, be(i, j+2, N)) = 1;
                A(k, be(i, j+1, N)) = -2;
                A(k, k) = 1;
            end
        elseif i == 2 && j ~= 1
            A(k, be(i-1, j, N)) = 1;
            A(k, be(i+1, j, N)) = 1;
            A(k, k) = -2;
        end
        % Special conditions based on ranges
        for r = 1:size(ranges, 1)
            xmin = ranges(r, 1);
            xmax = ranges(r, 2);
            ymax = ranges(r, 3);

            % Vertical boundary check
            if (N-j == ymax) && (i == xmin || i == xmax)
                A(k, be(i, j, N)) = 1;
                A(k, be(i, j-1, N)) = -1;
            end
            % Horizontal range match
            if (N-j <= ymax) && (xmin < i) && (i < xmax)
                A(k, k) = 1;
                if N-j == ymax
                    A(k, be(i, j-1, N)) = -1;
                end
            end
            % Lower boundary check
            if (N-j < ymax) && (i == xmin)
                A(k, be(i, j, N)) = 1;
                A(k, be(i-1, j, N)) = -1;
            end
            if (N-j < ymax) && (i == xmax)
                A(k, be(i, j, N)) = 1;
                A(k, be(i+1, j, N)) = -1;
            end
        end 
    end
end
