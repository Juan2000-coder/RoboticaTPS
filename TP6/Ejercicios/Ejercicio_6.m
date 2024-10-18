clc; clear all;
robot_sym;      % robot simbólico
pause;

J   = R.jacob0(q);              % cálculo del jacobiano simbólico
Js  = simplify(J);              % jacobiano simplificado

dJ  = simplify(det(Js));        % determinante simplificado

fprintf("\nExpresión del determinante simplificado:\n");
disp(dJ);

eq = dJ == 0;
fprintf("\nLos puntos singulares se encuentran cuando:\n");
disp(eq);

fprintf("\nDeterminante cuando q5 = 0:\n");
disp(subs(dJ, q5, 0));
fprintf("\nSe obtiene el mismo resultado para q5 = n*pi\n");

dJ  = dJ*2/(a3*a2*sin(q5));      % primera singularidad en q5 == n*pi (n entero)
dJ  = collect(dJ, [a2 a3 d5]);  % agrupación de terminos con el mismo parametro del robot
eq = dJ == 0;
fprintf("\nDivisión por a3*a5*sin(q5):\n");
disp(eq);

fprintf("\nLado izquierdo de la igualdad cuando q3 = 0:\n");
disp(subs(dJ, q3, 0));
fprintf("\nSe obtiene el mismo resultado para q3 = n*pi\n");

eq = expand(eq);
fprintf("\nEcuación expandida:\n");
disp(eq);

fprintf("\nEs posible expresarla como A*C2 + B*S2.\n");
fprintf("\nEn donde A = f(q3, q4) y B = g(q3, q4)\n");
eq    = collect(eq, [cos(q2) sin(q2)]);
disp(eq);

terms = children(lhs(eq)); %Términos en el lado izquierdo de la ecuación.
fprintf("\nA = f(q3, q4):\n");
A = simplify(terms(1)/cos(q2));
disp(A);

fprintf("\nB = g(q3, q4):\n");
B = simplify(terms(2)/sin(q2));
disp(B);

fprintf("\nLuego la ecuación se puede poner como [A, B].[C2; S2].\n");
fprintf("\nAsí, cada par de valores A y B, determinan un vector en el plano.\n");
fprintf("\nY la dirección normal al mismo indica el valor de q2 que da la singularidad.\n");

%{
    Esto da como resultado otro conjunto infinito de singularidades
    dado que para cada par de valores de q3 q4 siempre se puede determinar la dirección
    normal al vector (A, B).
    Dado que S2 y C2 no pueden ser simultáneamente nulos, solo queda determinar
    si es posible que A y B sean simultáneamente nulos para q3 ~= n*pi.
%}

syms Ca Sb Sg
% Ca coseno de alpha. Ca = d5/a3
% Sb seno de beta.    Sb = a3/a2
% Sg seno de gamma.   Sg = d5/a2

A       = A/a3;
A       = simplify(expand(A));
A       = subs(A, d5/a3, Ca);
fprintf("\nA Luego de los reemplazos:\n");
disp(A)

B       = expand(B/a2);
B       = subs(B, d5/a2, Sg);
B       = subs(B, a3/a2, Sb);
B       = simplify(B);
fprintf("\nB Luego de los reemplazos: \n");
disp(B)


