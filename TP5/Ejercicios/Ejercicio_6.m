close all;
clear;
clc;

fprintf('######################################################\n');
fprintf('#                Ejercicios 6  TP5                   #\n');
fprintf('######################################################\n\n');


% Parametros DH robot
DH = [0.0 0.340   0.0   pi/2  0;
      0.0   0.0   0.0  -pi/2  0;
      0.0 0.400   0.0   pi/2  0;
      0.0   0.0   0.0  -pi/2  0;
      0.0 0.400   0.0   pi/2  0;
      0.0   0.0   0.0  -pi/2  0; 
      0.0  0.01   0.0   0.0   0]; % Adopto un valor genérico para MF(Media Flange)


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

% Postura problema
T       = eye(4);
T(:, 4) = [0.23; 0.70; 0.60 1];

% 
q = robot.ikine(T, q1, ones(1, 6));% obtengo todas las variables articulares