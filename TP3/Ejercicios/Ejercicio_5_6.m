close all;
clear;
clc;

fprintf('######################################################\n');
fprintf('#                Ejercicios 5  TP3                   #\n');
fprintf('######################################################\n\n');


fprintf("------------Robot de la sección 3.3------------------\n\n");


% Parametros DH robot
DH = [0.0 340.0   0.0   pi/2  0;
      0.0   0.0   0.0  -pi/2  0;
      0.0 400.0   0.0   pi/2  0;
      0.0   0.0   0.0  -pi/2  0;
      0.0 400.0   0.0   pi/2  0;
      0.0   0.0   0.0  -pi/2  0; 
      0.0  10.0   0.0   0.0   0]; % Adopto un valor genérico para MF(Media Flange)


% Variables articulares
q  = [0.0 0.0 0.0 0.0 0.0 0.0 0.0];

% Construcción del robot
robot      = SerialLink(DH, 'name', 'LBR iiwa 7 R800');


% Offsets iniciales
robot.offset = [0.0 0.0 0.0 0.0 0.0 0.0];

% Límites obtenidos del datasheet del robot
robot.qlim   = deg2rad([-170   170;
                        -120   120;
                        -170   170;
                        -120   120;
                        -170   170;
                        -120   120;
                        -175   175]);


% Plot del robot
robot.plot(q, 'trail', {'r', 'LineWidth', 2});

robot.teach();
