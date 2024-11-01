%% Ejecuta la simulación solamente a partir del Q previamente calculado
clc; clear; close all;

robot;          % Llama al robot
puntos_test;         % Define las T
tiempos;        % Define los tiempos
trayectorias_test;   % Define las trayectorias
time       = linspace(0, dt*(size(Q, 1) - 1), size(Q, 1));

% Hacer el plot del robot con Q con trail en rojo
% figure;
% R.plot(Q,'scale', 1,'jointdiam', 1, 'trail', {'r', 'LineWidth', 1});  % Traza la trayectoria en rojo
% title('Animación de la interpolación entre puntos');

% Crea el slider
hSlider = uicontrol('Style', 'slider', 'Min', 1, 'Max', length(time), ...
    'Value', 1, 'Units', 'normalized', ...
    'Position', [0.1, 0.0, 0.8, 0.05], ...
    'SliderStep', [1/(length(time)-1), 1/(length(time)-1)]);

% Texto que mostrará el tiempo actual
hText = uicontrol('Style', 'text', 'Units', 'normalized', ...
    'Position', [0.1, 0.05, 0.8, 0.05], ...
    'String', sprintf('Time: %.2f', time(1)));

% Actualiza el robot y el texto cuando el slider cambia
addlistener(hSlider, 'Value', 'PostSet', @(src, event) updateRobot(R, Q, time, hSlider, hText));


% Graficar coordenadas cartesianas
% figure;
% subplot(3,1,1);
% plot(time, pos_cartesianas, 'LineWidth', 1.5);
% title('Posición en el Espacio XYZ');
% xlabel('Tiempo (s)');
% ylabel('Posición (m)');
% legend('X', 'Y', 'Z');
% grid on;
% 
% subplot(3, 1, 2);
% plot(linspace(0, dt*(length(vel_cartesianas)-1), length(vel_cartesianas)), vel_cartesianas', 'LineWidth', 1.5);
% title('Velocidad en el Espacio XYZ');
% xlabel('Tiempo (s)');
% ylabel('Velocidad (m/s)');
% legend('VX', 'VY', 'VZ');
% grid on;
% 
% subplot(3, 1, 3);
% plot(linspace(0, dt*(length(acc_cartesianas)-1), length(acc_cartesianas)), acc_cartesianas', 'LineWidth', 1.5);
% title('Aceleración en el Espacio XYZ');
% xlabel('Tiempo (s)');
% ylabel('Aceleración (m/s^2)');
% legend('AX', 'AY', 'AZ');
% grid on;

figure;
subplot(3,1,1)
my_qplot(Q, 1.5, dt, 'Variables articulares [rad]', 'q1','q2','q3','q4','q5','q6');
subplot(3,1,2)
my_qplot(QD, 1.5, dt, 'Velocidades articulares [rad/s]', 'q1d','q2d','q3d','q4d','q5d','q6d');
subplot(3,1,3)
my_qplot(QDD, 1.5, dt, 'Aceleraciones articulares [rad/s^2]', 'q1dd','q2dd','q3dd','q4dd','q5dd','q6dd');

function updateRobot(R, Q, t, hSlider, hText)
    % Obtener el valor del slider y redondearlo
    idx = round(get(hSlider, 'Value'));
    
    % Asegurar que el índice esté en rango
    idx = min(max(idx, 1), length(t));
    
    % Actualizar la posición del robot y el texto
    R.animate(Q(idx, :));
    set(hText, 'String', sprintf('Time: %.2f', t(idx)));
end

function my_qplot(q, l, dt, titulo, x1, x2, x3, x4, x5, x6)
    % l: Ancho de las líneas.
    % q: matriz de posiciones articulares

    t = (1:numrows(q))'.*dt;
    hold on;
    plot(t, q(:,1:3), 'LineWidth', l);
    plot(t, q(:,4:6), '--', 'LineWidth', l);
    grid on;
    xlabel('Tiempo (s)');
    ylabel(titulo);
    legend(x1, x2, x3, x4, x5, x6);
    hold off;
    xlim([t(1), t(end)]);
end