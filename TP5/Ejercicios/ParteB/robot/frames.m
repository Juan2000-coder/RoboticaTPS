function [] = frames(R, q, sistemas, robot, colores)
    if (robot)
        % ploteo del robot
        R.plot(q,'workspace',[-3 3 -3 3 -0 4],'scale', 0.5, 'jointdiam', 0.85, 'notiles', 'nobase');
        hold on;
    end

    % graficar el sistema de referencia base S0
    for i = 0:length(R.links) + 1
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
        end
    end
    hold off;
end