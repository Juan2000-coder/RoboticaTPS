clc; clear all; close all;

% Parámetros DH Fanuc
dh = [0 0.450 0.075 -pi/2 0;
      0 0.000 0.300  0.0  0;
      0 0.000 0.075 -pi/2 0;
      0 0.320 0.000  pi/2 0;
      0 0.000 0.000 -pi/2 0;
      0 0.008 0.000  0.0  0];

% COORDENADAS ARTICULARES
q1 = [0         0        0     0      0       0 ];  % Inciso 1
q2 = [pi/4    -pi/2      0     0      0       0 ];  % Inciso 2
q3 = [pi/5  -2*pi/5  -pi/10  pi/2  3*pi/10 -pi/2];  % Inciso 3
q4 = [-0.61   -0.15   -0.30   1.40   1.90  -1.40];  % Inciso 4
Q  = [q1; q2; q3; q4];                            % Todos los vectores articulares

% OBTENCIÓN DE LA MATRIZ TOTAL
fprintf("Matrices de transformación homogénea: \n\n");
sz = size(Q);
for i = 1:sz(1)      % Recorremos vectores articulares
    T = eye(4);      % Base S0 (todos los casos)
    for k = 1:sz(2)  % Recorremos variables articulares
        q = Q(i, :);
        T = T*dhtrans(dh(k, :), q(k));
    end
    fprintf("-->q_{%d}:", i);
    T
    totales{i} = T; % Guardamos las transformaciones en un cell array
end

% CREACIÓN DEL robot
robot = SerialLink(dh, 'name', 'FANUC');

% REPRESENTACIÓN
figure(1);
hold on;   

views = [150.9342  30.6816;
        -136.8658  12.9623;
        -137.9055  28.7161;
         131.7846  21.5576];

for i = 1:sz(1)
    R = SerialLink(robot, 'name', 'q' + string(i));
    subplot(2, 2, i);
    R.plot(Q(i,:));
    %campos([10 15 10]);
    hold on;
    trplot(eye(4),'length', 1.5, 'frame', '0');
    view(views(i,:))
end

%{
Función qué devuelve la matriz de transformación homogénea
entre sistemas sucesivos
%}

function T = dhtrans(dhrowk, qk)

    % dhrowk: fila k de la matriz DH
    % qk    : variable articular en al fila k de la matriz DH

    theta  = dhrowk(1) + qk;
    d      = dhrowk(2);
    a      = dhrowk(3);
    alpha  = dhrowk(4);

    T = trotz(theta)*transl([0 0 d])*transl([a 0 0])*trotx(alpha);
end