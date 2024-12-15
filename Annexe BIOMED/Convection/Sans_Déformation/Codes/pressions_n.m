function [Pin,Pout] = pressions_n(n)
    
    % Constantes et paramètres fixes
    h = 0.79;           % Facteur de réduction pour chaque génération
    P0 = 0;        % Pression d'entrée (Pa) à la génération 0
    L0 = 0.12;          % Longueur de la trachée (m) (génération 0)
    D0 = 0.018;         % Diamètre de la trachée (m) (génération 0)
    mu = 1.81e-5;        % Viscosité dynamique de l'air (Pa·s)
    Q0 = 0.0005;         % Débit volumique (m^3/s) (500 ml/s)
    q0 = 4*Q0/(pi*D0);
    Pin = P0;
    % Calcul de la chute de pression delta P0 pour la trachée
    deltaP0 = (12 * mu * L0 * q0) / (D0^3); 
        
    % Calcul de la pression de sortie pour la trachée (génération 0)
    Pout = Pin - deltaP0;
    if n ~= 0
        for i = 1:n
            % Initialiser la pression d'entrée de la génération 0
            Pin = Pout;  
            % Calcul de Ln et Dn pour la génération i
            Li = h^i * L0;      % Longueur à la génération i
            Di = h^i * D0;      % Diamètre à la génération i
            qi = q0/(2^i);
            % Calcul de la chute de pression delta Pn pour la génération i
            deltaPn = (12 * mu * Li * qi) / (Di^3); 
            
            % Calcul de la pression de sortie pour la génération i
            Pout = Pin - deltaPn;  % Pression de sortie
        end
    end
end