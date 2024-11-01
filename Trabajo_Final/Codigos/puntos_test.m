%% HOME
q_home      = [180 0 80 0 0 0]*pi/180;        % Home articular
T_home      = R.fkine(q_home).T;              % Home cartesiano

%% T1 - Punto INICIAL trayectoria con q6 = 0°
P1          = [500.000 395.000 215.000]*1/1000;
T1          = trotx(-pi/2);
T1(1:3, 4)  = P1';
q1          = UR10e_ikine(R, T1, q_home, true);
q1(6)      = 0;            % q6 = 0

%% T2 - APROXIMACIÓN A LA TAPA DE LA CÁMARA
P2         = [500.000 495.000 215.000]*1/1000;
T2         = T1;
T2(1:3, 4) = P2';
q2         = UR10e_ikine(R, T2, q1, true);

%% T3 - APERTURA TAPA DE LA CÁMARA q6 = -2pi
T3         = T2;
q3         = q2;
q3(6)      = -2*pi;

%% T4 - ALEJAMIENTO
T4         = T1;
%q12        = UR10e_ikine(R, T12, q11, true);
q4         = q1;

%% T5 - PREVIO A DEJAR LA TAPA EN EL SUELO
P5         = [721.847 546.464 50.000]*1/1000;
T5         = troty(pi);
T5(1:3, 4) = P5';
q5         = UR10e_ikine(R, T5, q4, true);

%% T6 - DEJAR TAPA EN EL SUELO
P6         = [721.847 546.464 10.000]*1/1000;
T6         = T5;
T6(1:3, 4) = P6';
q6         = UR10e_ikine(R, T6, q5, true);

%% TRAYECTORIA CAMARA MESA DIRECTA

% T7 - Punto inicial trayectoria mstraj
T7          = T1;
q7          = UR10e_ikine(R, T7, q6, true);

% T8 - Punto intermedio 2 de la trayectoria mstraj
P8          = [260.526 408.133 212.831]*1/1000;
T8          = T7;
T8(1:3, 4)  = P8';
q8          = UR10e_ikine(R, T8, q7, true);
q8(6)       = 0;

% T9 - PUNTO FINAL MSTRAJ - ACERCAMIENTO PREVIO AL DEPOSITO DE PASTILLA
T9          = troty(-160*pi/180);                 % Inclinacion al deposito
P9          = [-507.590 750.000 598.323]*1/1000;  % Lejos de la mesa
T9(1:3, 4)  = P9';
q9          = UR10e_ikine(R, T9, q8, true);
q9(6)       = 0;
T9=R.fkine(q9).T;

%% T10 - PUNTO DE AGARRE DE LA PASTILLA
% T10          = troty(-160*pi/180);                 % Inclinacion al deposito
T10=T9;
P10          = [-541.792 750.000 504.354]*1/1000;  % TCP en el centro de la tapa
T10(1:3, 4)  = P10';
q10          = UR10e_ikine(R, T10, q9, true);
q10(6)=0;

% T9=T10;
% T9(1:3,4)=P9';
% q9          = UR10e_ikine(R, T9, q8, true);

%% T11 - APERTURA DE LA TAPA q6 = -2pi
T11          = T10;
q11          = q10;
q11(6)       = -2*pi;
T11=R.fkine(q11).T;

%% T12 - ALEJAMIENTO Y q6 = 0
T12          = T9;
%q4         = UR10e_ikine(R, T4, q3, true);
q12          = q9;
q12(6)       = -2*pi;

%% T13 - PREVIO A DEJAR LA TAPA EN LA MESA
P13          = [-455.000 750.000 500.000]*1/1000;
T13          = troty(pi);
T13(1:3, 4)  = P13';
q13          = UR10e_ikine(R, T13, q12, true);

%% T14 - DEJAR TAPA EN LA MESA
P14          = [-455.000 750.000 477.603]*1/1000;
T14          = T13;
T14(1:3, 4)  = P14';
q14          = UR10e_ikine(R, T14, q13, true);

%% T15 - VOLVER AL PUNTO INICIAL DE MSTRAJ INVERSO (T9)
T15 = T9;
q15 = q9;

% juntas las matrices de transformación en un arreglo de la forma (4, 4, 13)
posicionesC  = cat(3, T_home, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14);
posicionesQ  = [q_home; q1; q2; q3; q4; q5; q6; q7; q8; q9; q10; q11; q12; q13; q14];
