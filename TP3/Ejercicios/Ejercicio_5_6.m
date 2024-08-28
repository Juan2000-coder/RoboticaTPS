close all;
clear;
clc;

fprintf('######################################################\n');
fprintf('#                Ejercicios 5  TP3                   #\n');
fprintf('######################################################\n\n');


fprintf("------------Robot de la sección 3.2------------------\n\n");


% Parametros DH robot
DH = [0.0 450.0   75.0  pi/2  0;
      0.0   0.0  300.0  0.0   0;
      0.0   0.0   75.0  pi/2  0;
      0.0 320.0    0.0 -pi/2  0;
      0.0   0.0    0.0  pi/2  0;
      0.0  80.0    0.0  0.0   0];

% Variables articulares
q  = [0 0 0 0 0 0];

% Construcción del robot
robot      = SerialLink(DH, 'name', 'FANUC Paint Mate 200iA');


% Offsets iniciales
robot.offset = [0.0 pi/2 0.0 0.0 0.0 0.0];

% Límites obtenidos del datasheet del robot
robot.qlim   = deg2rad([-170   170;
                        -100   100;
                        -194   194;
                        -190   190;
                        -120   120;
                        -360   360]);


% Plot del robot

robot.plot(q, 'trail', {'r', 'LineWidth', 2});

robot.teach();
