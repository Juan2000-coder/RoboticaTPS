definir_puntos;
definir_tiempos;

%% JTRAJ
% Trayectoria 1
[Qj1, Qj1D, Qj1DD] = jtraj(q_home, q1, t1');
% Trayectoria 2
[Qj2, Qj2D, Qj2DD] = jtraj(q1, q2, t1');

% Trayectoria 3
[Qj3, Qj3D, Qj3DD] = jtraj(q2, q3, t1');

% Trayectoria 4
[Qj4, Qj4D, Qj4DD] = jtraj(q3, q4, t1');

% Trayectoria 5
[Qj5, Qj5D, Qj5DD] = jtraj(q4, q5, t1');

%% MESA CAMARA DIRECTA
qMC_traj = mstraj([q7'; q8'; q9'], [], segundos*ones(1, 3), q6',dt, 0.2);

%%
% Trayectoria 10
[Qj10, Qj10D, Qj10DD] = jtraj(q9, q10, t1');

% Trayectoria 11
[Qj11, Qj11D, Qj11DD] = jtraj(q10, q11, t1');

% Trayectoria 12
[Qj12, Qj12D, Qj12DD] = jtraj(q11, q12, t1');

% Trayectoria 13
[Qj13, Qj13D, Qj13DD] = jtraj(q12, q13, t1');

% Concatenate all Qj matrices by rows
Qj_all = [Qj1; Qj2; Qj3; Qj4; Qj5; qMC_traj; Qj10; Qj11; Qj12; Qj13];

figure(1);
R.plot(q_home, 'scale', 0.65,'jointdiam', 0.65, 'trail', {'r', 'LineWidth', 0.1});
fprintf("\nPresione ENTER para visualizar la animación del robot.\n");
pause;
for q = Qj_all'
    R.animate(q');
    pause(dt);
end
%% CTRAJ

