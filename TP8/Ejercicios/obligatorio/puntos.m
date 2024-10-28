clc; clear all; close all;
robot;

%% HOME
q_home      = [0 45 -100 0 0 0]*pi/180;        % Home articular
T_home      = R.fkine(q_home);                 % Home cartesiano

%% T1 - ACERCAMIENTO PREVIO AL DEPOSITO DE PASTILLA
T1          = troty(-160*pi/180);              % Inclinacion al deposito
P1          = [-798.70 425.00 622.76]*1/1000;  % Lejos de la mesa
T1(1:3, 4)  = P1';
q1          = UR10E_ikine(R, T1, q_home, true);

%% T2 - PUNTO DE AGARRE DE LA PASTILLA
P2          = [-843.16 425.00 500.60]*1/1000;  % TCP en el centro de la tapa
T2          = T1;
T2(1:3, 4)  = P2';
q2          = UR10E_ikine(R, T2, q1, true);
q2(6)       = 0;                               % q6 = 0

%% T3 - APERTURA DE LA TAPA q6 = -2pi
T3          = T2;
q3          = q2;
q3(6)       = 2*pi;

%% T4 - ALEJAMIENTO Y q6 = 0
T4          = T1;
q4          = UR10E_ikine(R, T4, q3, true);

%% T5 - DEJAR TAPA EN LA MESA
P5          = [-755.00 425.00 483.60]*1/1000;
T5          = troty(pi);
T5(1:3, 4)  = P5';
q5          = UR10E_ikine(R, T5, q4, true);

%% TRAYECTORIA MESA CÁMARA DIRECTA

% T6 - Punto inicial trayectoria
T6          = T1;
q6          = UR10E_ikine(R, T6, q5, true);

% T7 - Punto intermedio 1 de la trayectoria
T7          = T6;
P7          = [-708.40 455.73 650.69]*1/1000;
T7(1:3, 4)  = P7';
q7          = UR10E_ikine(R, T7, q6, true);

% T8 - Punto intermedio 2 de la trayectoria
P8          = [34.17 350.00 362.35]*1/1000;
T8          = T7;
T8(1:3, 4)  = P8';
q8          = UR10E_ikine(R, T8, q7, true);

% T9 - Punto final trayectoria con q6 = 0°
P9          = [800.00 350.00 100.00]*1/1000;
T9          = trotx(-pi/2);
T9(1:3, 4)  = P9';
q9          = UR10E_ikine(R, T9, q8, true);

%% T10 - APROXIMACIÓN A LA TAPA DE LA CÁMARA
P10         = [800.00 380.00 100.00]*1/1000;
T10         = T9;
T10(1:3, 4) = P10';
q10         = UR10E_ikine(R, T10, q9, true);
q10(6)      = 0;            % q6 = 0

%% T11 - APERTURA TAPA DE LA CÁMARA q6 = -2pi
T11         = T10;
q11         = q10;
q11(6)      = 2*pi;

%% T12 - ALEJAMIENTO q6 = 0 Y CON BRIDA HACIA EL SUELO
T12         = troty(pi);
T12(1:3, 4) = P9';
q12         = UR10E_ikine(R, T12, q11, true);

%% T13 - DEJAR TAPA EN EL SUELO
P13         = [925.00 250.00 0.00]*1/1000;
T13         = T12;
T13(1:3, 4) = P13';
q13         = UR10E_ikine(R, T13, q12, true);

% De acá en adelante todos los puntos, matrices y vectores articulares e repiten.
%% TRAYECTORIA MESA CÁMARA INVERSA
T14         = T9;  % Volver de la cámara, punto intermedio 3 y final
T15         = T8;  % Volver de la cámara, punto intermedio 2
T16         = T7;  % Volver de la cámara, punto intermedio 1
T17         = T1;  % Ir a la mesa

%% APROXXIMACIÓN A PASTILLA
T18         = T2

%% TRAYECTORIA MESA CÁMARA DIRECTA
T19         = T1; % Alejamiento con la pastilla
T20         = T7; % Ir a la cámara, punto intermedio 1
T21         = T8; % Ir a la cámara, punto intermedio 2
T22         = T9; % Ir a la cámara, punto intermedio 3 y final

%% T23 - COLOCACIÓN PASTILLA EN CÁMARA
T23         = T10;

%% T24 - ALEJAMIENTO SIN PASTILLA
T24         = T12;

%% T25 - RECOGER TAPA
T25         = T13; 

%% T26 - PUNTO 3
T26         = T9;

%% T27 - COLOCACIÓN TAPA
T27          = T10;

%% T28 - CERRAR TAPA q6 = 0
T28          = T11;

%% TRAYECTORIA MESA CáMARA INVERSA
T29          = T9; % Alejamiento de la camara P3 INT FIN
T30          = T8; % Intermedio 2
T31          = T7; % Intermedio 1
T32          = T1; % Ir a la mesa lejos

%% T33 - BUSCAR TAPA EN LA MESA
T33         = T5;

%% T34 - ALEJAMIENTO
T34         = T1;

%% T35 - COLOCACIÓN TAPA
T35         = T2;

%% T36 - CERRAR TAPA q6 = 0
T36         = T2;
T37         = T_home;