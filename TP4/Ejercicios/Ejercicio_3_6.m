clc; clear all; close all;

%% PARÁMETROS DH FANUC
dh = [0 0.450 0.075 -pi/2 0;
      0 0.000 0.300  0.0  0;
      0 0.000 0.075 -pi/2 0;
      0 0.320 0.000  pi/2 0;
      0 0.000 0.000 -pi/2 0;
      0 0.008 0.000  0.0  0];

% Coordenadas articulares para comprobar la matriz de transformación 2 (T2) 
q2 = [pi/2 pi/2 -pi/2 0 0 0];

% Coordenadas articulares para comprobar la matriz de transformación 1 (T1) 
q1 = [0 0 0 0 0 0];

%% MATRIZ DE TRANSFORMACIÓN 2
T2 = [  0  0 1 0.000;
        0 -1 0 0.703;
        1  0 0 0.000;
        0  0 0 1.000];

%% MATRIZ DE TRANSFORMACIÓN 1
T1 = [0  0.500 0.866 0.4971;
      0 -0.866 0.500 0.4971;
      1  0.000 0.000 0.5250;
      0  0.000 0.000 1.0000];

%% CREACIÓN DEL robot
robot = SerialLink(dh, 'name', 'FANUC T2');

%% LÍMITES DEL ROBOT SEGÚN DATASHEET
robot.qlim   = deg2rad([-170   170;
                        -100   100;
                        -194   194;
                        -190   190;
                        -120   120;
                        -360   360]);

%% PLOT-TEACH MATRIZ 2
figure(1);
robot.plot(q2,'scale', 0.5,'trail', {'r', 'LineWidth', 2}, 'jointdiam', 0.8);
robot.teach(q2);

% SUPERPOSICIÓN DE LA POSICIÓN A ALCANZAR
hold on;
trplot(T2, 'frame', 'M', 'color', 'red', 'length', 0.5);

%% PLOT_TEACH MATRIZ 1
figure(2);
robot1 = SerialLink(robot, 'name', 'FANUC T1');
robot1.plot(q1,'scale', 0.5,'jointdiam', 0.8);
robot1.teach(q1);

%% SUPERPOSICIÓN DE LA POSICIÓN A ALCANZAR
hold on;
trplot(T1, 'frame', 'M', 'color', 'red', 'length', 0.5);