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
robot.offset = [0.0 0.0 0.0 0.0 0.0 0.0 0.0];

% Límites obtenidos del datasheet del robot
robot.qlim   = deg2rad([-170   170;
                        -120   120;
                        -170   170;
                        -120   120;
                        -170   170;
                        -120   120;
                        -175   175]);

% Postura problema
T       = eye(4);
T(:, 4) = [0.23; 0.70; 0.60; 1];

% Plot del robot y postura
figure(1);
robot.plot(q, 'workspace', [-2 2 -2 2 -2 2],'scale', 0.5, 'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.8);
hold on;
trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);

robot.teach(q);

% Obtencion de soluciones
q1 = robot.ikine(T, 'ilimit', 1000,'tol', 1e-12, 'mask', ones(6, 1))
q2 = robot.ikine(T, 'ilimit', 1000, 'rlimit', 500, 'tol', 1e-12, 'q0', [1.2363   0    0   -0.4363    0.2473   -0.1  -0.3818], 'mask', ones(6, 1))
q3 = robot.ikine(T, 'ilimit', 500, 'tol', 1e-12, 'q0', [1.2363  0   -0.3   0   0.2473   -0.4363   -0.3818], 'mask', ones(6, 1))

% ploteo de las soluciones.
robot_q1 = SerialLink(robot, 'name', 'Rq1');
robot_q2 = SerialLink(robot, 'name', 'Rq2');
robot_q3 = SerialLink(robot, 'name', 'Rq3');

figure(2);
robot_q1.plot(q1, 'workspace', [-2 2 -2 2 -2 2],'scale', 0.5, 'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.8);
hold on;
robot_q2.plot(q2, 'workspace', [-2 2 -2 2 -2 2],'scale', 0.5, 'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.8);
hold on;
robot_q3.plot(q3, 'workspace', [-2 2 -2 2 -2 2],'scale', 0.5, 'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.8);
