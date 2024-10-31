clc; clear all;pause;

%% Comienzo del ejercicio
fprintf('######################################################\n');
fprintf('########### VISUALIZACIÓN DE SINGULARIDADES ##########\n');
fprintf('######################################################\n\n');

robot;

%% Parametros de las ecuaciones
global Ca Sb Sg
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

fprintf("\nPresiona enter para continuar: \n");
pause;
clc;

figure(1);
fprintf('######################################################\n');
fprintf('################# SINGULARIDAD DE MUÑECA #############\n');
fprintf('######################################################\n\n');
fprintf("\nq5 = n*pi (n entero).");
q = [1 1 1 1 0 1];    % Vector articular ejemplo
R.plot(q,'scale', 0.65,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});


fprintf("\nPresiona enter para continuar: \n");
pause;
clc;
figure(2);
fprintf('######################################################\n');
fprintf('################# SINGULARIDAD DE CODO ###############\n');
fprintf('######################################################\n\n');
fprintf("\nq3 = n*pi (n entero).");
q = [1 pi/4 0 1 1 1];    % Vector articular ejemplo
R.plot(q,'scale', 0.65,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});

fprintf("\nPresiona enter para continuar: \n");
pause;
clc;
figure(3);
fprintf('######################################################\n');
fprintf('############### Singularidad 1 del par ###############\n');
fprintf('######################################################\n\n');
q = [1 pi/4 q3_1 q4_1 1 1];
fprintf("\n Singularidad 1: (q3, q4) = (%f, %f)", q3_1, q4_1);
R.plot(q,'scale', 0.65,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});

fprintf("\nPresiona enter para continuar: \n");
pause;
clc;
figure(4);
fprintf('######################################################\n');
fprintf('############### Singularidad 2 del par ###############\n');
fprintf('######################################################\n\n');
q = [1 pi/4 q3_2 q4_2 1 1];
fprintf("\n Singularidad 2: (q3, q4) = (%f, %f)", q3_2, q4_2);
R.plot(q,'scale', 0.65,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});

fprintf("\nPresiona enter para continuar: \n");
pause;
clc;
figure(5);
fprintf('######################################################\n');
fprintf('### Ejemplo singularidad q2 = f(q3, q4); hombro 1#####\n');
fprintf('######################################################\n\n');
q = [1 q2_1 q3_test q4_test pi/2 pi/2];
R.plot(q,'scale', 0.65,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});

fprintf("\nPresiona enter para continuar: \n");
pause;
clc;
figure(5);
fprintf('######################################################\n');
fprintf('### Ejemplo singularidad q2 = f(q3, q4); hombro 2#####\n');
fprintf('######################################################\n\n');
q = [1 q2_2 q3_test q4_test pi/2 pi/2];
R.plot(q,'scale', 0.65,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});

function [q2_1, q2_2] = f_q2(q3, q4)
    % Definir como globales las variables
    global Ca Sb Sg

    % Definir A y B de acuerdo con las formulas
    A = cos(2*q3) - Ca*cos(q4) + Ca*cos(2*q3 + q4) - 1;
    B = Sg*sin(q4) - 2*sin(q3) - Sg*sin(2*q3 + q4) - Sb*sin(2*q3);

    % Calcular q2 usando la función atan2
    q2_1 = atan2(B, A*Sb) + pi/2;
    q2_2 = q2_1 - pi;
end