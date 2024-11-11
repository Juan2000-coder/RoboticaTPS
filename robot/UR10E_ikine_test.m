clc;
clear;
close all;

%% CODIGO PARA PROBAR LA FUNCION UR10E_ikine
pause;
fprintf('######################################################\n')
fprintf('#               PRUEBA UR10e_ikine.m                 #\n')
fprintf('######################################################\n\n')
fprintf('Iniciando prueba de la función UR10E_ikine...\n');

robot;

%% Obtener una serie de posiciones arcitulares.
fprintf('Teach...\n');
Q_test = mi_teach(R, 'workspace', workspace, 'scale', 0.8,'jointdiam', 0.8, 'trail', {'r', 'LineWidth', 0.1});
fprintf('Fin Teach...\n');

%% Obtener la posición cartesiana de cada una de las posiciones articulares.
T_test = R.fkine(Q_test);

%% Obtener las posiciones articulares a partir de las posiciones cartesianas.
for i = 1:size(Q_test, 1)
    Q = UR10e_ikine(R, T_test(i), zeros(1, 6), false);

    % encontrar en Q la fila mas cercana a Q_test(i)
    [~, idx]            = min(vecnorm(Q - ones(size(Q, 1), 1)*Q_test(i, :), 2, 2));
    Q_closest(i, :)     = Q(idx, :);
    Q_ikine(:, :, i)    = Q;
end

for i = 1:size(Q_test, 1)
    fprintf('q_test(%d)\n', i);
    disp(Q_test(i, :));
    fprintf('q_test(%d)_ikine mas cercana \n', i);
    disp(Q_closest(i, :));
end

%% Obtener la posición cartesiana para cada Q_ikine(i, :, j) y compararla con T_test(:, :, j).
for i = 1:size(Q_test, 1)
    T_ikine = R.fkine(Q_ikine(1:end, :, i));
    fprintf('q_test(%d): distancia fkine(q_ikine_test) a T_test(%d) \n', i, i);
    for j = 1:size(Q_ikine, 1)
        % mostrar por pantalla la norma de la diferencia en notación científica con fprintf
        fprintf('%d: %.2e\n', j,norm(T_test(i).T - T_ikine(j).T));
        %norm(T_test(i).T - T_ikine(j).T)
        if mod(j, 10) == 0
            fprintf('Presione enter para continuar...\n');
            pause;
        end
    end
end