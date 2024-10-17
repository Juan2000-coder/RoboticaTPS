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

fprintf("\nJacobiano robot RR planar:\n");
disp(J);
fprintf("\nDeterminante de Jacobiano robot RR planar:\n");
disp(simplify(det(J(1:2,:))));

%% VERIFICACIÓN 2_1
q  = [q1 q2 q3];
dh = [0.0 0.0 a1 0.0 0;
      0.0 0.0 a2 0.0 0;
      0.0 0.0 a3 0.0 0];
R = SerialLink(dh);
J = simplify(R.jacob0(q));

fprintf("\nJacobiano robot RRR planar:\n");
disp(J);

fprintf("\nDeterminante Jacobiano robot RRR planar:\n");
disp(simplify(det(J([1 2 6],:))));

%% VERIFICACIÓN 2_2
q  = [q1 q2 q3];
dh = [0.0 0.0 0.0 pi/2  0;
      0.0 0.0 0.0 -pi/2 1;
      0.0 0.0 a3  0.0   0];
R = SerialLink(dh);
J = simplify(R.jacob0(q));

fprintf("\nJacobiano robot RLR planar:\n");
disp(J);

fprintf("\nDeterminante Jacobiano robot RLR planar:\n");
disp(simplify(det(J([1 2 6],:))));

%% VERIFICACIÓN 2_3
q  = [q1 q2 q3];
dh = [0.0 0.0 a1 0.0  1;
      0.0 0.0 a2 0.0  0;
      0.0 0.0 a3 0.0  0];
R = SerialLink(dh);
J = simplify(R.jacob0(q));

fprintf("\nJacobiano robot LRR:\n");
disp(J);
fprintf("\nDeterminante Jacobiano robot LRR:\n");
disp(simplify(det(J(1:3,:))));