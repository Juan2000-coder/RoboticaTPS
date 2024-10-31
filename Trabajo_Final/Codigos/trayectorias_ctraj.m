clc; clear; close all;
puntos;  % Cargar los puntos y las configuraciones articulares

% Definir el número de puntos para cada interpolación
num_points = 30;  % Número de puntos de interpolación entre cada segmento

% Generar las trayectorias en el espacio cartesiano con ctraj entre cada par de puntos
T_traj0 = ctraj(T_home.T, T1, num_points);
T_traj1 = ctraj(T1, T2, num_points);
T_traj2 = ctraj(T2, T3, num_points);
T_traj3 = ctraj(T3, T4, num_points);
T_traj4 = ctraj(T4, T5, num_points);
T_traj5 = ctraj(T5, T6, num_points);
T_traj6 = ctraj(T6, T7, num_points);
T_traj7 = ctraj(T7, T8, num_points);
T_traj8 = ctraj(T8, T9, num_points);
T_traj9 = ctraj(T9, T10, num_points);
T_traj10 = ctraj(T10, T11, num_points);
T_traj11 = ctraj(T11, T12, num_points);
T_traj12 = ctraj(T12, T13, num_points);

T_traj_all = cat(3, T_traj0, T_traj1, T_traj2, T_traj3, T_traj4, T_traj5, T_traj6, T_traj7, T_traj8, T_traj9, T_traj10, T_traj11, T_traj12);

% Inicializar matriz para almacenar las configuraciones articulares para cada interpolación
Qc_all = [];

% Resolver la cinemática inversa para cada punto de la trayectoria cartesiana usando UR10e_ikine
% Calcular las configuraciones articulares para cada segmento de la trayectoria 

q_sem = q_home;
sz = size(T_traj_all);
for i = 1:sz(3)
    q_sem = UR10e_ikine(R, T_traj_all(:, : , i), q_sem, true);
    Qc_all(i, :) = q_sem;
end

% Calcular la velocidad y aceleración articulares usando diff
dt = 0.1;  % Incremento de tiempo
QcD_all = diff(Qc_all) / dt;
QcDD_all = diff(QcD_all) / dt;

% Inicializar vectores para almacenar las posiciones cartesianas
X = zeros(1, size(Qc_all, 1));
Y = zeros(1, size(Qc_all, 1));
Z = zeros(1, size(Qc_all, 1));

% Obtener coordenadas cartesianas para cada posición articular usando fkine
for i = 1:size(Qc_all, 1)
    T = R.fkine(Qc_all(i, :));  % Calcular la transformación homogénea
    X(i) = T.t(1);              % Extraer la posición X
    Y(i) = T.t(2);              % Extraer la posición Y
    Z(i) = T.t(3);              % Extraer la posición Z
    pos_cartesianas(i, :) = T.t';
end

% Calcular las velocidades cartesianas
vel_cartesianas = diff([X; Y; Z], 1, 2) / dt;

% Calcular las aceleraciones cartesianas
acc_cartesianas = diff(vel_cartesianas, 1, 2) / dt;

% Graficar las trayectorias cartesianas de posición, velocidad y aceleración
% Definir el vector de tiempo para la posición

time = linspace(0, dt*(size(Qc_all, 1)-1), size(Qc_all, 1));
time_velocity = linspace(0, dt*(size(vel_cartesianas, 1)-1), size(vel_cartesianas, 1));
time_acceleration = linspace(0, dt*(size(acc_cartesianas, 1)-1), size(acc_cartesianas, 1));

figure;
R.plot(Qc_all, 'trail', 'r', 'scale', 0.5);  % Traza la trayectoria en rojo
title('Animación de la interpolación entre puntos');

% Graficar coordenadas cartesianas
figure;
subplot(3,1,1);
plot(time, pos_cartesianas, 'LineWidth', 1.5);
title('Posición en el Espacio XYZ');
xlabel('Tiempo (s)');
ylabel('Posición (m)');
legend('X', 'Y', 'Z');
grid on;

subplot(3, 1, 2);
plot(linspace(0, dt*(length(vel_cartesianas)-1), length(vel_cartesianas)), vel_cartesianas', 'LineWidth', 1.5);
title('Velocidad en el Espacio XYZ');
xlabel('Tiempo (s)');
ylabel('Velocidad (m/s)');
legend('VX', 'VY', 'VZ');
grid on;

subplot(3, 1, 3);
plot(linspace(0, dt*(length(acc_cartesianas)-1), length(acc_cartesianas)), acc_cartesianas', 'LineWidth', 1.5);
title('Aceleración en el Espacio XYZ');
xlabel('Tiempo (s)');
ylabel('Aceleración (m/s^2)');
legend('AX', 'AY', 'AZ');
grid on;

figure;
subplot(3,1,1)
my_qplot(Qc_all, 1.5, dt, 'Variables articulares [rad]', 'q1','q2','q3','q4','q5','q6');
subplot(3,1,2)
my_qplot(QcD_all, 1.5, dt, 'Velocidades articulares [rad/s]', 'q1d','q2d','q3d','q4d','q5d','q6d');
subplot(3,1,3)
my_qplot(QcDD_all, 1.5, dt, 'Aceleraciones articulares [rad/s^2]', 'q1dd','q2dd','q3dd','q4dd','q5dd','q6dd');

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



