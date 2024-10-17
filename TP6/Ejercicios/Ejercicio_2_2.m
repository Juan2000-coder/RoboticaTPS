close all;
clear;
clc;

fprintf('######################################################\n');
fprintf('#                Ejercicios 2_2  TP6                   #\n');
fprintf('######################################################\n\n');

%% parámetros simbólicos
syms a_3

% Parametros DH robot
DH = [0.0 0.0 0.0 pi/2  0;
      0.0 0.0 0.0 -pi/2 1;
      0.0 0.0 a_3 0.0   0];

% Variables articulares simbolicas
syms q1 q2 q3
q  = [q1 q2 q3];

% Construcción del robot
robot      = SerialLink(DH, 'name', '3 gdl RLR');

fprintf("\nCinemática directa simbólica del robot RLR:\n"),
T          = robot.fkine(q);
disp(T.T);
