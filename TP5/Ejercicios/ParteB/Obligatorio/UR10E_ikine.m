%function Q = UR10E_ikine(R, T, q0, q_mejor)
function Q=UR10E_ikine(R,T)
    % Verificacion que sea robot

    

    if ~isa(R, 'SerialLink')
        ME = MException("MyException:UR103_ikine", "el primer valor pasado a la función debe ser el robot.");
        throw(ME);
    end
    % Deshacer R.tool y R.base
    T        = R.base.double\T/R.tool.double;

    % Rescatar los offsets
    offsets  = R.offset;
    R.offset = zeros(1, 6);

    % Definición de las variables
    d1 = R.d(1);
    d2 = R.d(2);
    d3 = R.d(3);
    d4 = R.d(4);
    d5 = R.d(5);
    d6 = R.d(6);

    a1 = R.a(1);
    a2 = R.a(2);
    a3 = R.a(3);
    a6 = R.a(4);
    a5 = R.a(5);
    a6 = R.a(6);

    n  = T(1:3, 1);
    o  = T(1:3, 2);
    a  = T(1:3, 3);
    p  = T(1:3, 4);

    nx = n(1);  % Componente x de n
    ny = n(2);  % Componente y de n
    nz = n(3);  % Componente z de n
    
    ox = o(1);  % Componente x de o
    oy = o(2);  % Componente y de o
    oz = o(3);  % Componente z de o
    
    ax = a(1);  % Componente x de a
    ay = a(2);  % Componente y de a
    az = a(3);  % Componente z de a
    
    px = p(1);  % Componente x de p
    py = p(2);  % Componente y de p
    pz = p(3);  % Componente z de p

    % Calculo de q1
    qq = zeros(6, 8);


    % Cálculo de q1
    % falta verificar el discriminante de la raiz
    q1(1) = atan2(d4,  sqrt((d6*ay - py)^2 + (px - d6*ax)^2 - d4^2)) - atan2(d6*ay - py, px - d6*ax);
    q1(2) = atan2(d4, -sqrt((d6*ay - py)^2 + (px - d6*ax)^2 - d4^2)) - atan2(d6*ay - py, px - d6*ax);

    qq(1,1:4) = q1(1);
    qq(1,5:8) = q1(2);

    % S1 Y C1
    S1(1:4,1) = sin(qq(1,1:4));
    S1(5:8,1) = sin(qq(1,5:8));
    C1(1:4,1) = cos(qq(1,1:4));
    C1(5:8,1) = cos(qq(1,5:8));
    
    % Cálculo de q5
    q5(1:2) = atan2(sqrt((nx*S1 - ny*C1).^2 + (ox*S1 - oy*C1).^2), ax*S1 - ay*C1);
    q5(3:4) = atan2(-sqrt((nx*S1 - ny*C1).^2 + (ox*S1 - oy*C1).^2), ax*S1 - ay*C1);

    qq(5,[1 2 5 6]) = q5(1);
    qq(5,[3 4 7 8]) = q5(3);

    % Cálculo de q6
    S5 = sin(qq(1,1:8));

    % Cálculo de q6
    % Tomar en cuenta de que para 0 y npi se tiene singularidad
    q6 = atan2((-ox*S1 - oy*C1) ./ S5, (nx*S1 - ny*C1) ./ S5);
    qq(5,[1 2 5 6]) = q5(1);
    qq(5,[3 4 7 8]) = q5(3);

    % Cálculo de q2
    % Tomar en cuenta de que para 0 y npi se tiene singularidad
    q234 = atan2((-az ./ S5), (-ax*C1 + ay*S1) ./ S5);

    S234 = sin(q234);
    C234 = cos(q234);

    A    = px*C1 + py*S1 - d5*S234 + d6*S5.*C234;
    B    = pz - d1 + d5*C234 + d6*S5.*S234;

    num  = (A.^2 + B.^2 + a2^2 - a3^2);
    den = sqrt(4*a2^2*a3^2 - (A.^2 + B.^2 - a2^2 - a3^2)^2);

    q2 = atan2(num, den) - atan2(A, B);
    % Cálculo de q3
    Q=1;
end
