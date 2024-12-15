function [Ux, Uy, P] = vecteur_G_n(M, N, n)
    h = 0.79;
    mu = 1.81e-5;
    L0 = 0.12;          % Longueur de la trachée (m) (génération 0)
    D0 = 0.018;         % Diamètre de la trachée (m) (génération 0)
    Ln = h^n * L0;      % Longueur à la génération i
    Dn = h^n * D0;      % Diamètre à la génération i

    [Pin,Pout] = pressions_n(n);
    
    % Calcul de la matrice A et du vecteur Y pour résoudre les équations de Stokes
    [Ux,Uy,P] = vecteur_G(M,N,Ln,Dn,mu,Pin,Pout);
  
end
