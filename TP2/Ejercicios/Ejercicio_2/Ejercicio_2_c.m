
clear all;
clc;
close all;

%% MATRICES DE TRANSFORMACIÓN
pitch         = 90;
TO_3D_homog   = eye(3);             % Matriz de transformación homogénea correspondiente al sistema base.
TM_3D_homog   = troty(pitch, 'deg'); % Matriz de transformación homogénea correspondiente a la rotación.


%% COORDENADAS DEL VECTOR
M_c = [1; 0.5; 0.3; 1];
O_c = TM_3D_homog*M_c; % Se aplica la transformación para obtener las coordenadas en el sistema base

%% ARCO DE COTA DE ÁNGULO
r         = 0.5; % Radio del arco
theta_arc = linspace(0, deg2rad(pitch), 100);
z_arc     = r * cos(theta_arc);
x_arc     = r * sin(theta_arc);

%% RESULTADOS POR PANTALLA
fprintf("\nMatriz de transformación homogénea del sistema O.\n");
TO_3D_homog
fprintf("\nMatriz de transformación homogénea (sistema M)\n");
TM_3D_homog

%% REPRESENTACIÓN
figure(1);title('Ejercicio 2-c');hold on; grid on; axis equal;
xlim([-0.2 1.8]);ylim([-0.2 1.8]);zlim([-1.2 1.6]) %limites de los ejes
view(38.7000, 31.6810);

trplot(TO_3D_homog, 'frame', 'O', 'color', 'red', 'length', 1.5);
trplot(TM_3D_homog, 'frame', 'M', 'color', 'blue', 'length', 1 );

%% PLOTEOS DEL VECTOR
quiver3(0, 0, 0,  O_c(1), O_c(2), O_c(3), 'k', 'LineWidth', 1, 'AutoScale', 'off');  % Plot del vector
text(O_c(1) + 0.1, O_c(2) + 0.1, O_c(3) + 0.1, sprintf('c'), 'FontSize', 12, 'HorizontalAlignment', 'right');

%% GUIAS DE PROYECCCIÓN
% Plot de guías
plot3([O_c(1)  O_c(1)], [O_c(2)  O_c(2)], [0      O_c(3)], '--k', 'LineWidth', 0.5); % En el plano xy
plot3([O_c(1)  O_c(1)], [0       O_c(2)], [0           0], '--k', 'LineWidth', 0.5); % En x 
plot3([0       O_c(1)], [O_c(2)  O_c(2)], [0           0], '--k', 'LineWidth', 0.5); % En y
plot3([0       O_c(1)], [0       O_c(2)], [O_c(3) O_c(3)], '--k', 'LineWidth', 0.5); % En z

M_x_proy = TM_3D_homog*[M_c(1); 0; 0; 1]; % Vector proyección del punto sobre el eje x rotado
M_y_proy = TM_3D_homog*[0; M_c(2); 0; 1]; % Vector proyección del punto sobre el eje y rotado
M_z_proy = TM_3D_homog*[0; 0; M_c(3); 1]; % Vector proyección del punto sobre el eje z rotado

M_xy_proy = M_x_proy + M_y_proy;  % Proyeccion en el plano xy rotado
plot3([M_xy_proy(1)      O_c(1)], [M_xy_proy(2)      O_c(2)], [M_xy_proy(3)      O_c(3)] , '--k','LineWidth', 0.5); % En el plano xy rotado
plot3([M_x_proy(1) M_xy_proy(1)], [M_x_proy(2) M_xy_proy(2)], [M_x_proy(3) M_xy_proy(3)] , '--k','LineWidth', 0.5); % En el eje x rotado
plot3([M_y_proy(1) M_xy_proy(1)], [M_y_proy(2) M_xy_proy(2)], [M_y_proy(3) M_xy_proy(3)] , '--k','LineWidth', 0.5); % En el eje y rotado
plot3([M_z_proy(1)       O_c(1)], [M_y_proy(2)       O_c(2)], [M_z_proy(3)       O_c(3)] , '--k','LineWidth', 0.5); % En el eje z rotado

%% ACOTACIÓN DEL ÁNGULO DE ROTACIÓN
plot3(x_arc, zeros(1, 100), z_arc, '-k', 'LineWidth', 0.5);    % Dibujar el arco
text(r * sin(deg2rad(pitch)/2), 0, r * cos(deg2rad(pitch)/2) + 0.1, sprintf('%.2f°', pitch), 'FontSize', 8, 'HorizontalAlignment', 'left');