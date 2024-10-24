Fanuc;       % Definición del robot FANUC
fprintf('######################################################\n');
fprintf('#                Ejercicios 4  TP8                   #\n');
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

q1 = fanuc.ikine(T1, 'q0', qq, 'mask', ones(1, 6));
q2 = fanuc.ikine(T2, 'q0', qq, 'mask', ones(1, 6));


[Qj, QjD, QjDD] = jtraj(q1, q2, M);   % Interpolación jtraj

T               = ctraj(T1, T2, M);   % Interpolación ctraj

Qc   = fanuc.ikine(T, 'q0', qq, 'mask', ones(1, 6)); % Q con ctraj
QcD  = dq(Qc);                        % Aproximación numérica QD  de ctraj
mQcD  = M*diff(Qc);
QcDD = dq(QcD);                       % Aproximación numérica QDD de ctraj
mQcDD = M*diff(QcD);

fprintf("\nGeneración entre puntos cartesianos:\n");
fprintf("\np1: \n");disp(p1);
fprintf("\np2: \n");disp(p2);
fprintf("\nR (orientación) : \n");disp(R.R());

fprintf("\nResultados de interpolación con jtraj: \n");
fprintf("\nDimensión Qj: \n"); disp(size(Qj));
fprintf("\nDimensión QjD: \n"); disp(size(QjD));
fprintf("\nDimensión QjDD: \n"); disp(size(QjDD));

fprintf("\nResultados de la interpolación con ctraj y derivada numérica: \n");
fprintf("\nDimensión Qc: \n"); disp(size(Qc));
fprintf("\nDimensión QcD: \n"); disp(size(QcD));
fprintf("\nDimensión QcDD: \n"); disp(size(QcDD));


%% Comparaciones gráficas.
figure(1);
my_qplot(Qj, 0.8);
my_qplot(Qc, 1.5);
legend('qj1','qj2','qj3','qj4','qj5','qj6','qc1','qc2','qc3','qc4','qc5','qc6');


figure(2);
hold on;
%my_qplot(QjD, 0.8);
my_qplot(QcD,  0.8);
my_qplot(mQcD, 2.0);
legend('qjd1','qjd2','qjd3','qjd4','qjd5','qjd6','qcd1','qcd2','qcd3','qcd4','qcd5','qcd6');

figure(3);
hold on;
%my_qplot(QjDD, 0.8);
my_qplot(QcDD, 0.8);
my_qplot(mQcDD, 2.0);
legend('qjdd1','qjdd2','qjdd3','qjdd4','qjdd5','qjdd6','qcdd1','qcdd2','qcdd3','qcdd4','qcdd5','qcdd6');

%% Derivada numérica
function d = dq(Q)
    % dq: calcula la derivada de un vector de valores Q utilizando
    % diferencias centradas con extrapolación de Richardson.
    % El paso entre valores consecutivos en el vector es 1.
    
    n = length(Q);       % número de puntos (número de filas)
    h = 1/n;             % paso para tiempo unitario.        
    d = zeros(size(Q));  % vector para almacenar la derivada
    
    % Iterar por los puntos intermedios (no incluidos bordes)
    for i = 2:n-1
        % Paso h
        D_h = (Q(i + 1, :) - Q(i - 1, :)) / (2*h);
        
        % Paso 2*h
        if i > 2 && i < n-1
            D_2h = (Q(i + 2,:) - Q(i - 2,:)) / (4*h);
        else
            % Usamos diferencias centradas simples en los bordes donde no podemos aplicar Richardson
            D_2h = D_h;
        end
        
        % Extrapolación de Richardson
        d(i, :) = (4 * D_h - D_2h) / 3;
    end
    
    % Para los bordes, usamos diferencias centradas simples
    d(1, :) = (Q(2, :) - Q(1, :))/h;    % Aproximación hacia adelante
    d(n, :) = (Q(n, :) - Q(n-1, :))/h;  % Aproximación hacia atrás
end

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