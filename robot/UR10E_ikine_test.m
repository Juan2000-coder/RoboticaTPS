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
f = figure;
R.plot(q, 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
global q_final;

% Espera a que se cierre la ventana
waitfor(f);

% teach propio.
teach(R, f);
R.teach('callback', @(~,~) update_position(R));

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
addlistener(hSlider, 'Value', 'PostSet', @(src, event) updateRobot(R, Q, time, hSlider, hText))
function updateRobot(R, Q, t, hSlider, hText)
    % Obtener el valor del slider y redondearlo
    idx = round(get(hSlider, 'Value'));
    
    % Asegurar que el índice esté en rango
    idx = min(max(idx, 1), length(t));
    
    % Actualizar la posición del robot y el texto
    R.animate(Q(idx, :));
    set(hText, 'String', sprintf('Time: %.2f', t(idx)));
end

% La última posición articular se almacena en q_final
disp('Última posición articular:');
disp(q_final);

% Función para actualizar la posición articular
function update_position(robot)
    global q_final;
    q_final = robot.getpos(); % Obtiene y guarda la última posición articular
end