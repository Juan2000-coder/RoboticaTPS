run("robot.m")
T = [0.866, -0.5, 0, 0.8;    % Primera fila: valores de rotación y posición en x
     0.5, 0.866, 0, 0.3;     % Segunda fila: valores de rotación y posición en y
     0, 0, 1, 0.4;           % Tercera fila: valores de rotación y posición en z
     0, 0, 0, 1];            % Cuarta fila: parte homogénea (siempre fija)

Q=UR10E_ikine(R,T)