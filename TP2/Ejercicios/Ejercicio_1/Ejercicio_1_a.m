%% Inciso a

clear all;
clc;
close all;

%% Matrices de transformación

TO_2D_homog   = eye(3);           % Matriz de transformación homogénea correspondiente al sistema base.
TM_2D_homog   = [0.500 -0.866 0
                 0.866 0.500  0
                 0       0    1]; % Matriz de transformación homogénea correspondiente a la transformación de rotación en 2D.

%% Determinación del ángulo de la rotación.

euler_angles = tr2eul(TM_2D_homog, 'deg') % Usando una función del toolbox
roll         = euler_angles(1);
pitch        = euler_angles(2);
yaw          = euler_angles(3);    % Este será evidentemente el único no nulo.


%% RESULTADOS POR PANTALLA

fprintf("\nMatriz de transformación homogénea del sistema O.\n");
TO_2D_homog
fprintf("\nMatriz de transformación homogénea (sistema M)\n");
TM_2D_homog
fprintf("\nLa transformación es una rotación alrededor del eje Z un ángulo %f", yaw);

%% Representación

figure(1);
title('Ejercicio 1-a');
hold on; grid on; axis equal; xlim([-1.5 2.5]);

trplot(TO_2D_homog, 'frame', 'O', 'color', 'red', 'length', 1.8);
trplot(TM_2D_homog, 'frame', 'M', 'color', 'blue', 'length', 1 );


%% Arco de cota de ángulo

r         = 0.5; % Radio del arco
theta_arc = linspace(0, deg2rad(yaw), 100);
x_arc     = r * cos(theta_arc);
y_arc     = r * sin(theta_arc);

%% Acotación del ángulo de rotación
plot(x_arc, y_arc, '-k', 'LineWidth', 1.0); % Dibujar el arco
text(r * cos(deg2rad(yaw)/2) + 0.1, r * sin(deg2rad(yaw)/2), sprintf('%.2f°', yaw), 'FontSize', 8, 'HorizontalAlignment', 'left');
