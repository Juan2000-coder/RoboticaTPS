clc; clear;
pause;

%% Comienzo del ejercicio
fprintf('######################################################\n');
fprintf('########### VISUALIZACIÓN DE SINGULARIDADES ##########\n');
fprintf('######################################################\n\n');

robot;

%{
% Primero analizamos las singularidades del par constante q34_singu
q34 = q34_singu(R);

% Visualizamos las singularidades con mi_teach
mi_teach(R, 'q', [0 0 q34(2, :) 0 0], 'workspace', workspace, 'scale', 0.8, 'jointdiam', 0.8, 'trail', {'r', 'LineWidth', 0.1}, 'frames', true, 'sistemas', [0 1 0 0 0 1 0 0], 'nowrist', 'wrist', 'notiles', 'notiles');

fprintf('Traslación de S5 respecto a S1 en la singularidad q34_1: \n');
disp(R.A(2:5, [1 2 q34(1, :) 3 2]).t);
fprintf('Traslación de S5 respecto a S1 en la singularidad q34_2: \n');
disp(R.A(2:5, [-2 0 q34(2, :) -1 2]).t);
%}

%{
%% Singularidad de q234
q = mi_teach(R, 'q', [1 0.5 0.5 0.5 1 1],'workspace', workspace, 'scale', 0.8, 'jointdiam', 0.8, 'trail', {'r', 'LineWidth', 0.1}, 'nowrist', 'nowrist', 'notiles', 'notiles','frames',true, 'sistemas', [0 1 0 0 0 1 0 0]);
fprintf('Traslación de S5 respecto a S1 en la singularidad q234: \n');
for qi = q'
    disp(R.A(2:5, qi').t);
end
%}

