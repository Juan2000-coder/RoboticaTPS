function [] = frames(R, q, sistemas, robot, k)
    % R       : robot
    % q       : vector de coordenadas acrticulares
    % sistemas: vector de (1, 8) con 1 para mostrar sistema y 0 para no mostrarlo
    % son 7 sistemas de referencia mas el de la transformación de tool
    % robot   : un booleano que indica si hay que mostrar también el robot
    % k       : los sistemas se muestran comenzando por el que tiene este índice


    % vector de colores
    colores = ["#0072BD", "#D95319", "#EDB120", "#7E2F8E", "#77AC30", "#4DBEEE", "#A2142F", 'k'];

    % plot del robot
    if (robot)
        % ploteo del robot
        R.plot(q,'scale', 0.5, 'jointdiam', 0.85, 'notiles', 'nobase', 'noname');
        hold on;
    end

    % graficar el sistema de referencia base S0
    T = eye(4);
    for i = k:length(R.links) + 1
        if (i == 0)
            T = R.base.T;
        elseif((i > 0)&&(i <= length(R.links)))
            T = T*R.links(i).A(q(i)).T; % Transformación acumulada al link i
        else
            T = T*R.tool.T;
        end

        if sistemas(i + 1)
            % graficar el sistema de referencia correspondiente con el color alternado
            if i == length(R.links) + 1
                trplot(T, 'frame', 'E', 'color', colores(i + 1), 'length', 1.5, 'thick', 1);
            else
                trplot(T, 'frame', num2str(i), 'color', colores(i + 1), 'length', 1.5, 'thick', 1);
            end
            hold on;
        end
    end
    hold off;
end