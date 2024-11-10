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
Q_test = mi_teach(R, 'workspace', workspace, 'scale', 0.8,'jointdiam', 0.8, 'trail', {'r', 'LineWidth', 0.1});

%% Obtener la posición cartesiana de cada una de las posiciones articulares.
T_test = R.fkine(Q_test);

%% Obtener las posiciones articulares a partir de las posiciones cartesianas.

for i = 1:size(Q_test, 1)
    Q = UR10e_ikine(R, T_test(i), zeros(1, 6), false);

    % encontrar en Q la fila mas cercana a Q_test(i)
    [~, idx] = min(vecnorm(Q - ones(size(Q, 1), 1)*Q_test(i, :), 2, 2));
    Q_ikine_closest(i, :) = Q(idx, :);
    Q_test_ikine(1:size(Q, 1), :, i) = Q;
end

% Para cada posición articular original, imprimirla junto con la posición articular más cercana obtenida.



% Sucede que el método si resuelve la posición articular original
% pero no necesariamente esa solución se encuentra en las primeras 8 soluciones.
% sino que se puede encontrar en el resto desde la 9 a la 512.

% Cuando la posición articular de test tiene q5 = 0
% esa solución original no se encuentra dentro del set de soluciones
% que arroja UR10e_ikine por el tema de la singularidad.
% y eso es evidente porque cuando ocurre la singularidad, nosotros arrojamos
% una solución particular de forma arbitraria sin modificar las fórmulas.
% Las soluciones que arroja con q5 = 0 no son para nada exactas
% pero también la función arroja otras soluciones que si lo son (todas las otras).

% Cuando la posición articular de test tiene q3 = 0
% da warning cuando se calcula el discriminante en la parte del cálculo de q2_complejo
% en la línea 100 de UR10e_ikine.m
% y eso es evidente porque el punto está fuera del alcance del robot.
% Se visualiza gráficamente porque q3 corresponde al codo 
% que al estar en cero significa que el brazo está completamente extendido
% en ese caso la función da soluciones aproximadas y soluciones exactas
% y también puede encontrar la posición articular original que dio origen a 
% la postura.
% Recordamos aca que q3 era una condición de singularidad que obtuvimos
% en el análisis de velocidades.

% Para otras posiciones cercanas al máximo alcance del robot también da warning
% en la misma línea 100 de UR10e_ikine.m, al menos de lo que probé.
% el otro warning, el del cálculo de q1 no se en qué casos podrá suceder.


for i = 1:size(Q_test, 1)
    fprintf('q_test(%d)\n', i);
    disp(Q_test(i, :));
    fprintf('q_test(%d)_ikine mas cercana \n', i);
    disp(Q_ikine_closest(i, :));
end

fprintf('Presione enter para continuar...\n');
pause;

%% Obtener la posición cartesiana para cada Q_test_ikine(i, :, j) y compararla con T_test(:, :, j).
for i = 1:size(Q_test, 1)
    T_test_ikine = R.fkine(Q_test_ikine(1:end, :, i));
    fprintf('q_test(%d): distancia fkine(q_ikine_test) a T_test(%d) \n', i, i);
    for j = 1:size(Q_test_ikine, 1)
        disp(norm(T_test(i).T - T_test_ikine(j).T));
        if mod(j, 10) == 0
            fprintf('Presione enter para continuar...\n');
            pause;
        end
    end
end