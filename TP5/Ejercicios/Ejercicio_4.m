close all;
clear;
clc;

fprintf('######################################################\n');
fprintf('#                Ejercicios 5  TP3                   #\n');
fprintf('######################################################\n\n');


fprintf("------------Robot de la sección 2.3------------------\n\n");

% Considero dimensiones unitarias.

% Parametros DH robot
DH = [0.0 1.0 1.0 0.0  1;
      0.0 0.0 1.0 0.0  0;
      0.0 0.0 1.0 0.0  0];

% Variables articulares
q  = [0 0 0];

% Construcción del robot
robot      = SerialLink(DH, 'name', '3 gdl LRR');


% Offsets iniciales
robot.offset = [1 0 0];

% Límites
robot.qlim   = [        [ 1     2];
                deg2rad([-90  270]);
                deg2rad([-90  270])];

% Cinemática directa simbólica.
syms q_raya
robot_fkine     = robot.fkine(q_raya).T
