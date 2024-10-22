Fanuc;       % Definición del robot FANUC
fprintf('######################################################\n');
fprintf('#                Ejercicios 1  TP8                   #\n');
fprintf('######################################################\n\n');
pause;

%% Inciso 1
q0  = [0     -pi/2     0    0    0 0];  % Posición inicial
q1  = [-pi/3 pi/10 -pi/5 pi/2 pi/4 0];  % Posición final
ti  = 0;                                % Instante inicial
tf  = 3;                                % Instante final
dt  = 0.1;                              % Paso de tiempo
t   = ti:dt:tf;                         % 3 seg. y una decima de paso
Q   = jtraj(q0, q1, t);                 % Trayectoria interpolada


fprintf("\nInterpolación entre puntos articulares:\n");
fprintf("\nq0: \n");disp(q0);
fprintf("\nq1: \n");disp(q1);
fprintf("\nTrayectoria interpolada: \n"); disp(Q);
fprintf("\nDimensiones de la matriz con posiciones interpoladas: \n"); disp(size(Q));

%% Inciso 2
figure(1);
fanuc.plot(q0, 'scale', 0.65,'jointdiam', 0.65, 'trail', {'r', 'LineWidth', 0.1});
fprintf("\nPresione ENTER para visualizar la animación del robot.\n");
pause;
for q = Q'
    fanuc.animate(q');
    pause(dt);
end

%% Inciso 3
figure(2);
qplot(t', Q);      % Evolución de las variables articulares