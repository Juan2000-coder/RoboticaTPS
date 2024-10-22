Fanuc;       % Definición del robot FANUC
fprintf('######################################################\n');
fprintf('#                Ejercicios 2  TP8                   #\n');
fprintf('######################################################\n\n');
pause;

%% Inciso 1
p1 = [0.0 0.0 0.95];            % Posición incial
p2 = [0.4 0.0 0.95];            % Posición final
qq = [0 -pi/2 -pi/4 0 pi/4 0];  % Posición articular que da la Orientación
R  = fanuc.fkine(qq);           % Matriz homog. que da la Orientación

T1 = R; T1.t = p1;              % Postura inicial
T2 = R; T2.t = p2;              % Postura final

q1   = fanuc.ikine(T1, 'q0', qq, 'mask', ones(1, 6));
q2   = fanuc.ikine(T2, 'q0', qq, 'mask', ones(1, 6));

Q    = jtraj(q1, q2, 100);      % Trayectoria interpolada

fprintf("\nGeneración entre puntos cartesianos:\n");
fprintf("\np1: \n");disp(p1);
fprintf("\np2: \n");disp(p2);
fprintf("\nR (orientación) : \n");disp(R.R());
fprintf("\nTrayectoria interpolada: \n"); disp(Q);
fprintf("\nDimensiones de la matriz con posiciones interpoladas: \n"); disp(size(Q));

%% Inciso 2
figure(1);
fanuc.plot(q1, 'scale', 0.65,'jointdiam', 0.65, 'trail', {'r', 'LineWidth', 0.1});
fprintf("\nPresione ENTER para visualizar la animación del robot.\n");
pause;

dt = 0.1;
for q = Q'
    fanuc.animate(q');
    pause(dt);
end

figure(2);
qplot(Q);
