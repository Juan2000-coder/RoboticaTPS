% plot_robot.m

clc; clear; close all;

% llamado a robot.m para que cargue el archivo, que esta en el mismo directorio
robot; %crea el objeto R

% definicion del vector de coordenadas articulares
q_analysis = [0.5, -0.5, 0.5, -0.5, 0.5, -0.5]; 

% definicion booleana para decidir que sistemas se grafican
sistemas = [1, 1, 1, 1, 1, 1, 1];  %graficar todos los sistemas de referencia

% ploteo del robot
figure;
R.plot(q_analysis, 'scale', 0.7, 'jointdiam', 0.5, 'notiles');

hold on;

%bucle para graficar todos los sistemas
for i = 1:length(sistemas)
    if sistemas(i)
        % obtener la transformacion homogenea desde la base al sistema i
        T = R.fkine(q_analysis, 'link', i-1);  % 'link', i-1 porque i-1 representa el sistema {i-1}
        
        trplot(T, 'frame', num2str(i-1), 'color', 'b', 'length', 100, 'thick', 2);
    end
end

hold off;

