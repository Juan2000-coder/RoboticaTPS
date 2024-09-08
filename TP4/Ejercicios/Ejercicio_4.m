clc; clear all; close all;

%% PARAMETROS DEL ROBOT
DH = [0.0 340.0   0.0   pi/2  0;
      0.0   0.0   0.0  -pi/2  0;
      0.0 400.0   0.0   pi/2  0;
      0.0   0.0   0.0  -pi/2  0;
      0.0 400.0   0.0   pi/2  0;
      0.0   0.0   0.0  -pi/2  0; 
      0.0  10.0   0.0   0.0   0]; % Adopto un valor genérico para MF(Media Flange)


%% VARIABLES ARTICULARES
q1     = [0.0  0.0  0.0  0.0  0.0  0.0  0.0];    % Variables articulares en posición vertical
q2     = [0.2  -0.3  0.1  0.4  -0.01  0.0  0.1]; % Otra postura al azar
error  = ones(1, 7) * deg2rad(0.1);

%% CONSTRUCCIÓN DEL ROBOT
robot  = SerialLink(DH, 'name', 'LBR iiwa 7 R800');
robot2 = SerialLink(robot, 'name', 'LBR iiwa 7R800');

%% CINEMÁTICA DIRECTA CON Y SIN ERROR POSTURA VERTICAL
fkine_1         = robot.fkine(q1).T;
fkine_w_error_1 = robot.fkine(q1 + error).T;

%% CINEMÁTICA DIRECTA CON Y SIN ERROR POSTURA GENÉRICA
fkine_2         = robot.fkine(q2).T;
fkine_w_error_2 = robot.fkine(q2 + error).T;

%% DIFERENCIA DE POSICIÓN
err_pos_q1       = fkine_1(1:3, 4) - fkine_w_error_1(1:3, 4);
err_pos_q2       = fkine_2(1:3, 4) - fkine_w_error_2(1:3, 4);

%% Errores
fprintf("Error en la postura vertical: %f\n",  norm(err_pos_q1));
fprintf("Error en otra postura postura: %f\n", norm(err_pos_q2));

%% PLOT DEL ROBOT vertical
figure(1)
robot.plot(q1,'scale',0.5, 'trail', {'r', 'LineWidth', 2});
axis([-500 500 -500 500 -250 1500]);
hold on;
trplot(fkine_w_error_1, 'frame', 'E', 'color', 'red', 'length', 500);

%% PLOT DEL ROBOT otra postura
figure(2)
robot2.plot(q2,'scale',0.5, 'trail', {'r', 'LineWidth', 2});
axis([-500 500 -500 500 -250 1500]);
hold on;
trplot(fkine_w_error_2, 'frame', 'E', 'color', 'red', 'length', 500);