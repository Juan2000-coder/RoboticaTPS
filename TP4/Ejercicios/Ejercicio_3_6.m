clc; clear all; close all;

%% PARÁMETROS DH FANUC
dh = [0 0.450 0.075 -pi/2 0;
      0 0.000 0.300  0.0  0;
      0 0.000 0.075 -pi/2 0;
      0 0.320 0.000  pi/2 0;
      0 0.000 0.000 -pi/2 0;
      0 0.008 0.000  0.0  0];
q = [0 0 0 0 0 0];

%% MATRIZ DE TRANSFORMACIÓN 2
T2 = [  0  0 1 0.000;
        0 -1 0 0.703;
        1  0 0 0.000;
        0  0 0 1.000];

%% CREACIÓN DEL robot
robot = SerialLink(dh, 'name', 'FANUC');

%% LÍMITES DEL ROBOT SEGÚN DATASHEET
robot.qlim   = deg2rad([-170   170;
                        -100   100;
                        -194   194;
                        -190   190;
                        -120   120;
                        -360   360]);


%% PLOT-TEACH
robot.plot(q, 'trail', {'r', 'LineWidth', 2});
robot.teach();