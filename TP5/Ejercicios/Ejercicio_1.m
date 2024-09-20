clc; clear all; close all;

fprintf('######################################################\n');
fprintf('#                Ejercicios 1  TP5                   #\n');
fprintf('######################################################\n\n');

%% DEFINICIÓN DEL ROBOT Y PLOT
fprintf("------------Robot del ejercicio 1------------------\n\n");

global a1     % Dar valores solo positivos
global a2     % Dar valores solo positivos
a1 = 2;
a2 = 1;
fprintf("\nLongitud de los eslabones:");
fprintf("\na1 =  %f", a1);
fprintf("\na2 =  %f", a2);

DH          =      [0 0 a1 0 0;
                    0 0 a2 0 0];
robot       = SerialLink(DH, 'name', '2R');
robot.qlim  = [-pi pi
               -pi pi];
q = [0 0];
figure(1);
robot.plot(q, 'workspace', [-(a1 + a2)*1.2 (a1 + a2)*1.2 -(a1 + a2)*1.2 (a1 + a2)*1.2 -1 1],'scale', 0.5,'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.5);

%% CINEMÁTICA INVERSA
fprintf("-----------DEFINICIÓN DEL PROBLEMA-------------\n");

x = input('\nIndicar la coordenada X: ');
y = input('Indicar la coordenada Y: ');
fprintf("Problema --> [q1 q2] = f(%f, %f)\n", x, y);

%% Fórmulas indicadas en la resolución del ejercicio

try
    [q1 q2] = ikine(x, y);
    fprintf("\n------------------SOLUCIONES-------------------\n");
    fprintf("\nCodo abajo:");
    fprintf("\nq = [q1 q2] = [%.2f° %.2f°]", rad2deg(q1(1)), rad2deg(q2(1)));
    fprintf("\n\nCodo arriba:");
    fprintf("\nq = [q1 q2] = [%.2f° %.2f°]", rad2deg(q1(2)), rad2deg(q2(2)));
    fprintf("\n\n--------------VERIFICACIÓN CON RTB--------------\n");

    fprintf("Postura del robot codo abajo\n");
    T = robot.fkine([q1(1) q2(1)]).T;
    disp(T);
    fprintf("\nPosición del extremo\n");
    disp(T(:, 4));
    robotCU = SerialLink(robot, 'name', 'codo abajo');
    figure(2);
    robotCU.plot([q1(1) q2(1)], 'workspace', [-(a1 + a2)*1.2 (a1 + a2)*1.2 -(a1 + a2)*1.2  (a1 + a2)*1.2 -1 1],'scale', 0.5,'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.5);

    fprintf("Postura del robot codo arriba\n");
    T       = robot.fkine([q1(2) q2(2)]).T;
    disp(T);
    fprintf("\nPosición del extremo\n");
    disp(T(:, 4));
    robotCD = SerialLink(robot, 'name','codo arriba');
    figure(3);
    robotCD.plot([q1(2) q2(2)], 'workspace', [-(a1 + a2)*1.2 (a1 + a2)*1.2 -(a1 + a2)*1.2 (a1 + a2)*1.2 -1 1],'scale', 0.5,'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.5);

    fprintf("\n----------------------------------------------\n");
    fprintf('\nPresione Enter para continuar.\n');
    pause
catch ME
    if (strcmp(ME.identifier, "MyException:ikine"))
        fprintf("\n\nExcepción en la cinemática inversa: ");
        disp(ME.message);
    else
        throw(ME);
    end
end

%% CINEMÁTICA INVERSA MÉTODO geométrico 1
% Se considera la formulación q = [q1 q2] = f(x, y)
function [q1 q2] = ikine(x, y)
    global a1
    global a2

    acosArg = (x^2 + y^2 - (a1^2 + a2^2))/(2*a1*a2); % argumento del acos

    if (abs(acosArg) > 1)
        ME = MException("MyException:ikine", "(x, y) fuera del alcance del robot");
        throw(ME);
    end

    q2 = acos(acosArg);
    A  = a1 + a2*cos(q2);
    q2 = [q2; -q2];                   % Ambos valores de q2

    B  = a2*sin(q2);
    q1 = atan2(A*y - B*x, A*x + B*y); % Ambos valores de q1
end