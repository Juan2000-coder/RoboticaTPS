clc; clear all;
pause;

% Llamar al archivo "robot.m" para cargar las variables d5, a2, a3
robot;

global Ca Sb Sg % Declarar las variables como globales
a2 = R.a(2);
a3 = R.a(3);
d5 = R.d(5);

% Definir Sg, Sb y Ca en función de las variables del workspace
global Sg Sb Ca
Sg = d5 / a2;
Sb = a3 / a2;
Ca = d5 / a3;

% Definir los coeficientes del polinomio a, b y c
a = (Sg + Sb * Ca)^2;
b = 2 * (Sg^2 * Ca + Sg * Sb * Ca^2 + Sg * Sb + Sb^2 * Ca - Ca);
c = (Sg * Ca + Sb)^2 - 1 - Ca^2;

% Mostrar los coeficientes en pantalla
disp('Coeficiente a:');
disp(a);
disp('Coeficiente b:');
disp(b);
disp('Coeficiente c:');
disp(c);

% Llamada a la función f(q3, q4)
q3_test = 1.1;
q4_test = 0.8;
[q2_1, q2_2] = f_q2(q3_test, q4_test);  % Calcular los valores de q2


disp(['Valores obtenidos de q2 para q3 = ', num2str(q3_test), ' y q4 = ', num2str(q4_test)]);
disp(['q2_1: ', num2str(q2_1)]);
disp(['q2_2: ', num2str(q2_2)]);

% Evaluar el determinante del jacobiano con q2, q3, q4 y otros valores fijos para q1, q5, q6
disp('Evaluación del determinante del jacobiano para q2_1');
det_jacobiano1 = det(R.jacob0([1 q2_1 q3_test q4_test 1 1]));
disp(det_jacobiano1);

disp('Evaluación del determinante del jacobiano para q2_2');
det_jacobiano2 = det(R.jacob0([1 q2_2 q3_test q4_test 1 1]));
disp(det_jacobiano2);

% Valores de C4 que anulan el determinante det(A) de la matriz del sistema
C4_solution = (-Ca * Sg - Sb) / (Sg + Ca * Sb);

% Mostrar los valores que anulan el determinante
disp('Los valores de C4 que anulan el determinante son:');
disp(C4_solution);

if (abs(C4_solution) > 1)
    disp('El determinante det(A) nunca se anula.');
end

% Calcular el discriminante
discriminante = b^2 - 4*a*c;
disp('El discriminante es:');
disp(discriminante);

% Verificar si el discriminante es menor que cero
if discriminante < 0
    disp('El discriminante es menor a cero. No hay soluciones reales.');
else
    % Calcular las soluciones de la ecuación cuadrática
    C4_1 = (-b + sqrt(discriminante)) / (2*a);
    C4_2 = (-b - sqrt(discriminante)) / (2*a);

    % Guardar las soluciones en un vector
    soluciones = [C4_1, C4_2];

    % Mostrar las soluciones
    disp('Las soluciones de C4 son:');
    disp(soluciones);

    % Filtrar la solución válida que tiene valor absoluto menor que 1
    C4_valida = [];
    for i = 1:length(soluciones)
        if abs(soluciones(i)) <= 1
            C4_valida = soluciones(i);
            disp(['Solución válida de C4 con valor absoluto menor o igual a 1: ', num2str(C4_valida)]);
        end
    end

    % Si hay una solución válida, calcular S4 usando la identidad trigonométrica
    if ~isempty(C4_valida)
        % Usar la identidad C4^2 + S4^2 = 1
        S4_1 = sqrt(1 - C4_valida^2);
        S4_2 = -sqrt(1 - C4_valida^2);  % Recordar que hay dos soluciones posibles para S4

        q4_1 = atan2(S4_1, C4_valida);
        q4_2 = atan2(S4_2, C4_valida);

        disp('Los valores correspondientes de q4 son:');
        disp(['q4_1: ', num2str(q4_1)]);
        disp(['q4_2: ', num2str(q4_2)]);

        % Calcular los valores correspondientes de q3 usando atan2
        detA = (Ca + C4_valida)*Sg + (1 + Ca*C4_valida)*Sb;
        C3 = -(1 + Ca * C4_valida) / detA;
        S3 = Ca * S4_1 / detA;

        q3_1 = atan2(S3, C3);

        S3_alt = Ca * S4_2 / detA;  % Usar el segundo valor de S4
        q3_2 = atan2(S3_alt, C3);

        disp('Los valores correspondientes de q3 son:');
        disp(['q3_1 (para S4_1): ', num2str(q3_1)]);
        disp(['q3_2 (para S4_2): ', num2str(q3_2)]);

        % Verificación de las singularidades
        disp('Verificación de las singularidades');
        disp('Determinante del jacobiano para q3_1, q4_1 (q2, q5 no singulares)')
        det1 = det(R.jacob0([1 1 q3_1 q4_1 1 1]));
        disp(det1);
        if (det1 < eps)
            disp('det1 < eps');
        else
            disp('det1 > eps');
        end

        disp('Determinante del jacobiano para q3_2, q4_2 (q2, q5 no singulares)');
        det2 = det(R.jacob0([1 1 q3_2 q4_2 1 1]));
        disp(det2);
        if (det2 < eps)
            disp('det2 < eps');
        else
            disp('det2 > eps');
        end
    else
        disp('No hay solución válida de C4 con valor absoluto menor o igual a 1.');
    end
end

function [q2_1, q2_2] = f_q2(q3, q4)
    % Definir como globales las variables
    global Ca Sb Sg

    % Definir A y B de acuerdo con las fórmulas dadas
    A = cos(2*q3) - Ca*cos(q4) + Ca*cos(2*q3 + q4) - 1;
    B = Sg*sin(q4) - 2*sin(q3) - Sg*sin(2*q3 + q4) - Sb*sin(2*q3);

    % Calcular q2 usando la función atan2
    q2_1 = atan2(B, A) + pi/2;
    q2_2 = atan2(B, A) - pi/2;
end
