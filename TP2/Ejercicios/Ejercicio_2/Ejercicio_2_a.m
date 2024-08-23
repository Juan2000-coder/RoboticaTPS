%% Inciso a

clear all;
clc;
close all;

%% MATRICES DE TRANSFORMACIÓN
yaw           = -17;
TO_2D_homog   = eye(3);           % Matriz de transformación homogénea correspondiente al sistema base.
TM_2D_homog   = trot2(yaw, 'deg'); % Matriz de transformación homogénea correspondiente a la rotación.


%% COORDENADAS DEL VECTOR
M_a = [1; 0.5; 1];
O_a = TM_2D_homog*M_a; % Se aplica la transformación para obtener las coordenadas en el sistema base

%% ARCO DE COTA DE ÁNGULO
r         = 0.5; % Radio del arco
theta_arc = linspace(0, deg2rad(yaw), 100);
x_arc     = r * cos(theta_arc);
y_arc     = r * sin(theta_arc);

%% RESULTADOS POR PANTALLA
fprintf("\nMatriz de transformación homogénea del sistema O.\n");
TO_2D_homog
fprintf("\nMatriz de transformación homogénea (sistema M)\n");
TM_2D_homog

%% REPRESENTACIÓN
figure(1);title('Ejercicio 2-a');hold on; grid on; axis equal;
xlim([-0.2 1.8]);ylim([-0.5 1.7]); %limites de los ejes

trplot(TO_2D_homog, 'frame', 'O', 'color', 'red', 'length', 1.5);
trplot(TM_2D_homog, 'frame', 'M', 'color', 'blue', 'length', 1 );

%% PLOTEOS DEL VECTOR
quiver(0, 0,  O_a(1), O_a(2), 'k', 'LineWidth', 1, 'AutoScale', 'off');  % Plot del vector
text(O_a(1) + 0.05, O_a(2), sprintf('a'), 'FontSize', 10, 'HorizontalAlignment', 'right');

%% GUIAS DE PROYECCCIÓN
plot([O_a(1)  O_a(1)], [0       O_a(2)], '--k', 'LineWidth', 0.5);                        % Plot de las guías
plot([0       O_a(1)], [O_a(2)  O_a(2)], '--k', 'LineWidth', 0.5);

M_x_proy = TM_2D_homog*[M_a(1); 0; 1]; % Vector proyección del punto sobre el eje x rotado
M_y_proy = TM_2D_homog*[0; M_a(2); 1]; % Vector proyección del punto sobre el eje y rotado

plot([M_x_proy(1) O_a(1)], [M_x_proy(2) O_a(2)], '--k','LineWidth', 0.5);
plot([M_y_proy(1) O_a(1)], [M_y_proy(2) O_a(2)], '--k','LineWidth', 0.5);

%% ACOTACIÓN DEL ÁNGULO DE ROTACIÓN
plot(x_arc, y_arc, '-k', 'LineWidth', 0.5);    % Dibujar el arco
text(r * cos(deg2rad(yaw)/2) + 0.1, r * sin(deg2rad(yaw)/2), sprintf('%.2f°', yaw), 'FontSize', 8, 'HorizontalAlignment', 'left');