clc; clear all; close all;

fprintf('######################################################\n');
fprintf('#                Ejercicios 5  TP5                   #\n');
fprintf('######################################################\n\n');

%% DEFINICIÓN DEL ROBOT, VARIABLES Y PLOT
fprintf("------------Robot del ejercicio 2.1------------------\n\n");

% Parametros DH robot
a1 = 1;
a2 = 2;
a3 = 3;

dh = [0.0 0.0 a1 0.0 0;
      0.0 0.0 a2 0.0 0;
      0.0 0.0 a3 0.0 0];

% Variables articulares
q  = [0 0 0];

% Construcción del robot
robot        = SerialLink(dh, 'name', 'RRR');

% Offsets inniciales
robot.offset = [0 0 0];

% Límites
robot.qlim   = [-pi pi;
                -pi pi;
                -pi pi];

% Plot del robot
R = a1 + a2 + a3;
robot.plot(q, 'workspace', [-R*1.5 R*1.5 -R*1.5 R*1.5 -1 1], 'trail', {'r', 'LineWidth', 2}, 'top');
robot.teach(q);

%% CINEMÁTICA INVERSA
fprintf("-----------DEFINICIÓN DEL PROBLEMA-------------\n");

x   = input('\nIndicar la coordenada X: ');
y   = input('Indicar la coordenada Y: ');
yaw = input('Indicar la orientacion - yaw(°): ');
fprintf("Problema --> [q1 q2 q3] = f(%f, %f, %f°)\n", x, y, yaw);

