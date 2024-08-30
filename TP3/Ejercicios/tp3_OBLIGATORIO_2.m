clc; clear; close all;

% llamado a robot.m para que cargue el archivo, que esta en el mismo directorio
run('robot.m'); % crea el objeto R

% asegurarse de que R es un objeto SerialLink antes de proceder
if ~exist('R', 'var') || ~isa(R, 'SerialLink')
    error('El objeto R no se ha cargado correctamente como un objeto SerialLink.');
end

% definicion del vector de coordenadas articulares
q_analysis = [0.5, -0.5, 0.5, -0.5, 0.5, -0.5]; 

% definicion booleana para decidir que sistemas se grafican
sistemas = [1, 1, 1, 1, 1, 1, 1];  % graficar los sistemas de referencia incluyendo S0

% definir colores alternados: rojo ('r') y azul ('b')
colors = ['r', 'g'];  % Alternar entre rojo y azul

% ploteo del robot
figure;
R.plot(q_analysis, 'scale', 0.5, 'jointdiam', 0.2, 'notiles');  % Aumentar la escala para mejor visibilidad

hold on;

% graficar el sistema de referencia base S0
trplot(R.base, 'frame', '0', 'color', 'r', 'length', 0.1, 'thick', 2);


for i = 1:length(R.links)
    if sistemas(i + 1)  % sistemas(i + 1) porque ya graficamos S0
        T = R.A(1:i, q_analysis);  % calcula la transformación acumulada hasta el eslabón i
        T = T.T;  % extraer la matriz homogénea de la transformación

        % alternar colores: si el índice es par, usa azul ('b'); si es impar, usa rojo ('r')
        color = colors(mod(i, 2) + 1);

        % graficar el sistema de referencia correspondiente con el color alternado
        trplot(T, 'frame', num2str(i), 'color', color, 'length', 0.1, 'thick', 2);
    end
end

% ajustar los límites de los ejes según el espacio de trabajo
axis([-1 1 -0.6 1 -z_base 1.8]);

hold off;
