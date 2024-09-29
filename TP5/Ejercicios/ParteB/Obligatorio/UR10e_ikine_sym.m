clear all;
syms d1 d2 d3 d4 d5 d6 a1 a2 a3 a4 a5 a6
syms q1 q2 q3 q4 q5 q6 q234 q23
syms S1 S2 S3 S4 S5 S6 S23 S234 C1 C2 C3 C4 C5 C6 C23 C234
syms nx ny nz
syms ox oy oz
syms ax ay az
syms px py pz

% parámetros de Denavit-Hartenberg
dh = [0.0   d1   a1    pi/2    0   ;
      0.0   d2   a2    0       0   ;
      0.0   d3   a3    0       0   ;
      0.0   d4   a4    pi/2    0   ;
      0.0   d5   a5    pi/2    0   ;
      0.0   d6   a6    0       0   ];

% vector de variables articulares
q  = [q1 q2 q3 q4 q5 q6]
assume(q1, 'real')
assume(q2, 'real')
assume(q3, 'real')
assume(q4, 'real')
assume(q5, 'real')
assume(q6, 'real')

% objeto que representa al robot
R = SerialLink(dh, 'name', 'UR10e');

% postura
n           = [nx; ny; nz];
o           = [ox; oy; oz];
a           = [ax; ay; az];
p           = [px; py; pz];
T           = [n o a p];
T(4, :)     = [0 0 0 1];
T           = SE3(T);

% lhs equation. T fkine q2 a q6
eq_lhs = SE3(eye(4));
for i = 2:length(R.links)
      eq_lhs = eq_lhs*R.links(i).A(q(i));
end

eq_lhs = simplify(eq_lhs);
eq_lhs = eq_lhs.T;

eq_lhs = subs(eq_lhs, q2 + q3 + q4, q234);
eq_lhs = subs(eq_lhs, q2 + q3, q23);

eq_lhs = subs(eq_lhs, sin(q234), S234);
eq_lhs = subs(eq_lhs, cos(q234), C234);

eq_lhs = subs(eq_lhs, sin(q23), S23);
eq_lhs = subs(eq_lhs, cos(q23), C23);

eq_lhs = subs(eq_lhs, sin(q2), S2);
eq_lhs = subs(eq_lhs, cos(q2), C2);

eq_lhs = subs(eq_lhs, sin(q3), S3);
eq_lhs = subs(eq_lhs, cos(q3), C3);

eq_lhs = subs(eq_lhs, sin(q4), S4);
eq_lhs = subs(eq_lhs, cos(q4), C4);

eq_lhs = subs(eq_lhs, sin(q5), S5);
eq_lhs = subs(eq_lhs, cos(q5), C5);

eq_lhs = subs(eq_lhs, sin(q6), S6);
eq_lhs = subs(eq_lhs, cos(q6), C6);
eq_lhs = simplify(eq_lhs);

eq_lhs = subs(eq_lhs, cos(q5), C5);
eq_lhs = subs(eq_lhs, cos(q6), C6);
eq_lhs_latex = latex(eq_lhs);

% rhs equation. inv(1T0)*T
eq_rhs = R.links(1).A(q(1)).inv()*T;
eq_rhs = simplify(eq_rhs);
eq_rhs = eq_rhs.T;
eq_rhs = subs(eq_rhs, cos(q1), C1);
eq_rhs = subs(eq_rhs, sin(q1), S1);
eq_rhs_latex = latex(eq_rhs);

% equation
eq = eq_rhs == eq_lhs;
eqs = [(1:16)' eq(:)];