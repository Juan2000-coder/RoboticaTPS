function [qsol1, qsol2] = q234_singu(R, varargin)
    % Verificación del robot
    if (~isa(R, 'SerialLink'))
        ME = MException("miTeach:isSerialLink", "El primer valor pasado a la función debe ser el robot.");
        throw(ME);
    end

    Sg = R.d(5) / R.a(2); % Seno de gamma
    Sb = R.a(3) / R.a(2); % Seno de beta
    Ca = R.d(5) / R.a(3); % Coseno de alpha

    % Definición de los argumentos opcionales
    p = inputParser;
    addOptional(p, 'q2', false);       % Posición articular inicial
    addOptional(p, 'q3', false);       % Espacio de trabajo
    addOptional(p, 'q4', false);       % Escala del plot

    % Parseo de argumentos
    parse(p, varargin{:});

    % Se obtienen los valores de los argumentos opcionales
    q2           = p.Results.q2;
    q3           = p.Results.q3;
    q4           = p.Results.q4;

    if (q2 == false)
        % Definir A y B de acuerdo con las formulas
        A = cos(2*q3) - Ca*cos(q4) + Ca*cos(2*q3 + q4) - 1;
        B = Sg*sin(q4) - 2*sin(q3) - Sg*sin(2*q3 + q4) - Sb*sin(2*q3);

        % Calcular q2 usando la función atan2
        q2_1 = atan2(B, A*Sb) + pi/2;
        q2_2 = q2_1 - pi;
        qsol1 = q2_1;
        qsol2 = q2_2;
    else if (q4 == false)
        m       = -1/tan(q2);
        a       = Sg*sin(q3)      + m*Sb*Ca*cos(q3);
        b       = m*Sb*Ca*sin(q3) - Sg*cos(q3);
        c       = 1 + Sb*cos(q3)  - m*Sb*sin(q3);
        a_cuad  = a^2 + b ^ 2;
        b_cuad  = -2*b*c;
        c_cuad  = c^2 - a^2;
        disc    = b_cuad^2 - 4*a_cuad*c_cuad;
        if (disc < 0)
            q4_1 = [];
            q4_2 = [];
            warning('q234singu:q4', 'No hay solución real para q4');
        else
            c4_1 = (-b_cuad + sqrt(disc)) / (2*a_cuad);
            c4_2 = (-b_cuad - sqrt(disc)) / (2*a_cuad);
            % obtener c4_i con valor absoluto menor a 1
            if abs(c4_1) <= 1
                q4_1 = atan2(sqrt(1 - c4_1^2), c4_1);
                q4_2 = atan2(-sqrt(1 - c4_1^2), c4_1);
            else if abs(c4_2) <= 1
                q4_1 = atan2(sqrt(1 - c4_2^2), c4_2);
                q4_2 = atan2(-sqrt(1 - c4_2^2), c4_2);
            else
                q4_1 = [];
                q4_2 = [];
                warning('q234singu:q4', 'No hay solución real para q4');
            end
        end
        qsol1 = q4_1;
        qsol2 = q4_2;
    else if (q3 == false)
        m       = -1/tan(q2);

        % Coeficientes a, b y c del polinomio
        a = Sg*sin(q4) + m*Sb*Ca*cos(q4) + m*Sb;
        b = m*Sb*Ca*sin(q4) - Sg*cos(q4) - Sb;
        c = 1;

        a_cuad  = a^2 + b ^ 2;
        b_cuad  = -2*b*c;
        c_cuad  = c^2 - a^2;

        % Calcular el discriminante
        discriminante = b^2 - 4*a*c;

        % Calcular las soluciones de la ecuación cuadrática
        c3_1 = (-b + sqrt(discriminante)) / (2*a);
        c3_2 = (-b - sqrt(discriminante)) / (2*a);

        % obtener c3_i con valor absoluto menor a 1
        if abs(c3_1) <= 1
            q3_1 = atan2(sqrt(1 - c3_1^2), c3_1);
            q3_2 = atan2(-sqrt(1 - c3_1^2), c3_1);
        else if abs(c3_2) <= 1
            q3_1 = atan2(sqrt(1 - c3_2^2), c3_2);
            q3_2 = atan2(-sqrt(1 - c3_2^2), c3_2);
        else
            q3_1 = [];
            q3_2 = [];
            warning('q234singu:q3', 'No hay solución real para q3');
        end
        qsol1 = q3_1;
        qsol2 = q3_2;
    end
end