function esp_trab()
clc;clear;close all;
    
    robot

    % gefinir los límites articulares del robot y las posiciones extremas
    num_points = 50;      % número de puntos para calcular trayectorias

    % generar trayectorias articulares con jtraj
    R.offset=[0 0 0 pi/2 0 0];
    q_traj1 = jtraj([0 0 0 0 0 0], [2*pi 0 0 0 0 0], num_points);                  % de posición mínima a máxima
    q_traj3 = jtraj([0 pi/2 0 pi/2 pi 0], [0 pi/2+2*pi 0 pi/2 pi 0], num_points);  % de posición máxima a mínima

    q_traj2 = jtraj([pi/2 pi/2 0 pi/2 0 0], [pi/2+2*pi pi/2 0 pi/2 0 0], num_points);  % de posición máxima a mínima

    % crear figuras para las dos vistas 2D del espacio de trabajo
    figure;
    matXY1 = zeros(num_points,3);
    matXY2 = zeros(num_points,3);
    matXZ1 = zeros(num_points,3);
    % vista 1: gráfico en el plano XY
    subplot(1, 2, 1);
    title('Espacio de trabajo: vista XY');
    hold on;
    for i = 1:num_points
        T = R.fkine(q_traj1(i, :));   % calcular la transformación para cada punto
        matXY1(i,:)=T.t;
        T = R.fkine(q_traj2(i, :));   % calcular la transformación para cada punto
        matXY2(i,:)=T.t;
  
    end
    plot(matXY1(:,1),matXY1(:,2),'LineWidth',2,'Color','r');
    plot(matXY2(:,1),matXY2(:,2),'LineWidth',2,'Color','r');
    xlabel('X');
    ylabel('Y');
    grid on;
    axis equal;

    % vista 2: gráfico en el plano XZ
    subplot(1, 2, 2);
    title('Espacio de trabajo: vista XZ');
    hold on;
    for i = 1:num_points
        T = R.fkine(q_traj3(i, :));   % calcular la transformación para cada punto
        matXZ1(i,:)=T.t;
    end

    plot(matXZ1(:,1),matXZ1(:,3),'LineWidth',2,'Color','b');
    xlabel('X');
    ylabel('Z');
    grid on;
    axis equal;

    hold off;
end
