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

fprintf("\n Jacobiano robot RRR planar del ejercio 2_1");
J = J([1 2 6], :)
pause;

fprintf("\n Determinante Jacobiano robot RRR planar");
det(J)
pause;

if (det(J) < eps)
    fprintf("\n det(J) < eps\n");
else
    fprintf("\n det(J) > eps\n");
end

fprintf("\n Rango del Jacobiano");
rank(J)
pause;

fprintf("\n Linear dependencies\n")
jsingu(J)
pause;

%5.3.a
v     = [1; 0; 0];
q1    = J\v;
fprintf("\nVelocidades articulares para v = [dx dy dyaw] = [1 0 0]");
disp(q1);
pause;

%5.3.c
condJ = cond(J);
fprintf("\nEl número de condición del Jacobiano es:")
disp(condJ);
pause;

%5.3.d
q  = [pi/6 0.001 pi/6];
J  =  R.jacob0(q);
J  = J([1 2 6],:);
q2 = J\v;
fprintf("\nVelocidades articulares para v = [dx dy dyaw] = [1 0 0]");
disp(q2);
pause;

%5.3.e
fprintf("\n Determinante Jacobiano robot RRR planar");
disp(det(J));
fprintf("\nEl número de condición del Jacobiano es:")
disp(cond(J));
pause;
