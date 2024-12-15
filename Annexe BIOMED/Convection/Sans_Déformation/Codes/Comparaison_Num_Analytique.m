function Comparaison_Num_Analytique(M,N,L,D,a,P0,P1)
    [Ux, Uy, P] = vecteur_G(M,N,L,D,a,P0,P1);
    U = sqrt(Ux.^2 + Uy.^2);
    U = U(1:N,1);
    for i=1:N
    X(i,1) = (i-1)*D/(N-1);
    end
    % Plot the numerical result (red circles)
    plot(X, U, 'ro', 'DisplayName', 'Vitesse numérique');
    hold on;

    X_dense = linspace(0, D, 100); 
    u_analytical = ((P1 - P0) / (2 * a * L)) * X_dense.^2 - (D * (P1 - P0) / (2 * a * L)) * X_dense;

    % Plot the analytical result (smooth blue line)
    plot(X_dense, u_analytical, 'b-', 'DisplayName', 'Vitesse analytique');
    
    % Add labels and legend
    xlabel('Y en m');
    ylabel('Vitesse en m/s');
    legend('show');
    hold off;
end