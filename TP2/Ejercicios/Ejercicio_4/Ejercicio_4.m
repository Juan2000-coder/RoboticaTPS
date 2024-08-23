clear all;
clc;
close all;

O_p_M        = [7; 4; 0];
M_a          = [2; 1; 0];

%% inciso a
yaw          = -rad2deg(atan2(1, 2));

%% inciso b
M_T_O       = trotz(yaw, 'deg'); %rotación
M_T_O(:, 4) = [O_p_M; 1];        %traslación

%% inciso c
O_a          = M_T_O*[M_a; 1];
O_a          = O_a(1:end-1);

%% resultados
fprintf("\na)El ángulo de rotación es %f °.\n", yaw);
fprintf("\nb)Matriz de transformación homogénea:\n");
M_T_O
fprintf("\nc)Vector respecto del sistema {O}:\n");
O_a

%% verificación gráfica
figure(1);title('Ejercicio 4-c');hold on; grid on; axis equal;
%xlim([-0.2 1.8]);ylim([-0.5 1.7]); %limites de los ejes

trplot(eye(3), 'frame', 'O', 'color', 'r', 'length', 10); % Sistema O
trplot(M_T_O, 'frame', 'M', 'color', 'b', 'length', 3);    % Sistema M

vec = O_a - O_p_M;   % El vector indicado en la figura
quiver(O_p_M(1), O_p_M(2), vec(1), vec(2), 'k', 'LineWidth', 1, 'AutoScale', 'off');

%% GUIAS DE PROYECCCIÓN
plot([O_a(1)  O_a(1)], [0       O_a(2)], '--k', 'LineWidth', 0.5);                        % Plot de las guías
plot([0       O_a(1)], [O_a(2)  O_a(2)], '--k', 'LineWidth', 0.5);

M_x_proy = M_T_O*[M_a(1); 0; 0; 1]; % Vector proyección del punto sobre el eje x rotado
M_y_proy = M_T_O*[0; M_a(2); 0; 1]; % Vector proyección del punto sobre el eje y rotado

plot([M_x_proy(1) O_a(1)], [M_x_proy(2) O_a(2)], '--k','LineWidth', 0.5);
plot([M_y_proy(1) O_a(1)], [M_y_proy(2) O_a(2)], '--k','LineWidth', 0.5);

%% ARCO DE COTA DE ÁNGULO
r         = 0.8; % Radio del arco
theta_arc = linspace(0, deg2rad(yaw), 100);
x_arc     = r * cos(theta_arc);
y_arc     = r * sin(theta_arc);

%% ACOTACIÓN DEL ÁNGULO DE ROTACIÓN
plot(O_p_M(1) + x_arc, O_p_M(2) + y_arc, '-k', 'LineWidth', 0.5);    % Dibujar el arco
text(O_p_M(1) + r * cos(deg2rad(yaw)/2) + 0.1, O_p_M(2) + r * sin(deg2rad(yaw)/2), sprintf('%.2f°', yaw), 'FontSize', 8, 'HorizontalAlignment', 'left');


