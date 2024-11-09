function posicionesGrabadas = miTeach(R, varargin)
    posicionesGrabadas = [];

    % Verificación del robot
    if (~isa(R, 'SerialLink'))
        ME = MException("miTeach:isSerialLink", "El primer valor pasado a la función debe ser el robot.");
        throw(ME);
    end

    % Definición de los argumentos opcionales
    p = inputParser;
    addOptional(p, 'q', zeros(1, R.n));                 % Posición articular inicial
    addOptional(p, 'workspace', [-1 1 -1 1 0 1]);       % Espacio de trabajo
    addOptional(p, 'scale', 0.5);                       % Escala del plot
    addOptional(p, 'jointdiam', 0.5);                   % Diámetro de las juntas
    addOptional(p, 'trail', {'r', 'LineWidth', 0.1});   % Configuración del rastro
    addOptional(p, 'nowrist', false);                   % Opción de muñeca desactivada

    % Parseo de argumentos
    parse(p, varargin{:});

    % Se obtienen los valores de los argumentos opcionales
    q           = p.Results.q;
    workspace   = p.Results.workspace;
    scale       = p.Results.scale;
    jointdiam   = p.Results.jointdiam;
    trail       = p.Results.trail;
    nowrist     = p.Results.nowrist;

    % Creación de la figura y plot del robot
    fig = figure;
    R.plot(q, 'workspace', workspace, 'scale', scale, 'jointdiam', jointdiam, 'trail', trail);

    % Configuración de sliders para cada articulación
    sliders = gobjects(R.n, 1);
    texts   = gobjects(R.n, 1);

    for i = 1:R.n
        % Creación del slider para la articulación i
        sliders(i)  = uicontrol('Style', 'slider', 'Min', R.qlim(i, 1), ...
            'Max', R.qlim(i, 2), 'Value', q(i), 'Units', 'normalized', ...
            'Position', [0.1, 0.06* i + 0.3, 0.12, 0.02], ...
            'SliderStep', [0.01, 0.01]);
        
        % Etiqueta para mostrar el valor de cada slider
        texts(i)    = uicontrol('Style', 'text', 'Units', 'normalized', ...
            'Position', [0.070, 0.06 * i + 0.3, 0.018, 0.02], ...
            'String', sprintf('%.2f', q(i)));

        uicontrol('Style', 'text', 'Units', 'normalized', ...
            'Position', [0.23, 0.06 * i + 0.3, 0.02, 0.02], ...
            'String', sprintf('q%d', i));
    end

    % Crear el botón "Grabar"
    btnGrabar = uicontrol('Style', 'pushbutton', 'String', 'Grabar', ...
    'Units', 'normalized', 'Position', [0.1, 0.15, 0.1, 0.05], ...
    'Callback', @(~, ~) grabarPosicion());

    % listener dee lso sliders
    addlistener(sliders, 'Value', 'PostSet', @(src, event) updateRobot(R, sliders, texts));

    % Espera a que la figura se cierre para devolver las posiciones grabadas
    waitfor(fig);

    % Función para grabar la posición actual del robot
    function grabarPosicion()
        % Obtiene la posición actual de cada slider
        q_actual = arrayfun(@(s) get(s, 'Value'), sliders);
        
        % Agrega la posición actual como una nueva fila en la matriz
        posicionesGrabadas = [posicionesGrabadas; q_actual'];
        
        % Muestra un mensaje en la consola indicando que se grabó la posición
        disp('Posición grabada:');
        disp(q_actual');
    end
end

% Función auxiliar para actualizar el robot al mover los sliders
function updateRobot(R, sliders, texts)
    % Obtiene el valor actual de cada slider
    q = arrayfun(@(s) get(s, 'Value'), sliders);
    % Actualiza la posición del robot en la gráfica
    R.animate(q');
    for i = 1:R.n
        % Actualiza el texto de cada slider
        set(texts(i), 'String', sprintf('%.2f', q(i)));
    end
end
