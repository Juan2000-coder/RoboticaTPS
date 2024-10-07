clc;clear all;
robot;
pause;

T           = R.fkine(q);
qq          = ikine_pieper(R, T, q, true);
sz          = size(qq);
cols        = sz(2);
sistemas    = [1 1 1 1 1 1 1 1];

%% VERIFICACIÓN DEL PRIMER PROBLEMA DE PIEPER
%{
R1 = SerialLink(R, 'name', '1');
R2 = SerialLink(R, 'name', '2');
R3 = SerialLink(R, 'name', '3');
R4 = SerialLink(R, 'name', '4');

robots = {R1 R2 R3 R4};
figure;
for (i = 1:cols)
    frames(robots{i}, transpose(qq(:, i)), sistemas, true, 0);
    hold on;
    fprintf("\nPosicion centro de muñeca.\n");
    Taux  = robots{i}.base*robots{i}.A(1:5, transpose(qq(:, i)))*robots{i}.tool;
    Taux.t
end
%}

figure;
for (i = 1:cols)
    trplot(eye(4));
    frames(R, transpose(qq(:, i)), sistemas, true, 0);
    %R.plot(transpose(qq(:, i)), 'scale', 0.5, 'jointdiam', 0.85, 'notiles', 'nobase', 'noname', 'trail',{'r', 'LineWidth', 0.1})
    pause;
end
fprintf("listo chau");