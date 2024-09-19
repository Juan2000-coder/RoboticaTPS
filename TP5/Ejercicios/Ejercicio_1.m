clc; clear all; close all;

fprintf('######################################################\n');
fprintf('#                Ejercicios 1  TP5                   #\n');
fprintf('######################################################\n\n');

%% DEFINICIÓN DEL ROBOT Y PLOT
fprintf("------------Robot del ejercicio 1------------------\n\n");

a1    = 1; % Dar valores solo positivos
a2    = 1; % Dar valores solo positivos

DH          =      [0 0 a1 0 0;
                    0 0 a2 0 0];
robot       = SerialLink(DH, 'name', '2R');
robot.qlim  = [-pi pi
               -pi pi];
q = [0 0];
robot.plot(q, 'scale', 0.5,'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.5);
robot.teach(q);

%% CINEMÁTICA INVERSA
fprintf("-----Cinemática inversa por el método geométrico-------------\n\n");

x = input('\n\nIndicar la coordenada X: ');
y = input('\n\nIndicar la coordenada Y: ');
fprintf("\n\n[q1 q2] = f(%f, %f)", x, y);

%% Fórmulas indicadas en la resolución del ejercicio

try
    [q1 q2] = ikine(x, y);
    fprintf("\nCodo arriba:");
    disp([q1(1) q2(1)]);
    fprintf("\nCodo abajo:");
    disp([q1(2) q2(2)]);
    fprintf('Presione Enter para continuar.\n')
    pause
catch ME
    if (strcmp(ME.identifier, "MyException: ikine"))
        fprintf("\n\nExcepción en la cinemática inversa: ");
        disp(ME.msgtext);
    end
end

%% CINEMÁTICA INVERSA MÉTODO geométrico
% Se considera la formulación q = [q1 q2] = f(x, y)
function [q1 q2] = ikine(x, y)
    global a1;
    global a2;
    acosArg = (x^2 + y^2 - (a1^2 + a2^2))/(2*a1*a2) % argumento del acos
    if (abs(acosArg) > 1)
        ME = MException("MyException: ikine", "(x, y) fuera del alcance del robot");
        throw(ME);
    end

    q2 = acos(acosArg);
    A  = a_1 + a_2*cos(q2);

    q2 = [q2; -q2];                   % Ambos valores de q2

    B  = a_2*sin(q2);
    q1 = atan2(A*y - B*x, A*x + B*y); % Ambos valores de q1
end