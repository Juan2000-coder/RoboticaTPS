%% Definir el número de puntos para cada interpolación
M      = 30;

%% Generación de Trayectorias DEFINIR Q, QD, QDD Y TRAJS
%% 0 a 1, de home al punto 1, enfrentado a la cámara
[Q0a1, Q0a1D, Q0a1DD]    = jtraj(q_home,q1,M);
T0a1    = R.fkine(Q0a1).T;

%% Aproximación a la tapa de la cámara
T1a2    = ctraj(T1,T2,M);
% Calculo de la Trayectoria articular 
q_sem = Q0a1(end,:);

for i = 1:length(T1a2)
    q_sem = UR10e_ikine(R, T1a2(:, : , i), q_sem, true);
    Q1a2(i, :) = q_sem;
end

Q1a2D=diff(Q1a2)/dt;
Q1a2DD=diff(Q1a2D)/dt;

%% Apertura de la tapa de la camara
[Q2a3, Q2a3D, Q2a3DD]    = jtraj(Q1a2(end,:),q3,M);
T2a3    = R.fkine(Q2a3).T;

%% Alejamiento, con la tapa
T3a4    = ctraj(T3,T4,M);
% Calculo de la Trayectoria articular 
q_sem = Q2a3(end,:);

for i = 1:length(T3a4)
    q_sem = UR10e_ikine(R, T3a4(:, : , i), q_sem, true);
    Q3a4(i, :) = q_sem;
end

Q3a4D=diff(Q3a4)/dt;
Q3a4DD=diff(Q3a4D)/dt;

%% Horizonal al suelo, previo a dejar la tapa
[Q4a5, Q4a5D, Q4a5DD]    = jtraj(Q3a4(end,:),q5,M);
T4a5    = R.fkine(Q4a5).T;

%% Se deja la tapa en el suelo
T5a6    = ctraj(T5,T6,M);
% Calculo de la Trayectoria articular 
q_sem = Q4a5(end,:);

for i = 1:length(T5a6)
    q_sem = UR10e_ikine(R, T5a6(:, : , i), q_sem, true);
    Q5a6(i, :) = q_sem;
end

Q5a6D=diff(Q5a6)/dt;
Q5a6DD=diff(Q5a6D)/dt;

%% Se va al primer punto de la trayectoria entre camara y mesa
[Q6a7, Q6a7D, Q6a7DD] = jtraj(Q5a6(end,:),q7,M);
T6a7    = R.fkine(Q6a7).T;

%% TRAYECTORIA CÁMARA MESA DIRECTA (7,8,9)
qCM_traj1   = mstraj([q8; q9], [], segundos*ones(1, 2), q7, dt, 2);
qCM_traj1D  = diff(qCM_traj1)/dt;
qCM_traj1DD = diff(qCM_traj1D)/dt;
T7a9        = R.fkine(qCM_traj1(end,:)).T;

%% Aproximacion recta a los contenedores de pastillas
T9a10   = ctraj(T9,T10,M);
% Calculo de la Trayectoria articular 
q_sem = qCM_traj1(end,:);

for i = 1:length(T9a10)
    q_sem = UR10e_ikine(R, T9a10(:, : , i), q_sem, true);
    Q9a10(i, :) = q_sem;
end

Q9a10D=diff(Q9a10)/dt;
Q9a10DD=diff(Q9a10D)/dt;

%[Q9a10, Q9a10D, Q9a10DD] = jtraj (qCM_traj(end,:),q10,M);

%% Apertura de la tapa
[Q10a11, Q10a11D, Q10a11DD] = jtraj(q10,q11,M);
T10a11  = R.fkine(Q10a11).T;

%%
% T11a12  = ctraj(T11,T12,M);
% % Calculo de la Trayectoria articular 
% q_sem = Q10a11(end,:);
% 
% for i = 1:length(T11a12)
%     q_sem = UR10e_ikine(R, T11a12(:, : , i), q_sem, true);
%     Q11a12(i, :) = q_sem;
% end

%% Alejamiento con la tapa
[Q11a12, Q11a12D, Q11a12DD] = jtraj(q11,q12,M);
T11a12  = R.fkine(Q11a12).T;

%% Camino al punto previo a dejar la tapa, horizontal
[Q12a13, Q12a13D, Q12a13DD] = jtraj(q12,q13,M);
T12a13  = R.fkine(Q12a13).T;

