%% Definir el número de puntos para cada interpolación
M      = 30;

%% Generación de Trayectorias
for i = 1:length(posiciones) - 1
    if i == 1
        trajs = ctraj(posiciones(:, :, i), posiciones(:, :, i + 1), M);
    else
        trajs = cat(3, trajs, ctraj(posiciones(:, : ,i), posiciones(:, :, i + 1), M));
    end
end

% Calculo de la Trayectoria articular 
q_sem = q_home;
sz    = size(trajs);
for i = 1:sz(3)
    q_sem = UR10e_ikine(R, trajs(:, : , i), q_sem, true);
    Q(i, :) = q_sem;
end

% Calcular la velocidad y aceleración articulares usando diff
QD  = diff(Q)  / dt;
QDD = diff(QD) / dt;

% Obtener coordenadas cartesianas para cada posición articular usando fkine

X = reshape(trajs(1, 4, :), [1, length(trajs)]);
Y = reshape(trajs(2, 4, :), [1, length(trajs)]);
Z = reshape(trajs(3, 4, :), [1, length(trajs)]);
pos_cartesianas = [X; Y; Z];

% Calcular las velocidades cartesianas
vel_cartesianas = diff([X; Y; Z], 1, 2) / dt;

% Calcular las aceleraciones cartesianas
acc_cartesianas = diff(vel_cartesianas, 1, 2) / dt;