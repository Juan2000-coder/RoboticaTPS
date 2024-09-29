%function Q = UR10e_ikine(R, T, q0, q_mejor)
function qq = UR10e_ikine(R, T)
    %% Verificacion de parámetros

    % Verificación del robot
    if (~isa(R, 'SerialLink'))
        ME = MException("MyException:UR10e_ikine", "el primer valor pasado a la función debe ser el robot.");
        throw(ME);
    end

    % Verificación de T
    if (~isa(T, 'SE3'))
        T  = SE3(T);
    end
    if (~T.ishomog())
        ME = MException("MyException:UR10e_ikine", "T debe ser matriz de transformación homogénea");
        throw(ME);
    end

    %% Pasos previos a la cinemática inversa
    %  Deshacer las operaciones de base y tool
    T          = R.base.inv()*T*R.tool.inv();

    % Definición de variables
    d          =  R.d;
    a          =  R.a;

    nx         =  T.n(1);
    ny         =  T.n(2);
    nz         =  T.n(3);

    ox         =  T.o(1);
    oy         =  T.o(2);
    oz         =  T.o(3);

    ax         =  T.a(1);
    ay         =  T.a(2);
    az         =  T.a(3);

    px         =  T.t(1);
    py         =  T.t(2);
    pz         =  T.t(3);

    %  Rescatar los offsets
    offsets    = R.offset;
    R.offset   = zeros(1, 6);

    %%  Cálculo de q1

    %  Verificación del discriminante de la raiz
    disc = (d(6)*ay - py)^2 + (px - d(6)*ax)^2 - d(4)^2;

    if (disc < 0)
        warning('UR10e_ikine: q1 complejo', 'El punto está fuera del alcance de robot. Conservando la parte real...');
    end

    phi   = atan2(d(6)*ay - py, px - d(6)*ax);
    q1(1) = real(atan2(d(4),  sqrt(disc))) - phi;
    q1(2) = real(atan2(d(4), -sqrt(disc))) - phi;

    % S1 Y C1
    S1    = sin(q1);
    C1    = cos(q1);
    
    %% Cálculo de q5
    q5(1:2) = atan2(sqrt((nx*S1 - ny*C1).^2 + (ox*S1 - oy*C1).^2), -ax*S1 + ay*C1);
    q5(3:4) = -q5(1:2);

    % Actualizaicón de q1
    q1(3:4) = q1(1:2);

    %% Actualización de senos y cosenos
    S1    = sin(q1);
    C1    = cos(q1);
    S5    = sin(q5);

    %% Cálculo de q6
    if any(S5 == 0)        % Para 0 y npi se tiene singularidad
        warning('UR10e_ikine: q5 == 0 o n*pi', 'Singularidad');
        % En este caso q6 y q234defaults to 45°
    end
    q6    = atan2((-ox*S1 + oy*C1) ./ S5, (nx*S1 - ny*C1) ./ S5);
    
    %% Cálculo de q2
    q234  = atan2((az ./ S5), (ax*C1 + ay*S1) ./ S5);

    S234  = sin(q234);
    C234  = cos(q234);

    A     = px*C1 + py*S1 - d(5)*S234 + d(6)*S5.*C234;
    B     = pz - d(2) + d(5)*C234 + d(6)*S5.*S234;


    %  Verificación del discriminante de la raiz
    disc = 4*a(2)^2*a(3)^2 - (A.^2 + B.^2 - a(2)^2 - a(3)^2).^2;

    if (any(disc) < 0)
        warning('UR10e_ikine: q2 complejo', 'El punto está fuera del alcance de robot. Conservando la parte real...');
    end

    num     = A.^2 + B.^2 + a(2)^2 - a(3)^2;
    den     = sqrt(disc);

    q2(1:4) = real(atan2(num,  den)) - atan2(A, B);
    q2(5:8) = real(atan2(num, -den)) - atan2(A, B);
    C2      = cos(q2);
    S2      = sin(q2);

    %% Cálculo de q3
    C23(1:4) = (A -  a(2)*C2(1:4))/a(3);
    C23(5:8) = (A -  a(2)*C2(5:8))/a(3);
    S23(1:4) = (B -  a(2)*S2(1:4))/a(3);
    S23(5:8) = (B -  a(2)*S2(5:8))/a(3);

    q23      = atan2(S23, C23);
    q3       = q23 - q2;

    %% Cálculo de q4
    %  Actualización de variables
    q234(5:8)   = q234(1:4);

    q1(5:8)     = q1(1:4);
    q5(5:8)     = q5(1:4);
    q6(5:8)     = q6(1:4);
    q4          = q234 - q23;

    %% Solucion final
    qq          = [q1; q2; q3; q4; q5; q6];
    qq          = qq - offsets'*ones(1, 8);
    R.offset    = offsets;
end
