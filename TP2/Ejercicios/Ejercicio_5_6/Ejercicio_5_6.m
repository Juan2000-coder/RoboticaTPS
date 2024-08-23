clear all;
clc;
close all;

%% Ejercicio 5
p        = [0; 0; 1];
pitch    = 45;
R        = troty(pitch ,'deg'); % Matriz de rotación
T        = transl(p);           % Matriz de translación

O_T_M_a = R*T; % a.Primero rotación luego traslación
O_T_M_b = T*R; % b.Primero traslación luego rotación

%% Ejercicio 6
O_p = [0.5; 0; 1; 1];
M_p_a = O_T_M_a \ O_p;
M_p_b = O_T_M_b \ O_p;

fprintf("\nResultados Ejercicio 6:\n");
fprintf("\np en el marco {M} del inciso 5.a: \n");
M_p_a(1:end-1)
fprintf("\np en el marco {M} del inciso 5.b: \n");
M_p_b(1:end-1)

%% plot
figure(1);title('Ejercicio 5');hold on; grid on; axis equal;
view(3.9584, 7.6626);
trplot(eye(3), 'frame', 'O', 'color', 'r', 'length', 2); % Sistema O
trplot(O_T_M_a, 'frame', 'M_a', 'color', 'b', 'length', 1);   % Sistema M_a
trplot(O_T_M_b, 'frame', 'M_b', 'color', 'g', 'length', 1);   % Sistema M_b