%% Inciso a

clear all;
clc;
close all;

%% Matrices de transformación

TO_3D_homog   = eye(3);           % Matriz de transformación homogénea correspondiente al sistema base.
TM_3D_homog   = [0   0  1
                 -1  0  0
                 0  -1  0]; % Matriz de transformación homogénea correspondiente a la transformación de rotación en 3D.

%% Determinación del ángulo de la rotación.

euler_angles = tr2eul(TM_3D_homog, 'deg') % Usando una función del toolbox

%% RESULTADOS POR PANTALLA

fprintf("\nMatriz de transformación homogénea del sistema O.\n");
TO_3D_homog
fprintf("\nMatriz de transformación homogénea (sistema M)\n");
TM_3D_homog

fprintf("\nLa transformación es una rotación con:\n roll : %f \n pitch: %f \n yaw  : %f\n", euler_angles(1), euler_angles(2), euler_angles(3));

%% Representación

figure(1);
title('Ejercicio 1-b');
hold on; grid on; axis equal;

trplot(TO_3D_homog, 'frame', 'O', 'color', 'red', 'length', 1.5);
trplot(TM_3D_homog, 'frame', 'M', 'color', 'blue', 'length', 1 );
view(23.2782, 26.3227)