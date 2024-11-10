clc; clear all;
pause;

%% Comienzo del ejercicio
fprintf('######################################################\n');
fprintf('########### VISUALIZACIÓN DE SINGULARIDADES ##########\n');
fprintf('######################################################\n\n');

robot;
workspace = [-1.5 1.5 -1.5 1.5 -0.5 1.5];

% Primero analizamos las singularidades del par constante q34_singu
q34 = q34_singu(R);

% Visualizamos las singularidades
