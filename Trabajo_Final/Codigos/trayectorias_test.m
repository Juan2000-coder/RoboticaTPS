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
qCM_traj   = mstraj([q8; q9], [], segundos*ones(1, 2), q7, dt, 2);

qCM_trajD = diff(qCM_traj)/dt;
qCM_trajDD = diff(qCM_trajD)/dt;
  
%% TRAYECTORIA MESA CÁMARA (CÁMARA MESA INVERSA), calculo para usar luego
qMC_traj   = flipud(qCM_traj);

qMC_trajD = diff(qMC_traj)/dt;
qMC_trajDD = diff(qMC_trajD)/dt;

%% Aproximacion recta a los contenedores de pastillas
T9a10   = ctraj(T9,T10,M);
% Calculo de la Trayectoria articular 
q_sem = qCM_traj(end,:);

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

%% Matriz de todos los vectores de las trayectorias, vel y acc articulares
Q = [Q0a1; Q1a2; Q2a3; Q3a4; Q4a5; Q5a6; Q6a7; qCM_traj; Q9a10; Q10a11; Q11a12; Q12a13; Q13a14]; 

QD = [Q0a1D; Q1a2D; Q2a3D; Q3a4D; Q4a5D; Q5a6D; Q6a7D; qCM_trajD; Q9a10D; Q10a11D; Q11a12D; Q12a13D; Q13a14D];

QDD = [Q0a1DD; Q1a2DD; Q2a3DD; Q3a4DD; Q4a5DD; Q5a6DD; Q6a7DD; qCM_trajDD; Q9a10DD; Q10a11DD; Q11a12DD; Q12a13DD; Q13a14DD];

Traj = [T0a1, T1a2, T2a3, T3a4, T4a5, T5a6, T6a7, T9a10, T10a11, T11a12, T12a13, T13a14];
