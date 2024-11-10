function q34 = q34_singu(R)
    Sg = R.d(5) / R.a(2); % Seno de gamma
    Sb = R.a(3) / R.a(2); % Seno de beta
    Ca = R.d(5) / R.a(3); % Coseno de alpha

    %% Coeficientes a, b y c del polinomio
    a = (Sg + Sb * Ca)^2;
    b = 2 * (Sg^2 * Ca + Sg * Sb * Ca^2 + Sg * Sb + Sb^2 * Ca - Ca);
    c = (Sg * Ca + Sb)^2 - 1 - Ca^2;

    %% Llamada a la función f(q3, q4)
    q3_test      = pi/4;
    q4_test      = pi;
    [q2_1, q2_2] = f_q2(q3_test, q4_test);  % Calcular los valores de q2

    % Calcular el discriminante
    discriminante = b^2 - 4*a*c;

    % Calcular las soluciones de la ecuación cuadrática
    C4_1 = (-b + sqrt(discriminante)) / (2*a);
    C4_2 = (-b - sqrt(discriminante)) / (2*a);

    % Guardar las soluciones en un vector
    soluciones = [C4_1, C4_2];

    % Filtrar la solución válida que tiene valor absoluto menor que 1
    C4_valida = [];
    for i = 1:length(soluciones)
        if abs(soluciones(i)) <= 1
            C4_valida = soluciones(i);
        end
    end

    % Usar la identidad C4^2 + S4^2 = 1
    S4_valida =  sqrt(1 - C4_valida^2);

    % valores de q4 singulares del par
    q4_1 = atan2( S4_valida, C4_valida);
    q4_2 = atan2(-S4_valida, C4_valida);

    % calcular los valores correspondientes de q3 usando atan2
    detA = (Ca + C4_valida)*Sg + (1 + Ca*C4_valida)*Sb;
    C3   = -(1 + Ca * C4_valida) / detA;
    S3   = Ca * S4_valida / detA;

    % valores de q3 singulares correspondientes
    q3_1 = atan2( S3, C3);
    q3_2 = atan2(-S3, C3);

    q34 = [q3_1, q4_1; q3_2, q4_2];
end