%%
% T13a14  = ctraj(T13,T14,M);
% % Calculo de la Trayectoria articular 
% q_sem = Q12a13(end,:);
% 
% for i = 1:length(T13a14)
%     q_sem = UR10e_ikine(R, T13a14(:, : , i), q_sem, true);
%     Q13a14(i, :) = q_sem;
% end

%% Dejar la tapa en la mesa
[Q13a14, Q13a14D, Q13a14DD] = jtraj(q13,q14,M);
T13a14  = R.fkine(Q13a14).T;

%% Volver al punto enfrentado al contenedor de pastillas
[Q14a15, Q14a15D, Q14a15DD] = jtraj(q14,q15,M);
T14a15  = R.fkine(Q14a15).T;

%% Aproximación a la pastilla

T15a16 = ctraj(T15,T16,M);
% Calculo de la Trayectoria articular
q_sem = Q14a15(end,:);
for i = 1:length(T15a16)
    q_sem = UR10e_ikine(R, T15a16(:, : , i), q_sem, true);
    Q15a16(i, :) = q_sem;
end

Q15a16D=diff(Q15a16)/dt;
Q15a16DD=diff(Q15a16D)/dt;

%% Alejamiento con la pastilla
[Q16a17, Q16a17D, Q16a17DD] = jtraj(q16,q17,M);
T16a17  = R.fkine(Q16a17).T;

%% Mstraj hasta la camara
qMC_traj1   = mstraj([q18; q19], [], segundos*ones(1, 2), q17, dt, 2);
qMC_traj1D = diff(qMC_traj1)/dt;
qMC_traj1DD = diff(qMC_traj1D)/dt;
T17a19  = R.fkine(qMC_traj1(end,:)).T;

%% Aproximacion para dejar la pastilla en la camara
T19a20 = ctraj(T19,T20,M);
% Calculo de la Trayectoria articular
q_sem = qMC_traj1(end,:);
for i = 1:length(T19a20)
    q_sem = UR10e_ikine(R, T19a20(:, : , i), q_sem, true);
    Q19a20(i, :) = q_sem;
end

Q19a20D=diff(Q19a20)/dt;
Q19a20DD=diff(Q19a20D)/dt;

%% Alejamiento de la camara
[Q20a21, Q20a21D, Q20a21DD] = jtraj(q20,q21,M);
T20a21  = R.fkine(Q20a21).T;

%% Empujar la pastilla
T21a22 = ctraj(T21,T22,M);
% Calculo de la Trayectoria articular
q_sem = Q20a21(end,:);
for i = 1:length(T21a22)
    q_sem = UR10e_ikine(R, T21a22(:, : , i), q_sem, true);
    Q21a22(i, :) = q_sem;
end

Q21a22D=diff(Q21a22)/dt;
Q21a22DD=diff(Q21a22D)/dt;

%% Ir a buscar la tapa del suelo
[Q22a23, Q22a23D, Q22a23DD] = jtraj(q22,q23,M);
T22a23  = R.fkine(Q22a23).T;

%% Aproximarse a la tapa del suelo
T23a24 = ctraj(T23,T24,M);
% Calculo de la Trayectoria articular
q_sem = Q22a23(end,:);
for i = 1:length(T23a24)
    q_sem = UR10e_ikine(R, T23a24(:, : , i), q_sem, true);
    Q23a24(i, :) = q_sem;
end

Q23a24D=diff(Q23a24)/dt;
Q23a24DD=diff(Q23a24D)/dt;

%% Alejarse con la tapa del suelo
[Q24a25, Q24a25D, Q24a25DD] = jtraj(q24,q25,M);
T24a25  = R.fkine(Q24a25).T;

%% Enfrentarse a la camara
[Q25a26, Q25a26D, Q25a26DD] = jtraj(q25,q26,M);
T25a26  = R.fkine(Q25a26).T;

%% Aprox a la camara para cerrar la tapa
T26a27 = ctraj(T26,T27,M);
% Calculo de la Trayectoria articular
q_sem = Q25a26(end,:);
for i = 1:length(T26a27)
    q_sem = UR10e_ikine(R, T26a27(:, : , i), q_sem, true);
    Q26a27(i, :) = q_sem;
end

Q26a27D=diff(Q26a27)/dt;
Q26a27DD=diff(Q26a27D)/dt;

%% Cerrar la tapa
[Q27a28, Q27a28D, Q27a28DD] = jtraj(q27,q28,M);
T27a28  = R.fkine(Q27a28).T;

%% Alejarse de la camara
[Q28a29, Q28a29D, Q28a29DD] = jtraj(q28,q29,M);
T28a29  = R.fkine(Q28a29).T;

