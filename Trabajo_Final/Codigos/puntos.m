%% HOME
q_home      = [180 0 80 0 0 0]*pi/180;        % Home articular
T_home      = R.fkine(q_home).T;              % Home cartesiano

%% T0, PUNTO PARA ESQUIVAR LA CAMARA
P0          = [-0.09869 0.3683 0.2433];
T0          = trotx(-pi/2);
T0(1:3, 4)  = P0';
q0          = UR10e_ikine(R, T0, q_home, true);

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
P5         = [721.847 346.464 50.000]*1/1000;
T5         = troty(pi);
T5(1:3, 4) = P5';
q5         = UR10e_ikine(R, T5, q4, true);

%% T6 - DEJAR TAPA EN EL SUELO
P6         = [721.847 346.464 10.000]*1/1000;
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

%% T10 - PUNTO DE AGARRE DE LA TAPA Y DE LA PASTILLA
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
q13(6)       = 0;
T13          = R.fkine(q13).T;

%% T14 - DEJAR TAPA EN LA MESA
P14          = [-455.000 750.000 477.603]*1/1000;
T14          = T13;
T14(1:3, 4)  = P14';
q14          = UR10e_ikine(R, T14, q13, true);

%% T15 - VOLVER AL PUNTO INICIAL DE MSTRAJ INVERSO (T9)
q15          = q9;
q15(6)       = q14(6);
T15          = R.fkine(q15).T;
    
%% T16 APROXIMACION A LA PASTILLA Y AGARRE (MISMO PUNTO QUE APROX A TAPA)
q16          = q10;
q16(6)       = q15(6);
T16          = R.fkine(q16).T;

%% T17 ALEJAMIENTO CON LA PASTILLA (MSTRAJ) (MISMO PUNTO Q ALEJ. CON TAPA)
q17          = q12;
q17(6)       = q16(6);
T17          = R.fkine(q17).T;

%% T18 PUNTO INTERMEDIO DE MSTRAJ
q18          = q8; 
q18(6)       = q17(6);
T18          = R.fkine(q18).T;

%% T19 PUNTO FINAL MSTRAJ ENFRENTADO A LA CÁMARA
q19          = q7;
q19(6)       = q18(6);
T19          = R.fkine(q19).T;

%% T20 APROXIMACIÓN A LA CÁMARA PARA METER LA PASTILLA
q20          = q2;
q20(6)       = q19(6);
T20          = R.fkine(q20).T;

%% T21 ALEJARSE DE LA CÁMARA
q21          = q4;
q21(6)       = q20(6);
T21          = R.fkine(q21).T;

%% T22 VOLVER A APROXIMARSE PARA EMPUJAR LA PASTILLA
q22          = q20;
q22(6)       = q21(6);
T22          = R.fkine(q22).T;

%% T23 IR A BUSCAR LA TAPA DEL SUELO
q23          = q5;
q23(6)       = q22(6);
T23          = R.fkine(q23).T;

%% T24 APROXIMARSE A LA TAPA DEL SUELO
q24          = q6;
q24(6)       = q23(6);
T24          = R.fkine(q24).T;

%% T25 ALEJARSE CON LA TAPA DEL SUELO
q25          = q23;
q25(6)       = q24(6);
T25          = R.fkine(q25).T;

%% T26 ENFRENTARSE A LA CÁMARA
q26          = q19;
q26(6)       = q25(6);
T26          = R.fkine(q26).T;

%% T27 APROXIMARSE A LA CÁMARA PARA CERRAR LA TAPA
q27          = q20;
q27(6)       = q26(6);
T27          = R.fkine(q27).T;

%% T28 CERRAR LA TAPA
q28          = q27;
q28(6)       = 2*pi;
T28          = R.fkine(q28).T;

%% T29 ALEJARSE DE LA CÁMARA (PUNTO INICIAL MSTRAJ)
q29          = q26;
q29(6)       = q28(6);
T29          = R.fkine(q29).T;

%% T30 PUNTO INTERMEDIO MSTRAJ
q30          = q18;
q30(6)       = 0;
T30          = R.fkine(q30).T;

%% T31 PUNTO FINAL MSTRAJ
q31         = q9;
q31(6)      = q30(6);
T31         = R.fkine(q31).T;

%% T32 IR AL PUNTO PREVIO A AGARRAR LA TAPA DE LA MESA MSTRAJ
q32         = q13;
q32(6)      = q31(6);
T32         = R.fkine(q32).T;

%% T33 AGARRAR LA TAPA DE LA MESA
q33         = q14;
q33(6)      = q32(6);
T33         = R.fkine(q33).T;

%% T34 ALEJARSE DE LA MESA CON LA TAPA
q34         = q32;
q34(6)      = q33(6);
T34         = R.fkine(q34).T;

%% T35 ENFRENTARSE AL CONTENEDOR CON LA TAPA
q35         = q9;
q35(6)      = q34(6);
T35         = R.fkine(q35).T;

%% T36 APROXIMARSE AL CONTENEDOR CON LA TAPA
q36         = q10;
q36(6)      = q35(6);
T36         = R.fkine(q36).T;

%% T37 CERRAR LA TAPA
q37         = q36;
q37(6)      = 2*pi;
T37         = R.fkine(q37).T;

%% T38 ALEJARSE DEL CONTENEDOR SIN LA TAPA
q38         = q_home;
q38(6)      = 0;
T38         = R.fkine(q38).T;

%% FIN DE LA TRAYECTORIA
