close all;
clear;
clc;

fprintf('######################################################\n');
fprintf('#                Ejercicios 5  TP3                   #\n');
fprintf('######################################################\n\n');




fprintf("------------Robot de la sección 2.1.------------------\n\n");

% Considero dimensiones unitarias.

% Parametros DH robot
dh = [0.0 0.0 1.0 0.0 0;
      0.0 0.0 1.0 0.0 0;
      0.0 0.0 1.0 0.0 0];

% Variables articulares
q  = [0 0 0];

% Construcción del robot
robot        = SerialLink(dh, 'name', 'Robot de la sección 2.1');

% Offsets inniciales
robot.offset = deg2rad([0 0 0]);

% Límites
robot.qlim   = deg2rad([0    180;
                        -90  270;
                        -90  270]);

% Plot del robot
robot.plot(q, 'workspace', [-3.5 3.5 -3.5 3.5 -1 1], 'trail', {'r', 'LineWidth', 2}, 'top');

robot.teach();
