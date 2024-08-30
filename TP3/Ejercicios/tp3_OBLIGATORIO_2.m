% plot_robot.m

clc; clear; close all;

% a. Llamado del archivo "robot.m" para tener definido el objeto "R" en la memoria.
robot;  % Este comando asume que "robot.m" está en el mismo directorio y define el objeto R.

% b. Definición de un vector de posiciones articulares que se desee analizar.
q_analysis = [0.5, -0.5, 0.5, -0.5, 0.5, -0.5];  % Ejemplo de configuración articular

% c. Definición de un vector de booleanos para indicar qué sistemas de referencia se desean visualizar.
sistemas = [1, 1, 1, 1, 1, 1, 1];  % Ejemplo: graficar todos los sistemas de referencia

% d. Ploteo del robot en la posición definida en b.
figure;
R.plot(q_analysis, 'scale', 0.7, 'jointdiam', 0.5, 'notiles');

% Activar "hold on" para superponer sistemas de referencia adicionales.
hold on;

% e. Bucle para recorrer todos los sistemas posibles del robot y graficarlos.
for i = 1:length(sistemas)
    if sistemas(i)
        % Obtener la transformación homogénea de la base hasta el eslabón i
        T = R.fkine(q_analysis, 'link', i-1);  % 'link', i-1 porque i-1 representa el sistema {i-1}
        
        % Graficar el sistema de referencia con trplot
        trplot(T, 'frame', num2str(i-1), 'color', 'b', 'length', 100, 'thick', 2);
    end
end

% Mantener la visualización
hold off;

