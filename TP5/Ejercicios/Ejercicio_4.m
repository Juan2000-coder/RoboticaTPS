close all;
clear;
clc;

fprintf('######################################################\n');
fprintf('#                Ejercicios 4  TP5                   #\n');
fprintf('######################################################\n\n');


fprintf("------------Robot de la sección 2.3------------------\n\n");

% Considero dimensiones unitarias.

% Parametros DH robot
syms a1 a2 a3
DH = [0.0 0.0 a1 0.0  1;
      0.0 0.0 a2 0.0  0;
      0.0 0.0 a3 0.0  0];

% Variables articulares
q  = [0 0 0];

% Construcción del robot
robot      = SerialLink(DH, 'name', '3 gdl LRR');


% Offsets iniciales
%robot.offset = [1 0 0];

% Límites
robot.qlim   = [        [ 1     2];
                deg2rad([-90  270]);
                deg2rad([-90  270])];

% Cinemática directa simbólica.
syms q1 q2 q3 x y z yaw
q_raya = [q1 q2 q3];

robot_fkine     = robot.fkine(q_raya).T;
T               = transl([x y z])*trotz(yaw);

eq    = robot_fkine == T;
eq    = [transpose(eq(1:3,4))];
eq(1) = eq(1) - a1;
eq(1) = subs(eq(1), x-a1, x); %reemplazamos x-a1 por x, que le vamos a llmar \overline(x)

assume(a1 > 0);
assume(a2 > 0);
assume(a3 > 0);

sol = solve(eq, [q1 q2 q3]);
sol.q1 = simplify(sol.q1);
sol.q2 = simplify(sol.q2);
sol.q3 = simplify(sol.q3);