try
    [q1 q2 q3] = ikineRRR(robot, x, y, yaw);
    fprintf("\n------------------SOLUCIONES--------------------\n");
    fprintf("\nCodo abajo:");
    fprintf("\nq = [q1 q2 q3] = [%.2f° %.2f° %.2f°]", rad2deg(q1(1)), rad2deg(q2(1)), rad2deg(q3(1)));
    fprintf("\n\nCodo arriba:");
    fprintf("\nq = [q1 q2 q3] = [%.2f° %.2f° %.2f°]", rad2deg(q1(2)), rad2deg(q2(2)), rad2deg(q3(1)));
    fprintf("\n\n--------------VERIFICACIÓN CON RTB--------------\n");

    fprintf("Postura del robot codo abajo\n");
    T = robot.fkine([q1(1) q2(1) q3(1)]).T;
    disp(T);
    fprintf("\nPosición del extremo\n");
    disp(T(1:2, 4));
    robotCU = SerialLink(robot, 'name', 'codo abajo');
    figure(2);
    robotCU.plot([q1(1) q2(1) q3(1)], 'workspace', [-R*1.5 R*1.5 -R*1.5 R*1.5 -1 1],'scale', 0.5,'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.5);

    fprintf("\n------------------------------------------------\n");
    fprintf("Postura del robot codo arriba\n");
    T       = robot.fkine([q1(2) q2(2) q3(2)]).T;
    disp(T);
    fprintf("\nPosición del extremo\n");
    disp(T(1:2, 4));
    robotCD = SerialLink(robot, 'name','codo arriba');
    figure(3);
    robotCD.plot([q1(2) q2(2) q3(2)], 'workspace', [-R*1.5 R*1.5 -R*1.5 R*1.5 -1 1],'scale', 0.5,'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.5);
    

    

    pause
    fprintf('\nPresione Enter para continuar.\n');
catch ME
    if (strcmp(ME.identifier, "MyException:ikine2"))
        fprintf("\n\nExcepción en la cinemática inversa de ikine: ");
        disp(ME.message);
    elseif (strcmp(ME.identifier, "MyException:ikineRRR"))
        fprintf("\n\nExcepción en la cinemática inversa de ikine1: ");
        disp(ME.message);
    else
        throw(ME);
    end
end

%% CINEMÁTICA INVERSA PARA EL ROBOT RRR
function [q1 q2 q3] = ikineRRR(robot, x, y, gamma)
    if (~isa(robot, 'SerialLink'))
        ME = MException("MyException:ikineRRR", "el primer valor pasado a la función debe ser el robot.");
        throw(ME);
    end

    % Primero se determina la posición del extremo del segundo eslabón
    x_2 = x - robot.a(3)*cos(gamma);
    y_2 = y - robot.a(3)*sin(gamma);

    % Luego se resuleve el problema de la cinemática inversa del robot RR cono ikine2
    [q1 q2] = ikine2(robot, x_2, y_2);

    % Finalmente se obtiene el valor de la tercera variable articular
    q3 = gamma - q1 - q2;
end

%% CINEMÁTICA INVERSA MÉTODO GEOMÉTRICO PROPUESTO EN CLASE PARA ROBOT EJERCICIO 1
%{
    Se pretende hacer uso del mismo en otro Script con lo cual toma
    además al robot como parámetro.
%}
% Se considera la formulación q = [q1 q2] = f(x, y)
function [q1 q2] = ikine2(robot, x, y)
    if (~isa(robot, 'SerialLink'))
        ME = MException("MyException:ikine2", "el primer valor pasado a la función debe ser el robot.");
        throw(ME);
    end
    
    phi = atan2(y, x);              % angulo formado por el vector posición respecto del eje X

    % Análisis geométrico vectorial
    % w = u + v
    % w - u = v
    % w^2         + u^2  - 2*w \cdot u                          = v^2
    % x^2 + y^2   + a1^2 - 2*sqrt(x^2 + y^2)*a1*cos(alpha)      = a2^2
    % (x^2 + y^2  + a1^2 - a2^2)/(2*sqrt(x^2 + y^2)*a1)         = cos(alpha)
    % acos((x^2 + y^2  + a1^2 - a2^2)/(2*sqrt(x^2 + y^2)*a1))   = alpha; Lo que da dos soluciones posibles

    % primero verificamos que el denominador del cociente en el argumento de acos sea no nulo
    a1  = robot.a(1);               % longitud del primer eslabón
    a2  = robot.a(2);               % longitud del segundo eslabon
    den = 2*sqrt(x^2 + y^2)*a1;      % denominador en el argumento de acos
    num = x^2 + y^2 + a1^2 - a2^2;   % numerador en el argumento de acos

    if (den == 0)                   % punto en el origen del sistema
        if ~(num == 0)              
            ME = MException("MyException:ikine2", "(x, y) fuera del alcance del robot en acos");
            throw(ME);
        else % es alcanzable en esta situación porque implica un robot con a1 == a2
            alfa = [0; 0];                % en esta siituación podría ser cualquier ángulo en realidad
        end
    else
        if (abs(num/den) > 1)
            ME = MException("MyException:ikine2", "(x, y) fuera del alcance del robot en acos");
            throw(ME);
        else
            alfa = acos(num/den);
            alfa = [alfa; -alfa];
        end
    end

    q1      = phi - alfa;                      % angulo en la primera articulación

    % calculo para la primera alternativa
    T1      = robot.links(1).A(q1(1)).double;   % matriz de transformación directa en la primera articulación
    p_1     = T1\[x; y; 0; 1];                  % coordenadas de p_o = (x, y, 0) respecto de 1, es decir p_1 = (x_1, y_1, 0)

    % x_1 = p_1(1)
    % y_1 = p_1(2)
    % q_2 = atan2(y_1, x_1)

    q2      = atan2(p_1(2), p_1(1));
    q2      = [q2; 0];

    % calculo para la segunda alternativa
    T1      = robot.links(1).A(q1(2)).double;   % matriz de transformación directa en la primera articulación
    p_1     = T1\[x; y; 0; 1] ;                 % coordenadas de p_o = (x, y, 0) respecto de 1, es decir p_1 = (x_1, y_1, 0)
    q2(2)   = atan2(p_1(2), p_1(1));
end