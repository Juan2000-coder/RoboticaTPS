puntos;
tiempos;

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

% Trayectoria 6
[Qj6, Qj6D, Qj6DD] = jtraj(q5, q6, t1');

%% MESA CAMARA DIRECTA
qMC_traj   = mstraj([q7; q8; q9], [], segundos*ones(1, 3), q6, dt, 0.2);
disp('size de qMC_traj');
disp(size(qMC_traj));

qMC_trajD  = diff(qMC_traj)/dt;  qMC_trajD(end + 1, :) = qMC_trajD(end,:);
qMC_trajDD = diff(qMC_trajD)/dt; qMC_trajDD(end + 1,:) = qMC_trajDD(end,:);

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
Qj_all   = [Qj1; Qj2; Qj3; Qj4; Qj5; Qj6; qMC_traj; Qj10; Qj11; Qj12; Qj13];
QjD_all  = [Qj1D; Qj2D; Qj3D; Qj4D; Qj5D; Qj6D; qMC_trajD; Qj10D; Qj11D; Qj12D; Qj13D];
QjDD_all = [Qj1DD; Qj2DD; Qj3DD; Qj4DD; Qj5DD; Qj6DD; qMC_trajDD; Qj10DD; Qj11DD; Qj12DD; Qj13DD];

figure(1);
R.plot(q_home, 'scale', 0.65,'jointdiam', 0.65, 'trail', {'r', 'LineWidth', 0.1});
fprintf("\nPresione ENTER para visualizar la animación del robot.\n");
pause;

i = 0; % home
for q = Qj_all'
    R.animate(q');
    for i = 1:13
        if (q' == eval(['q', num2str(i)]))
            disp(['en q', num2str(i)])
        end
    end
    pause(dt);
end

figure(2)
my_qplot(Qj_all, 0.5);
figure(3)
my_qplot(QjD_all, 0.5);
figure(4)
my_qplot(QjDD_all, 2);

%% CTRAJ

function my_qplot(q, l)
    % l: Ancho de las líneas.
    % q: matriz de posiciones articulares

    t = (1:numrows(q))';
    hold on;
    plot(t, q(:,1:3), 'LineWidth', l);
    plot(t, q(:,4:6), '--', 'LineWidth', l);
    grid on;
    xlabel('Time (s, n°)');
    ylabel('Joint coordinates (rad,m)');
    hold off;
    xlim([t(1), t(end)]);
end