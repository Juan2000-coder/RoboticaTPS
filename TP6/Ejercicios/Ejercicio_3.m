clear all;
clc;
pause;

fprintf('######################################################\n');
fprintf('#                Ejercicios 2_2  TP6                   #\n');
fprintf('######################################################\n\n');

syms q1 q2 q3 a1 a2 a3 real

%% VERIFICACIÓN EJERCICIO 1
q  = [q1 q2];
dh = [0.0 0.0 a1 0.0 0.0;
      0.0 0.0 a2 0.0 0.0];
R  = SerialLink(dh);
J  = simplify(R.jacob0(q));

fprintf("\n Jacobiano robot RR planar del ejercio 1");
J
fprintf("\n Determinante de Jacobiano robot RR planar");
simplify(det(J(1:2,:)))
pause;

%% VERIFICACIÓN 2_1
q  = [q1 q2 q3];
dh = [0.0 0.0 a1 0.0 0;
      0.0 0.0 a2 0.0 0;
      0.0 0.0 a3 0.0 0];
R = SerialLink(dh);
J = simplify(R.jacob0(q));

fprintf("\n Jacobiano robot RRR planar del ejercio 2_1");
J

fprintf("\n Determinante Jacobiano robot RRR planar");
simplify(det(J([1 2 6],:)))
pause;

%% VERIFICACIÓN 2_2
q  = [q1 q2 q3];
dh = [0.0 0.0 0.0 pi/2  0;
      0.0 0.0 0.0 -pi/2 1;
      0.0 0.0 a3  0.0   0];
R = SerialLink(dh);
J = simplify(R.jacob0(q));

fprintf("\n Jacobiano robot RLR planar del ejercio 2_2");
J
fprintf("\n Determinante Jacobiano robot RLR planar");
simplify(det(J([1 2 6],:)))
pause;

%% VERIFICACIÓN 2_3
q  = [q1 q2 q3];
dh = [0.0 0.0 a1 0.0  1;
      0.0 0.0 a2 0.0  0;
      0.0 0.0 a3 0.0  0];
R = SerialLink(dh);
J = simplify(R.jacob0(q));

fprintf("\n Jacobiano robot LRR del ejercio 2_3");
J
fprintf("\n Determinante Jacobiano robot LRR planar");
simplify(det(J(1:3,:)))
pause;