%% Mstraj, qCM_traj2
qCM_traj2   = mstraj([q30; q31; q32], [], segundos*ones(1, 3), q29, dt, 2);
qCM_traj2D = diff(qCM_traj2)/dt;
qCM_traj2DD = diff(qCM_traj2D)/dt;
T29a31  = R.fkine(qCM_traj2(end,:)).T;

%% Agarrar la tapa de la mesa
[Q32a33, Q32a33D, Q32a33DD] = jtraj(q32,q33,M);
T32a33  = R.fkine(Q32a33).T;

%% Alejarse de la mesa con la tapa
[Q33a34, Q33a34D, Q33a34DD] = jtraj(q33,q34,M);
T33a34  = R.fkine(Q33a34).T;

%% Enfrentarse al contenedor con la tapa
[Q34a35, Q34a35D, Q34a35DD] = jtraj(q34,q35,M);
T34a35  = R.fkine(Q34a35).T;

%% Aproximarse con la tapa
T35a36 = ctraj(T35,T36,M);
% Calculo de la Trayectoria articular
q_sem = Q34a35(end,:);

for i = 1:length(T35a36)
    q_sem = UR10e_ikine(R, T35a36(:, : , i), q_sem, true);
    Q35a36(i, :) = q_sem;
end

Q35a36D=diff(Q35a36)/dt;
Q35a36DD=diff(Q35a36D)/dt;

%% Cerrar la tapa
[Q36a37, Q36a37D, Q36a37DD] = jtraj(q36,q37,M);
T36a37  = R.fkine(Q36a37).T;

%% Alejarse del contenedor sin la tapa y homing
[Q37a38, Q37a38D, Q37a38DD] = jtraj(q37,q_home,M);
T37a38  = R.fkine(Q37a38).T;

%% FIN

%%Q, QD, QDD Y TRAJS

Q = [Q0a1; Q1a2; Q2a3; Q3a4; Q4a5; Q5a6; Q6a7; qCM_traj1; Q9a10; Q10a11; Q11a12; Q12a13; Q13a14; Q14a15; Q15a16; Q16a17; qMC_traj1; Q19a20; Q20a21; Q21a22; Q22a23; Q23a24; Q24a25; Q25a26; Q26a27; Q27a28; Q28a29; qCM_traj2; Q32a33; Q33a34; Q34a35; Q35a36; Q36a37; Q37a38];

QD = [Q0a1D; Q1a2D; Q2a3D; Q3a4D; Q4a5D; Q5a6D; Q6a7D; qCM_traj1D; Q9a10D; Q10a11D; Q11a12D; Q12a13D; Q13a14D; Q14a15D; Q15a16D; Q16a17D; qMC_traj1D; Q19a20D; Q20a21D; Q21a22D; Q22a23D; Q23a24D; Q24a25D; Q25a26D; Q26a27D; Q27a28D; Q28a29D; qCM_traj2D; Q32a33D; Q33a34D; Q34a35D; Q35a36D; Q36a37D; Q37a38D];

QDD = [Q0a1DD; Q1a2DD; Q2a3DD; Q3a4DD; Q4a5DD; Q5a6DD; Q6a7DD; qCM_traj1DD; Q9a10DD; Q10a11DD; Q11a12DD; Q12a13DD; Q13a14DD; Q14a15DD; Q15a16DD; Q16a17DD; qMC_traj1DD; Q19a20DD; Q20a21DD; Q21a22DD; Q22a23DD; Q23a24DD; Q24a25DD; Q25a26DD; Q26a27DD; Q27a28DD; Q28a29DD; qCM_traj2DD; Q32a33DD; Q33a34DD; Q34a35DD; Q35a36DD; Q36a37DD; Q37a38DD];

trajs = [ ];

function dX = numerical_derivative(X, dt)
    % X es la matriz de entrada de tamaño NxM, donde N es el número de puntos y M es el número de variables
    % dt es el intervalo de tiempo o espaciado entre puntos
    % dX es la matriz de derivadas con el mismo tamaño que X
    
    % Inicializar la matriz de derivadas con ceros
    dX = zeros(size(X));
    
    % Diferencias centradas para los puntos intermedios
    dX(2:end-1, :) = (X(3:end, :) - X(1:end-2, :)) / (2 * dt);
    
    % Diferencia hacia adelante para el primer punto
    dX(1, :) = (X(2, :) - X(1, :)) / dt;
    
    % Diferencia hacia atrás para el último punto
    dX(end, :) = (X(end, :) - X(end-1, :)) / dt;
end
