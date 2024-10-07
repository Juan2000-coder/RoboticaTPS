function qq = ikine_pieper(R, T, q0, q_mejor)
    % Verificación del robot
    if (~isa(R, 'SerialLink'))
        ME = MException("ikine_pieper:isSerialLink", "el primer valor pasado a la función debe ser el robot.");
        throw(ME);
    end

    % Verificación de T
    if (~isa(T, 'SE3'))
        T  = SE3(T);
    end

    if (~T.ishomog())
        ME = MException("ikine_pieper:isHomog", "T debe ser matriz de transformación homogénea");
        throw(ME);
    end

    %% Pasos previos a la cinemática inversa
    %  Deshacer las operaciones de base y tool
    % .inv hace lo mismo que la función invHomog (revisado en la definicion
    % del metodo)

    T          = R.base.inv()*T*R.tool.inv();

    %  Rescatar los offsets
    offsets    = R.offset;
    R.offset   = zeros(1, 6);

    %% VARIABLES
    d          = R.d;
    a          = R.a;

    %% DESACOPLE CINEMÁTICO
    p          = T.t;            % Posición del extremo respecto a la base
    pc         = p - d(6)*T.a;   % Centro de la muñeca

    % Verificación centro de la muñeca primer problema Pieper
    % fprintf("\nCentro de la muñeca original\n");
    % R.base*pc

    %% PRIMER PROBLEMA DE PIEPER

    %% CALCULO DE q1
    q1(1)      = atan2(pc(2), pc(1));
    if (q1 < 0)
        q1(2)  = q1(1) + pi;
    else
        q1(2)  = q1(1) - pi;
    end

    %% ITERACIÓN EN q1
    sol = 1;
    for (q1_val = q1)                       % Para cada valor de q1
        p1c = R.links(1).A(q1_val).inv()*pc; % Centro de la muñeca respecto del sistema {1}

        %% CALCULO DE q2 q3 RR planar
        phi = atan2(p1c(2), p1c(1));              % angulo entre vector posición y eje X1

        % Análisis geométrico vectorial
        % w = u + v
        % w - u = v
        % w^2               + u^2  - 2*w \cdot u                                = v^2
        % xp1c^2 + yp1c^2   + a2^2 - 2*sqrt(xp1c^2 + yp1c^2)*a2*cos(alpha)      = d4^2
        % (xp1c^2 + yp1c^2  + a2^2 - d4^2)/(2*sqrt(xp1c^2 + yp1c^2)*a2)         = cos(alpha)
        % acos((xp1c^2 + yp1c^2  + a2^2 - d4^2)/(2*sqrt(xp1c^2 + yp1c^2)*a2))   = alpha; Lo que da dos soluciones posibles

        % Verificamos denominador
        den = 2*sqrt(p1c(1)^2 + p1c(2)^2)*a(2);        % denominador en el argumento de acos
        num = p1c(1)^2 + p1c(2)^2 + a(2)^2 - d(4)^2;   % numerador en el argumento de acos

        if (den == 0)                                  % punto en el origen del sistema
            if ~(num == 0)              
                ME = MException("ikine_pieper:q2", "centro de muñeca fuera del alcance del robot en acos");
                throw(ME);
            else % es alcanzable en esta situación porque implica un robot con a2 == a3
                alfa = [0 0];                % en esta situación podría ser cualquier ángulo en realidad
            end
        else
            if (abs(num/den) > 1)
                num/den
                ME = MException("ikine_pieper:q2", "centro de muñeca fuera del alcance del robot en acos");
                throw(ME);
            else
                alfa = acos(num/den);
                alfa = [alfa -alfa];
            end
        end

        q2          = phi - alfa;                          % angulo en la primera articulación RR

        for (q2_val = q2)
            % coordenadas de pc = (xc, yc, zc) respecto de 2, es decir p2c = (x2c, y2c, 0)
            p2c          = R.links(2).A(q2_val).inv()*p1c;

            % x2c        = p2(1)
            % y2c        = p2(2)
            % q3(prima)  = atan2(y2c, x2c)
            % q3         = pi/2 + q3(prima)

            q3           = pi/2 + atan2(p2c(2), p2c(1));

            %% SEGUNDO PROBLEMA DE PIEPER

            % Obtenemos T de 6 respecto a 3
            T36        = R.A(1:3, [q1_val q2_val q3 0 0 0]).inv()*T;            
            
            %% CÁLCULO DE q4
            a36        = T36.a;      % Eje Z6
            q4(1)      = atan2(a36(2), a36(1));

            if (q4 < 0)
                q4(2)  = q4(1) + pi;
            else
                q4(2)  = q4(1) - pi;
            end
            
            for (q4_val = q4)
                T46 = R.links(4).A(q4_val).inv()*T36;
                a46 = T46.a;
                q5  = atan2(a46(2), a46(1)) + pi/2;

                T56 = R.links(5).A(q5).inv()*T46;
                n56 = T56.n;
                q6  = atan2(n56(2), n56(1));

                % Actualización de soluciones
                qq(:, sol) = [q1_val; q2_val; q3; q4_val; q5; q6];

                % Actualización del contador de soluciones.
                sol        = sol + 1;
            end
        end
    end
    qq          = qq - offsets'*ones(1, 8);
    R.offset    = offsets;
end