clear all;
clc;
close all;

p        = [0; 0; 1];
pitch    = 45;
R        = troty(pitch ,'deg'); % Matriz de rotación
T        = transl(p);           % Matriz de translación

O_T_M_a = R*T; % a.Primero rotación luego traslación
O_T_M_b = T*R; % b.Primero traslación luego rotación

%% plot
figure(1);title('Ejercicio 5');hold on; grid on; axis equal;
view(3.9584, 7.6626);
trplot(eye(3), 'frame', 'O', 'color', 'r', 'length', 2); % Sistema O
trplot(O_T_M_a, 'frame', 'M_a', 'color', 'b', 'length', 1);   % Sistema M_a
trplot(O_T_M_b, 'frame', 'M_b', 'color', 'g', 'length', 1);   % Sistema M_b