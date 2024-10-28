clc; clear all; close all;
robot;

q_home = [0 45 -100 0 0 0]*pi/180; %    Home articular

Ty = troty(-160*pi/180);                %Rotacion inclinacion al deposito de pastillas
P1 = [-798.70 425.00 622.76]*1/1000;    %Lejos de la mesa
T1          = eye(4);
T1(1:3,1:3) = Ty(1:3,1:3);
T1(1:3,4)   = P1';                      %Postura 1

P2 = [-843.16 425.00 500.60]*1/1000;    %TCP en el centro de la tapa (0°)
T2          = T1;
T2(1:3,4)   = P2';                      %Postura 2

P3 = P2;                                %Apertura de la tapa (HASTA 360°)
T3 = T2;

P4 = P1;                                %Alejamiento (HASTA 0°)
T4 = T1;

P5 = [-755.00 425.00 483.60]*1/1000;    %Dejar tapa en la mesa

T5          = T4;
T5(1:3,4)   = P5';
Ty          = troty(pi);
T5(1:3,1:3) = Ty(1:3,1:3);

%% TRAYECTORIA MESA CÁMARA DIRECTA
P6 = P1; %Lejos de la mesa

T6 = T1;

P7 = [-708.40 455.73 650.69]*1/1000; %Punto intermedio 1

T7=T6;
T7(1:3,4)=P7';

P8 = [34.17 350.00 362.35]*1/1000; %Punto intermedio 2

T8=T7;
T8(1:3,4)=P8';

P9 = [800.00 350.00 100.00]*1/1000; %Punto intermedio 3 y final con la orientacion para abrir la tapa de la camara (0°)

Tx = trotx(-90*pi/180);

T9 = eye(4);
T9(1:3,1:3) = Tx(1:3,1:3);
T9(1:3,4) = P9';

%%
P10 = [800.00 380.00 100.00]*1/1000; %Aproximacion a la tapa de la camara

T10=T9;
T10(1:3,4)=P10';

P11 = P10; %Apertura de tapa de la camara HASTA 360°

T11 = T10;

P12 = P9; %Alejamiento con la tapa VOLVIENDO A SUS 0° DE Q6 Y ORIENTADO HORIZONTALMENTE

T12 = T9;
Ty=troty(pi);
T12(1:3,1:3) = Ty(1:3,1:3);

P13 = [925.00 250.00 0.00]*1/1000; %Dejar tapa en el suelo

T13 = T12;
T13(1:3,4) = P13';

%% TRAYECTORIA MESA CÁMARA INVERSA
P14 = P12; %Volver de la cámara, punto intermedio 3 y final	
P15 = P8; %Volver de la cámara, punto intermedio 2
P16 = P7; %Volver de la cámara, punto intermedio 1
P17 = P1; %Ir a la mesa

P18 = P2; %Aproximacion a la pastilla

%% TRAYECTORIA MESA CÁMARA DIRECTA
P19 = P1; %Alejamiento con la pastilla
P20 = P7; %Ir a la cámara, punto intermedio 1
P21 = P8; %Ir a la cámara, punto intermedio 2
P22 = P9; %Ir a la cámara, punto intermedio 3 y final

P23 = P10; %Aproximacion con la pastilla a la camara
P24 = P12; %Alejamiento de la camara sin la pastilla
P25 = P10; %Empujar la pastilla a la camara con el gripper cerrado

P26 = P9; %Alejamiento de la camara

P27 = P13; %Recoger la tapa

P28 = P9; % int 3

P29 = P10; %Aproximacion a la camara para cerrar la tapa
P30 = P11; %Cerrar tapa de la camara

%% TRAYECTORIA MESACAMARA INVERSA
P31 = P12; %Alejamiento de la camara P3 INT FIN
P32 = P9; %intermedio 2
P33 = P8; %intermedio 1
P34 = P1; %Ir a la mesa lejos

%%
P35 = P1; %Orientar para agarrar la tapa

P36 = P5; %Buscar la tapa de la mesa
P37 = P1; %lejos de la mesa
P38 = P2; %Aproximarse a la tapa
P39 = P2; %Cerrar la tapa
P40 = q_home; %Home articular

%Cinematicas inversas

q1=UR10E_ikine(R, T1, q_home, true);
q1(6)=0;

q2=UR10E_ikine(R, T2, q1', true);
q3=q2;
q3(6)=q3(6)-2*pi;

q4=UR10E_ikine(R, T4, q3', true);
q5=UR10E_ikine(R, T5, q4', true);

%% MESA CAMARA DIRECTA
q6=UR10E_ikine(R, T6, q5', true);
q7=UR10E_ikine(R, T7, q6', true);
q8=UR10E_ikine(R, T8, q7', true);
q9=UR10E_ikine(R, T9, q8', true);

q10=UR10E_ikine(R, T10, q9', true);
q10(6)=0;
q11=q10;
q11(6)=q11(6)-2*pi;
q12=UR10E_ikine(R, T12, q11', true);
q13=UR10E_ikine(R, T13, q12', true);

