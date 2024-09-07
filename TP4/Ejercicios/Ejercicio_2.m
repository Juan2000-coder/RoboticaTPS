close all;
clear;
clc;

%% Parametros DH robot TP3
DH_tp3 = [0.0 0.1992 0.200 0.000  0;
          0.0 0.0590 0.250 0.000  0;
          0.0 0.0000 0.000 pi     1;
          0.0 0.0375 0.000 0.000  0];

%% Parametros DH robot TP3
DH_tp4 = [0.000 0.195 0.300 0.000 0;
          0.000 0.000 0.250 0.000 0;
          0.000 0.000 0.000 pi    1;
          0.000 0.000 0.000 0.000 0];

%% CONSTRUCCIÓN DE LOS ROBOTS
robot_tp3      = SerialLink(DH_tp3, 'name', 'SCARA IRB-tp3');
robot_tp4      = SerialLink(DH_tp4, 'name', 'SCARA IRB-tp4');

%% VARIABLES ARTICULARES
q = [0 0 0 0];

%% CINEMÁTICA DIRECTA
fprintf("-->Cinemática directa definición del tp3:\n");
T3 = robot_tp3.fkine(q)
fprintf("-->Cinemática directa definición del tp4:\n");
T4 = robot_tp4.fkine(q)

% OFFSET INICIALES
robot_tp3.offset = [0 0 -0.180  0];

%{
    En base a la figura 4 del informe, se ve que
    el punto más alto del efector final se encuentra en
    40.2 + 180 (recorrido) = 220.2 mm.
    Pero en la matriz de DH indicada la diferencia es de 195 mm.
    Entonces asumo un recorrido inicial de 220.2-195 = 25.2 mm.
    Luego el offset que tomo para la variable articular lineal es de 180 - 25.2 = 154.8 mm y 
    toma solo valores positivos entre 0 y 180.
%}
robot_tp4.offset = [0 0 -0.1548 0];

%% LIMITES ARTICCULAREZ
robot_tp3.qlim   = [deg2rad([-140   140]);
                    deg2rad([-150   150]);
                            [ 0     0.180];
                    deg2rad([-400   400])];
robot_tp4.qlim   = robot_tp3.qlim;

%% COMPARACIÓN
% robot tp3
figure(1);
%subplot(1, 2, 1);
robot_tp3.plot(q, 'trail', {'r', 'LineWidth', 2});
robot_tp3.teach();
view(-13.6214, 20.0648);

% robot tp4
%hold on;
figure(2);
%subplot(1, 2, 2);
robot_tp4.plot(q, 'trail', {'b', 'LineWidth', 2});
robot_tp4.teach();
view(-19.3267, 16.5891);


