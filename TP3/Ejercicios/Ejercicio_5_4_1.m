close all;
clear;
clc;

fprintf('######################################################\n');
fprintf('#                Ejercicios 5  TP3                   #\n');
fprintf('######################################################\n\n');


fprintf("-Robot de la sección 3.1 con parametros alternativos-\n\n");

% Parametros DH robot
DH = [0.0 199.2 200.0 0.0  0;
      0.0  59.5 250.0 0.0  0;
      0.0   0.0   0.0 pi   1;
      0.0  37.5   0.0 0.0  0];

% Variables articulares
q  = [0 0 0 0];

% Construcción del robot
robot      = SerialLink(DH, 'name', 'SCARA IRB');


% Offsets iniciales
robot.offset = [0 0 -180 0];

% Límites obtenidos del datasheet
robot.qlim   = [deg2rad([-140   140]);
                deg2rad([-150   150]);
                        [ 0     180];
                deg2rad([-400   400])];

% Plot del robot

robot.plot(q, 'trail', {'r', 'LineWidth', 2});

robot.teach();