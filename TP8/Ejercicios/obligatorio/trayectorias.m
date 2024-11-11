clc; clear; close all;

puntos;
tiempos;

%% JTRAJ
% Trayectorias individuales
[Qj1, Qj1D, Qj1DD] = jtraj(q_home, q1, t1');
[Qj2, Qj2D, Qj2DD] = jtraj(q1, q2, t1');
[Qj3, Qj3D, Qj3DD] = jtraj(q2, q3, t1');
[Qj4, Qj4D, Qj4DD] = jtraj(q3, q4, t1');
[Qj5, Qj5D, Qj5DD] = jtraj(q4, q5, t1');
[Qj6, Qj6D, Qj6DD] = jtraj(q5, q6, t1');

%% MESA CAMARA DIRECTA
qMC_traj   = mstraj([q7; q8; q9], [], segundos*ones(1, 3), q6, dt, 2);
disp('size de qMC_traj');
disp(size(qMC_traj));

qMC_trajD  = diff(qMC_traj)/dt;  qMC_trajD(end + 1, :) = qMC_trajD(end,:);
qMC_trajDD = diff(qMC_trajD)/dt; qMC_trajDD(end + 1,:) = qMC_trajDD(end,:);

% Trayectorias restantes
[Qj10, Qj10D, Qj10DD] = jtraj(q9, q10, t1');
[Qj11, Qj11D, Qj11DD] = jtraj(q10, q11, t1');
[Qj12, Qj12D, Qj12DD] = jtraj(q11, q12, t1');
[Qj13, Qj13D, Qj13DD] = jtraj(q12, q13, t1');

% Concatenar todas las trayectorias
Qj_all   = [Qj1; Qj2; Qj3; Qj4; Qj5; Qj6; qMC_traj; Qj10; Qj11; Qj12; Qj13];
QjD_all  = [Qj1D; Qj2D; Qj3D; Qj4D; Qj5D; Qj6D; qMC_trajD; Qj10D; Qj11D; Qj12D; Qj13D];
QjDD_all = [Qj1DD; Qj2DD; Qj3DD; Qj4DD; Qj5DD; Qj6DD; qMC_trajDD; Qj10DD; Qj11DD; Qj12DD; Qj13DD];

figure;
R.plot(Qj_all, 'trail', 'r', 'scale', 0.5);  % Traza la trayectoria en rojo
title('Animación de la interpolación entre puntos');

figure;
subplot(3,1,1)
my_qplot(Qj_all, 1.5, dt, 'Variables articulares [rad]', 'q1','q2','q3','q4','q5','q6');
subplot(3,1,2)
my_qplot(QjD_all, 1.5, dt, 'Velocidades articulares [rad/s]', 'q1d','q2d','q3d','q4d','q5d','q6d');
subplot(3,1,3)
my_qplot(QjDD_all, 1.5, dt, 'Aceleraciones articulares [rad/s^2]', 'q1dd','q2dd','q3dd','q4dd','q5dd','q6dd');

%% Cálculo de coordenadas cartesianas de toda la trayectoria
cartesian_positions = zeros(size(Qj_all, 1), 3); % Inicializar matriz para XYZ

for i = 1:size(Qj_all, 1)
    T = R.fkine(Qj_all(i, :));
    cartesian_positions(i, :) = T.t'; % Obtener posición XYZ del efector
end

% Calcular velocidad y aceleración en el espacio XYZ
cartesian_velocity = diff(cartesian_positions) / dt;  % Velocidad en XYZ
cartesian_acceleration = diff(cartesian_velocity) / dt;  % Aceleración en XYZ

% Ajustar tamaño de los vectores de tiempo para graficar
time = linspace(0, dt*(size(Qj_all, 1)-1), size(Qj_all, 1));
time_velocity = linspace(0, dt*(size(cartesian_velocity, 1)-1), size(cartesian_velocity, 1));
time_acceleration = linspace(0, dt*(size(cartesian_acceleration, 1)-1), size(cartesian_acceleration, 1));

% Graficar coordenadas cartesianas
figure;
subplot(3,1,1);
plot(time, cartesian_positions, 'LineWidth', 1.5);
title('Posición en el Espacio XYZ');
xlabel('Tiempo (s)');
ylabel('Posición (m)');
legend('X', 'Y', 'Z');
grid on;

% Graficar velocidad en el espacio XYZ
subplot(3,1,2);
plot(time_velocity, cartesian_velocity, 'LineWidth', 1.5);
title('Velocidad en el Espacio XYZ');
xlabel('Tiempo (s)');
ylabel('Velocidad (m/s)');
legend('Vx', 'Vy', 'Vz');
grid on;

% Graficar aceleración en el espacio XYZ
subplot(3,1,3);
plot(time_acceleration, cartesian_acceleration, 'LineWidth', 1.5);
title('Aceleración en el Espacio XYZ');
xlabel('Tiempo (s)');
ylabel('Aceleración (m/s^2)');
legend('Ax', 'Ay', 'Az');
grid on;

%% CTRAJ

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
