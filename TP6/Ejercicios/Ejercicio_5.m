clear all;
clc;
pause;

fprintf('######################################################\n');
fprintf('#                Ejercicios 5  TP6                   #\n');
fprintf('######################################################\n\n');

q  = [pi/6 0.0 pi/6];
dh = [0.0 0.0 1.0 0.0 0;
      0.0 0.0 0.8 0.0 0;
      0.0 0.0 0.6 0.0 0];
R  = SerialLink(dh);
J  = R.jacob0(q);

fprintf("\nJacobiano robot RRR planar:\n");
J = J([1 2 6], :);
disp(J);

fprintf("\nDeterminante Jacobiano robot RRR planar:\n");
disp(det(J));

if (det(J) < eps)
    fprintf("\n-->det(J) < eps\n");
else
    fprintf("\n-->det(J) > eps\n");
end

fprintf("\nRango del Jacobiano:\n");
disp(rank(J));

fprintf("\nLinear dependencies:\n");
jsingu(J);

%5.3.a
v     = [1; 0; 0];
q1    = J\v;
fprintf("\n5.3.a Velocidades articulares para v = [dx dy dyaw] = [1 0 0]:\n");
disp(q1);

%5.3.c
condJ = cond(J);
fprintf("\n5.3.c Número de condición del Jacobiano:\n");
disp(condJ);

%5.3.d
q  = [pi/6 0.001 pi/6];
J  =  R.jacob0(q);
J  = J([1 2 6],:);
q2 = J\v;
fprintf("\n5.3.d. Velocidades articulares para v = [dx dy dyaw] = [1 0 0]:\n");
disp(q2);

%5.3.e
fprintf("\nDeterminante Jacobiano robot RRR planar:\n");
disp(det(J));
fprintf("\n5.3.e.Numero de condición del jacobiano:\n")
disp(cond(J));
