function A = Matrice_DerivX_def(M, N, L,stepx,stepy)

    % Paramètres de discrétisation
    delta_x = L / (M - 1);
    b = 1 / delta_x;

    % Bijection formulas
    be = @(i, j, N) j + (i-1)*N; 
    inverse_be = @(K, N) [floor((K-1)/N) + 1, mod(K-1, N) + 1];
   
    ranges = generate_ranges(stepx,stepy);
    
    % Generate deformation lists for each range
    L_combined = [];
    for r = 1:size(ranges, 1)
        xmin = ranges(r, 1);
        xmax = ranges(r, 2);
        ymax = ranges(r, 3);
        L_combined = [L_combined; deformation(xmin, xmax, ymax, N)];
    end

    % Initialiser la matrice A de taille (M*N) x (M*N)
    totalSize = M * N;
    A = zeros(totalSize, totalSize);

    % Populate the matrix A
    for k = 1:totalSize
        x = inverse_be(k, N);
        i = x(1);
        j = x(2);

        % Exclude boundaries and deformation points
        if i ~= 1 && i ~= M && j ~= 1 && j ~= N && ~ismember(x, L_combined, 'rows')
            A(k, be(i+1, j, N)) = b / 2;
            A(k, be(i-1, j, N)) = -b / 2;
            continue;
        end

        % Handle range-specific conditions
        for r = 1:size(ranges, 1)
            xmin = ranges(r, 1);
            xmax = ranges(r, 2);
            ymax = ranges(r, 3);


            % Inside range conditions
            if 0 < N-j && N-j <= ymax
                if i == xmin
                    A(k, be(i, j, N)) = 1;
                    A(k, be(i-1, j, N)) = -1;
                    break;
                elseif i == xmax
                    A(k, be(i+1, j, N)) = 1;
                    A(k, be(i, j, N)) = -1;
                    break;
                end
            end
        end
    end
end
