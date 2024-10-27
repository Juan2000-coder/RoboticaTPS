Fanuc;       % Definición del robot FANUC
fprintf('######################################################\n');
fprintf('#                Ejercicios 3  TP8                   #\n');
fprintf('######################################################\n\n');
pause;

%% Inciso 1
p1 = [0.0 0.0 0.95];            % Posición incial
p2 = [0.4 0.0 0.95];            % Posición final
qq = [0 -pi/2 -pi/4 0 pi/4 0];  % Posición articular que da la Orientación
R  = fanuc.fkine(qq);           % Matriz homog. que da la Orientación

T1 = R; T1.t = p1;              % Postura inicial
T2 = R; T2.t = p2;              % Postura final
M  = 100;                       % Número de puntos en la interpolacion

T  = ctraj(T1, T2, M);          % Trayectoria interpolada

fprintf("\nGeneración cartesiana entre puntos cartesianos:\n");
fprintf("\np1: \n");disp(p1);
fprintf("\np2: \n");disp(p2);
fprintf("\nR (orientación) : \n");disp(R.R());
fprintf("\nDimensiones de la secuencia cartesiana: \n"); disp(size(T));
fprintf("\nDimensiones de la secuencia articular: \n"); disp(size(Q));

%% Inciso 2
% Trayectoria en coordenadas articulares
Q   = fanuc.ikine(T, 'q0', qq, 'mask', ones(1, 6));

figure(1);
fanuc.plot(Q(1, :), 'scale', 0.65,'jointdiam', 0.65, 'trail', {'r', 'LineWidth', 0.1});
fprintf("\nPresione ENTER para visualizar la animación del robot.\n");
pause;

dt = 0.1;
for q = Q'
    fanuc.animate(q');
    pause(dt);
end

figure(2);
qplot(Q);
