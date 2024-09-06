close all;
clear;
clc;

fprintf('######################################################\n');
fprintf('#                Ejercicios 5  TP3                   #\n');
fprintf('######################################################\n\n');


fprintf("------------Robot de la sección 2.2------------------\n\n");

% Considero dimensiones genericas.

% Parametros DH robot
DH = [0.0 0.0 0.0 pi/2  0;
      0.0 0.0 0.0 -pi/2 1;
      0.0 0.0 1.0 0.0   0];

% Variables articulares
q  = [0 0 0];

% Construcción del robot
robot      = SerialLink(DH, 'name', '3 gdl RLR');

% base
robot.base = trotz(pi/2);

% Offsets iniciales
robot.offset = [0 0.5 -pi/2];

% Límites
robot.qlim   = [deg2rad([0    180]);
                        [0.5    1];
                deg2rad([-90  270])];

% Plot del robot

robot.plot(q, 'workspace', [-2.5 2.5 -2.5 2.5 -1 1], 'trail', {'r', 'LineWidth', 2}, 'top');

robot.teach();
