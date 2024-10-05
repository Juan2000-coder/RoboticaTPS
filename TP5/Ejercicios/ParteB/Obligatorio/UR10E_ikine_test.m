clc;clear;close all;

robotFile = fullfile(fileparts(mfilename('fullpath')), '../../../../robot/robot');
run(robotFile);

% % Postura problema
% T = [0.866  -0.500 0.000 0.800;
%      0.500   0.866 0.000 0.300;
%      0.000   0.000 1.000 0.400;
%      0.000   0.000 0.000 1.000];

%Caso con soluciones singulares

T = [0.0000    0.0000   1.0000    0.2907;
    -0.7071    0.7071   0.0000    0.4459;
    -0.7071   -0.7071   0.0000    0.6306;
     0.0000    0.0000   0.0000    1.0000];

% Posición en la postura inicial
figure(1);
R.plot(q, 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
hold on;
trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);

mejor = false;

% Resolución analítica
qq = UR10E_ikine(R, T, zeros(1,6), mejor);

if(mejor)
    figure(2);
    R.plot(qq(:, 1)', 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
    hold on;
    trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);

else

    % Robots para cada una de las soluciones
    R1 = SerialLink(R, 'name','q1');
    R2 = SerialLink(R, 'name','q2');
    R3 = SerialLink(R, 'name','q3');
    R4 = SerialLink(R, 'name','q4');
    R5 = SerialLink(R, 'name','q5');
    R6 = SerialLink(R, 'name','q6');
    R7 = SerialLink(R, 'name','q7');
    R8 = SerialLink(R, 'name','q8');
    
    figure(2);
    R1.plot(qq(:, 1)', 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
    hold on;
    trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);

        
    figure(3);
    R2.plot(qq(:, 2)', 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
    hold on;
    trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);
    
    figure(4);
    R3.plot(qq(:, 3)', 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
    hold on;
    trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);
    
    figure(5);
    R4.plot(qq(:, 4)', 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
    hold on;
    trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);
    
    figure(6);
    R5.plot(qq(:, 5)', 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
    hold on;
    trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);
    
    figure(7);
    R6.plot(qq(:, 6)', 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
    hold on;
    trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);
    
    figure(8);
    R7.plot(qq(:, 7)', 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
    hold on;
    trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);
    
    figure(9);
    R8.plot(qq(:, 8)', 'workspace', workspace, 'scale', 0.5,'jointdiam', 0.85, 'trail', {'r', 'LineWidth', 0.1});
    hold on;
    trplot(T, 'frame', 'E', 'color', 'red', 'length', 0.8);
    hold on;

end

