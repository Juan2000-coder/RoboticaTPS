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

    %% VARIABLES
    d          = R.d;

    %% DESACOPLE CINEMÁTICO
    p          = T.t;            % Posición del extremo respecto a la base
    pc         = p - d(6)*T.a;   % Centro de la muñeca

    %% CALCULO DE q1
    q1(1)      = atan2(pc(2), pc(1));
    if (q1 < 0)
        q1(2)  = q1(1) + pi;
    else
        q1(2)  = q1(1) - pi;
    end

    %% CALCULO DE q2
    p1c = R.links(1).A(q1(1)).inv()*pc; % Centro de la muñeca respecto del sistema {1} para q1_1
    p1c
    trplot(eye(4),'frame', '1', "#D95319" , 'length', 1.5, 'thick', 1);
    hold on;
    frames(R, q0, [0 0 1 1 1 0 0 0], false, 2);
    qq = q1;
end